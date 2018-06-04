%% Runs a single pulse height distribution and countrate measurement
% Requires:
% 1. Lakeshore temperature controller
% 2. Keysight B2902A sourcemeter
% 3. Keysight 53220A frequency counter

% First, clean up
delete( instrfind );
close all;
clear;
clc;

%% Open instrument communication
tic;

SMU = SMU_open_gpib( [ ] ); % Use default address
COUNTER = COUNTER_open_gpib( [ ] ); % Use default address

%% Sweep parameters and record data

% Top-level sweep: sourcemeter bias voltage

VA_list = 12.0 : 0.1 : 16.0;    % 300K

channel = 1;
compliance = 10e-3;  % 10mA

% 2nd-level sweep: frequency counter threshold voltage
% MUST be in 2.5mV steps (resolution of the DAC in the instrument)
delta_thresh = 2.5e-3;
Vt_list = 0 : delta_thresh : 25e-3;     % Make sure to sweep through the DC offset of the opamp
delta_T = 0.1;
bins = 10;

data_cells = cell( 1, length( VA_list ) );

for i = 1 : length( VA_list )
    t_start = toc;
    disp( [ 'Running bias point ' num2str( i ) ' of ' num2str( length( VA_list ) ) '.' ] );
    
    Vt_list_current = Vt_list; % Copy over so that we can modify it
    SMU_set_voltage( SMU, channel, VA_list( i ), compliance );
    
    [ temp_inst_id, temps_last ] = TEMP_get_temps( [ ], [ ] ); % default addr, verbose output
    
    pulse_CDF_mean = zeros( 1, length( Vt_list ) );
    pulse_CDF_std = zeros( 1, length( Vt_list ) );
    for j = 1 : length( Vt_list )
        % Could do something better than mean to get error bars, add later
        raw_counts = COUNTER_run_single_totalize( COUNTER, 'POS', Vt_list_current( j ), delta_T, bins );
        pulse_CDF_mean( j ) = mean( raw_counts );
        pulse_CDF_std( j ) = std( raw_counts );
    end
    
    % If the highest threshold was still picking up counts, keep increasing
    % it until no more counts are picked up
    while pulse_CDF_mean( end ) ~= 0
        next_thresh = Vt_list_current( end ) + delta_thresh;
        Vt_list_current = [ Vt_list_current next_thresh ];
        raw_data = COUNTER_run_single_totalize( COUNTER, 'POS', Vt_list_current( end ), delta_T, bins );
        pulse_CDF_mean = [ pulse_CDF_mean mean( raw_data ) ];
        pulse_CDF_std = [ pulse_CDF_std std( raw_data ) ];
    end
    
    pulse_PDF_mean = -1 * diff( pulse_CDF_mean );
    pulse_PDF_mean( pulse_PDF_mean < 0 ) = 0; % Delete counts picked up below output DC offset of opamp
    Vt_bin_centers = ( Vt_list_current( 1 : end - 1 ) + Vt_list_current( 2 : end ) ) / 2;
    
    data_cells{ i }.temp_readings = temps_last;
    data_cells{ i }.VA = VA_list( i );
    % Save raw pulse CDF
    data_cells{ i }.Vt_list_current = Vt_list_current;
    data_cells{ i }.pulse_CDF_mean = pulse_CDF_mean;
    data_cells{ i }.pulse_CDF_std = pulse_CDF_std;
    % Save calculated pulse PDF
    data_cells{ i }.Vt_bin_centers = Vt_bin_centers;
    data_cells{ i }.pulse_PDF_mean = pulse_PDF_mean;
    % Save start and stop time of this iteration
    data_cells{ i }.t_start = t_start;
    data_cells{ i }.t_stop = toc;
end

SMU_set_output_off( SMU );

%% Close instrument communication
fclose( SMU );
fclose( COUNTER );

runtime = toc;
disp( [ 'Runtime was ' num2str( runtime ) ' seconds.' ] );

%% Save workspace to mat file
save( 'room_temp_test_10x_0pt1s.mat' );
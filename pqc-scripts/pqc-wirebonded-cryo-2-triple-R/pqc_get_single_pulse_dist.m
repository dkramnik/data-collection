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

%% Manually record the PQC parameters here
pqc.RQ = 3*68e3;
pqc.RS = 25;
pqc.Rf1 = 1e3;
pqc.Rf2 = 100;
pqc.gain = 10;          % 1k : 100
pqc.c_comp = 100e-12;   % 100fF comp. cap.
pqc.type = 'wirebonded';

%% Sweep parameters and record data

% Top-level sweep: sourcemeter bias voltage

VA_range = 3.0;
VA_delta = 0.1;

filename = 'pqc_wirebonded_cryo_2_fast_laser_20mA_140K.mat';
if exist( filename, 'file' )
    error( 'Filename already exists! Aborting run.' );
end
%VA_start = 12.0;    % 300K
% 290K
%VA_start = 11.8;    % 280K
% 270K
%VA_start = 11.7;    % 260K
% 250K
%VA_start = 11.6;    % 240K
% 230K
%VA_start = 11.5;    % 220K
% 210K
%VA_start = 11.3;    % 200K
%VA_start = 11.2;    % 190K
%VA_start = 11.1;    % 180K
%VA_start = 10.9;    % 170K
%VA_start = 10.8;    % 160K
%VA_start = 10.7;    % 150K
VA_start = 10.6;    % 140K
%VA_start = 10.6;    % 130K
%VA_start = 10.6;    % 120K
%VA_start = 10.6;    % 110K
%VA_start = 10.6;    % 100K

VA_list = VA_start : VA_delta : ( VA_start + VA_range );    % 300K

channel = 1;
compliance = 10e-3;  % 10mA

% 2nd-level sweep: frequency counter threshold voltage
% MUST be in 2.5mV steps (resolution of the DAC in the instrument)
delta_thresh = 2.5e-3;
Vt_list = 0 : delta_thresh : 25e-3;     % Make sure to sweep through the DC offset of the opamp
delta_T = 0.01;
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

%% TODO: delete everything we DON'T want to save to the mat file (eg. 'i')

%% Save workspace to mat file
save( filename );
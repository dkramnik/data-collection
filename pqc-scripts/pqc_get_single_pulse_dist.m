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

% Figure parameters
lw = 1.25;
fs = 14;

% Top-level sweep: sourcemeter bias voltage
%VA_list = linspace( 10, 14, 101 );
VA_list = 12.0 : 0.1 : 15.0;
channel = 1;
compliance = 1e-3;  % 1mA

% 2nd-level sweep: frequency counter threshold voltage
% MUST be in 2.5mV steps (resolution of the DAC in the instrument)
Vt_list = 0 : 2.5e-3 : 100e-3;
delta_T = 1;
bins = 1;

data_cells = cell( 1, length( VA_list ) );

for i = 1 : length( VA_list )
    disp( [ 'Running bias point ' num2str( i ) ' of ' num2str( length( VA_list ) ) '.' ] );

    SMU_set_voltage( SMU, channel, VA_list( i ), compliance );
    
    pulse_CDF = zeros( 1, length( Vt_list ) );
    for j = 1 : length( Vt_list )
        % Could do something better than mean to get error bars, add later
        pulse_CDF( j ) = mean( COUNTER_run_single_totalize( COUNTER, 'POS', Vt_list( j ), delta_T, bins ) );
    end
    
    pulse_PDF = -1 * diff( pulse_CDF );
    pulse_PDF( pulse_PDF < 0 ) = 0; % Delete counts picked up below output DC offset of opamp
    Vt_bin_centers = ( Vt_list( 1 : end - 1 ) + Vt_list( 2 : end ) ) / 2;
    
    % Save VA
    data_cells{ i }.VA = VA_list( i );
    % Save raw pulse CDF
    data_cells{ i }.Vt_list = Vt_list;
    data_cells{ i }.pulse_CDF = pulse_CDF;
    % Save calculated pulse PDF
    data_cells{ i }.Vt_bin_centers = Vt_bin_centers;
    data_cells{ i }.pulse_PDF = pulse_PDF;
end

%% Plot total pulses vs. overbias
figure( )

CDF_peaks = zeros( 1, length( data_cells ) );
for i = 1 : length( data_cells )
    CDF_peaks( i ) = max( data_cells{ i }.pulse_CDF );
end
plot( VA_list, CDF_peaks / delta_T, 'o--', 'linewidth', lw );
grid on;

xlabel( 'V_A [V]' );
ylabel( 'Counts in 1s' );
set( gca, 'fontsize', fs );

%% Plot CDF vs. overbias
figure( )

for i = 1 : length( data_cells )
    plot( 1e3 * data_cells{ i }.Vt_list, data_cells{ i }.pulse_CDF );
    hold on;
end
grid on;

xlabel( 'V_{thres.} [mV]' );
ylabel( 'Pulses in Bin' );
legend( sprintfc( 'V_A = %.1fV', VA_list ) );
set( gca, 'fontsize', fs );

%% Plot PDF vs. overbias
figure( )

for i = 1 : length( data_cells )
    plot( 1e3 * data_cells{ i }.Vt_bin_centers, data_cells{ i }.pulse_PDF );
    hold on;
end
grid on;

xlabel( 'V_{thres.} [mV]' );
ylabel( 'Pulses in Bin' );
legend( sprintfc( 'V_A = %.1fV', VA_list ) );
set( gca, 'fontsize', fs );

%% Plot PDF peak V_thres and height vs. overbias
figure( )

PDF_peaks = zeros( 1, length( data_cells ) );
PDF_peak_thresh = zeros( 1, length( data_cells ) );
for i = 1 : length( data_cells )
    [ PDF_peaks( i ), ind ] = max( data_cells{ i }.pulse_PDF );
    PDF_peak_thresh( i ) = data_cells{ i }.Vt_bin_centers( ind );
end
yyaxis left
plot( VA_list, PDF_peaks, 'o--', 'linewidth', lw );
hold on;
ylabel( 'PDF Peak Value [Counts]' );

yyaxis right
plot( VA_list, 1000 * PDF_peak_thresh, 'o--', 'linewidth', lw );
ylabel( 'PDF Peak Bin [mV]' );

grid on;

xlabel( 'V_A [V]' );
set( gca, 'fontsize', fs );

%% Close instrument communication
fclose( SMU );
fclose( COUNTER );

disp( toc );

%% Save workspace to mat file
save( 'room_temp_test_1s.mat' );
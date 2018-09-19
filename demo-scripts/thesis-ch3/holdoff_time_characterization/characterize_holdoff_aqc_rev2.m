% Uses single-period measurements to find the holdoff time vs. DAC setting

delete( instrfind );    % Clean up any previous GPIB accidents

close all
clear
clc

% Open instruments
AQC = AQC_open_serial( 2 );
COUNTER = COUNTER_open_gpib( [ ] );

AQC_write_mode( AQC, 'IV_TEST' );

% Basic settings so that AQC operates correctly
VA = 12.35;
comp_thres = 0.90;

AQC_set_VA_bias( AQC, VA );
AQC_set_comp_thres( AQC, comp_thres );

holdoff_min = 200;
holdoff_max = 1600;
holdoff_length = 20;
holdoff_list = holdoff_min + (holdoff_max - holdoff_min ) * ...
    log( linspace( exp( 0 ), exp( 1 ), holdoff_length) );
holdoff_list = round( holdoff_list );

%%
raw_pulse_width_data = cell( length( holdoff_list ) );

for i = 1 : length( holdoff_list )
    % Set the holdoff time
    AQC_write_mode( AQC, 'IV_TEST' );
    AQC_write_dac( AQC, 1, 2, num2str( holdoff_list( i ), '%04d' ) );
    AQC_write_mode( AQC, 'AQC' );
    
    raw_pulse_width_data{ i } = COUNTER_run_single_pulse_width( COUNTER, 'POS', 1000, 'true' );
end

AQC_write_mode( AQC, 'IV_TEST' );

save( 'holdoff_time_characterization_data.mat' );

%% Process and plot results
load( 'holdoff_time_characterization_data.mat' );

fig1 = figure( );

fs = 14;
lw = 1.25;

pulse_width_mean = zeros( size( holdoff_list ) );
pulse_width_std = zeros( size( holdoff_list ) );

for i = 1 : length( holdoff_list )
    pulse_width_mean( i ) = mean( raw_pulse_width_data{ i } );
    pulse_width_std( i ) = std( raw_pulse_width_data{ i } );
end

plot( holdoff_list, 1e6 * pulse_width_mean, 'o', 'linewidth', lw );
hold on;

holdoff_list_interp = holdoff_list( 1 ) : 1 : holdoff_list( end );
% Create interpolation
pulse_width_interp = interp1( holdoff_list, pulse_width_mean, holdoff_list_interp, 'pchip' );
plot( holdoff_list_interp, 1e6 * pulse_width_interp, '--', 'linewidth', lw );

legend( 'Data', 'Interpolation', 'location', 'NW' );

xlabel( 'Holdoff DAC Setting' );
ylabel( 'Holdoff Time Mean [us]' );

set( gca, 'fontsize', fs );

grid on;

save_figure_as_pdf( fig1, 'holdoff_time_characterization' );

% Now print the required holdoff settings for some desired holdoff times
holdoff_times_desired = [ 1e-6, 3.33e-6, 5e-6, 10e-6 ];

for i = holdoff_times_desired
    disp( [ 'Desired holdoff time = ' num2str( i, '%.2e' ) ] );
    [ val, ind ] = min( abs( pulse_width_interp - i ) );
    disp( [ 'Required holdoff DAC setting = ' num2str( holdoff_list_interp( ind ) ) ] );
end
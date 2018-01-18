% Script for sweeping bias voltage and holdoff time to observe the effects
% on TCR, DCR, and afterpulsing
% TODO: add GPIB laser control option for measuring PDP

delete( instrfind );    % Clean up any previous GPIB accidents

close all
clear
clc

[ temp_inst_id, temps ] = TEMP_get_temps( [], true );   % addr = default, verbose = true
if isempty( temps )
    temp_inst_id = 'Manual Entry';
    temps = input( 'Enter temperature manually: ' );
end

VA_list = linspace( 10.9, 11.3, 5 );
comp_thres_list = [ 0.925, 0.925, 0.925, 0.925, 0.900 ];
holdoff_list = 1300 + (1600 - 1300 ) * log( linspace( exp( 0 ), exp( 1 ), 5) );
%holdoff_list = logspace( log10( 1300 ), log10( 1600 ), 5 );
num_points = 10000;

% DAC val. '1572' = 10us holdoff
% '1300' is min, '1640' is max. with R47 = 10kohm
% Range is 5us to 16us
%ONE_SHOT = '1572';
%AQC_write_dac( AQC, 1, 2, ONE_SHOT )

raw_data = cell( length( VA_list ), length( holdoff_list ) );

for i = 1 : length( VA_list )
    % Set the bias voltage and comp. threshold
    AQC_write_mode( [], 'IV_TEST' );
    AQC_set_VA_bias( [], VA_list( i ) );
    AQC_set_comp_thres( [], comp_thres_list( i ) );
    AQC_write_mode( [], 'AQC' );
    
    for j = 1 : length( holdoff_list )
        % Set the holdoff time
        AQC_write_mode( [], 'IV_TEST' );
        AQC_write_dac( [], 1, 2, num2str( holdoff_list( j ) ) );
        AQC_write_mode( [], 'AQC' );

        % Take interarrival time measurements
        raw_data{ i, j } = COUNTER_run_single_period( num_points, [], [] );
    end
end

% Save .mat file with the data collected in the workspace
save( [ 'AQC-sweep-data_' datestr( now, 'mm-dd-yyyy_HH-MM-SS' ) ] );
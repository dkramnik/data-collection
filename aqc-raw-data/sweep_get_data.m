% Script for sweeping bias voltage and holdoff time to observe the effects
% on TCR, DCR, and afterpulsing
% TODO: add GPIB laser control option for measuring PDP

delete( instrfind );    % Clean up any previous GPIB accidents

close all
clear
clc

% Create an AQC object to pass to each write function for faster execution
AQC = AQC_open_serial( [] );

Device = 'D2';
Diameter = '10e-6';

% User should use a sourcemeter to find the breakdown voltage
AQC_write_mode( AQC, 'IV_TEST' );
V_BR = input( 'Enter breakdown voltage (100uA current) manually: ' );
AQC_write_mode( AQC, 'AQC' );

%%
[ temp_inst_id, temps ] = TEMP_get_temps( [], true );   % addr = default, verbose = true
if isempty( temps )
    temp_inst_id = 'Manual Entry';
    temps = input( 'Enter temperature manually: ' );
end
disp( temps );

%% Manually adjust VA and holdoff sweep parameters here
VA_start = 10.70;
VA_end = 11.10;
VA_delta = 0.10;
num_VA = 1 + ( VA_end - VA_start ) / VA_delta;
VA_list = linspace( VA_start, VA_end, num_VA );
%comp_thres_list = linspace( 0.95, 0.925, num_VA );
%VA_list =         [ 10.85, 10.90, 11.00, 11.05, 11.10, 11.15, 11.20, 11.25, 11.30];
comp_thres_list = [ 0.95, 0.945, 0.940, 0.925, 0.925 ]; 

% DAC val. '1572' = 10us holdoff
% ~'1300' is min for reliable triggering, '1640' is max. with R47 = 10kohm
% Range is 5us to 16us
holdoff_min = 1400;
holdoff_max = 1500;
holdoff_length = 2;
holdoff_list = holdoff_min + (holdoff_max - holdoff_min ) * ...
    log( linspace( exp( 0 ), exp( 1 ), holdoff_length) );
holdoff_list = round( holdoff_list );

%holdoff_length = 1;
%holdoff_list = [ 1400 ];

num_points = 1000;
num_groups = 1;    % 10 groups of 1000 measurements

raw_data = cell( length( VA_list ), length( holdoff_list ) );

for i = 1 : length( VA_list )
    % Set the bias voltage and comp. threshold
    AQC_write_mode( AQC, 'IV_TEST' );
    AQC_set_VA_bias( AQC, VA_list( i ) );
    AQC_set_comp_thres( AQC, comp_thres_list( i ) );
    AQC_write_mode( AQC, 'AQC' );
    
    for j = 1 : length( holdoff_list )
        % Set the holdoff time
        AQC_write_mode( AQC, 'IV_TEST' );
        AQC_write_dac( AQC, 1, 2, num2str( holdoff_list( j ) ) );
        AQC_write_mode( AQC, 'AQC' );

        % Take interarrival time measurements
        for k = 1 : num_groups
            disp( [ 'VA_ind (i) = ' num2str( i ) ', holdoff_ind (j) = ' num2str( j ) ', Group (k) = ' num2str( k ) ] );
            raw_data{ i, j } = [ raw_data{ i, j }, COUNTER_run_single_period( num_points / num_groups, [], [] ) ];
        end
    end
end

% Disconnect SPAD after test is done
AQC_write_mode( AQC, 'IV_TEST' );

% End serial communication
fclose( AQC );

% Name of experiment run
laser = 0;
run_name = 'LL3';

% Save .mat file with the data collected in the workspace
save( [ run_name '-AQC-sweep-data_' datestr( now, 'mm-dd-yyyy_HH-MM-SS' ) ] );
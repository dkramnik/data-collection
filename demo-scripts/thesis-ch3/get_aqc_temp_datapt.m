% Script for sweeping bias voltage and holdoff time to observe the effects
% on TCR, DCR, and afterpulsing
% TODO: add GPIB laser control option for measuring PDP

delete( instrfind );    % Clean up any previous GPIB accidents

close all
clear
clc

% Start script
tic;

% Name of experiment run
run_name = 'cryo-run1';
Device = 'D7';
Diameter = '10e-6';

% Create an AQC object to pass to each write function for faster execution
AQC = AQC_open_serial( 2 );
SMU = SMU_open_gpib( [ ] );
COUNTER = COUNTER_open_gpib( [ ] );

% Use a sourcemeter to automatically find the breakdown voltage
AQC_write_mode( AQC, 'IV_TEST' );

SMU_channel = 1;
SMU_voltage = 15;
SMU_compliance = 100e6;
V_BR = SMU_set_voltage( SMU, SMU_channel, SMU_voltage, SMU_compliance );
disp( V_BR );
SMU_set_output_off( SMU );
fclose( SMU );

%% Get temps from Lakeshore controller

[ temp_inst_id, temps ] = TEMP_get_temps( [], true );   % addr = default, verbose = true
if isempty( temps )
    temp_inst_id = 'Manual Entry';
    temps = input( 'Enter temperature manually: ' );
end
disp( temps );

%% Manually adjust VA and holdoff sweep parameters here
overbias_percentage_list = 1.01 : 0.01 : 1.10;  % 1% to 10% sweep
%overbias_percentage_list = [ 1.01 ];
% Needed at 180K, 170K, 160K
overbias_percentage_list( 1 ) = 1.015;

VA_target_list = V_BR * overbias_percentage_list;
comp_thres_list = 0.95 * ones( size( VA_target_list ) );

% Needed at 160K, 
comp_thres_list( 1 ) = 0.975;

% DAC val. '1572' = 10us holdoff
% ~'1300' is min for reliable triggering, '1640' is max. with R47 = 10kohm
% Range is 5us to 16us
%holdoff_min = 1400;
%holdoff_max = 1500;
%holdoff_length = 2;
%holdoff_list = holdoff_min + (holdoff_max - holdoff_min ) * ...
%    log( linspace( exp( 0 ), exp( 1 ), holdoff_length) );
%holdoff_list = round( holdoff_list );

holdoff_length = 3;
holdoff_list = [ 299, 956, 1563 ];  % Values for 1us, 3.33us, 10us from characterization scripts

%holdoff_length = 1;
%holdoff_list = [ 1500 ];  % testing

num_points = 10000;
num_groups = 1;    % 1 group of 1000 measurements, to save time

raw_interarrival_data = cell( length( VA_target_list ), length( holdoff_list ) );
raw_totalize_data = cell( length( VA_target_list ), length( holdoff_list ) );

VA_list = zeros( size( VA_target_list ) );  % Keep track of the actual VA achieved given DAC limits

for i = 1 : length( VA_target_list )
    % Set the bias voltage and comp. threshold
    AQC_write_mode( AQC, 'IV_TEST' );
    [ VA_list( i ), ~ ] = AQC_set_VA_bias( AQC, VA_target_list( i ) );
    AQC_set_comp_thres( AQC, comp_thres_list( i ) );
    AQC_write_mode( AQC, 'AQC' );
    
    for j = 1 : length( holdoff_list )
        % Set the holdoff time
        AQC_write_mode( AQC, 'IV_TEST' );
        AQC_write_dac( AQC, 1, 2, num2str( holdoff_list( j ), '%04d' ) );
        AQC_write_mode( AQC, 'AQC' );

        % Take interarrival time measurements
        for k = 1 : num_groups
            disp( [ 'VA_ind (i) = ' num2str( i ) ', holdoff_ind (j) = ' num2str( j ) ', Group (k) = ' num2str( k ) ] );
            raw_interarrival_data{ i, j } = [ raw_interarrival_data{ i, j }, COUNTER_run_single_period( COUNTER, num_points / num_groups, 'true' ) ];
        end
        
        % Take basic "total counts in 1s" measurement
        slope = 'POS';
        threshold = 1.0;
        time = 0.1;
        bins = 10;
        raw_totalize_data{ i, j } = COUNTER_run_single_totalize( COUNTER, slope, threshold, time, bins );
    end
end

% Disconnect SPAD after test is done
AQC_write_mode( AQC, 'IV_TEST' );

% End serial communication
fclose( AQC );
fclose( SMU );
fclose( COUNTER );

% Save .mat file with the data collected in the workspace
%save( [ run_name '-AQC-sweep-data_' num2str( temps( 2 ), '%.f' ) 'K_' datestr( now, 'mm-dd-yyyy_HH-MM-SS' ) ] );
save( [ run_name '-AQC-sweep-data_' num2str( temps( 2 ), '%.f' ) 'K' ] );   % No date string

toc
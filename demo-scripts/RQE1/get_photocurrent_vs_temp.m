% Use Lakeshore 331 temp. controller + Keysight B2902A sourcemeter to take 
% photocurrent as a function of temperature under constant laser
% illumination

% B2902A programming manual: http://literature.cdn.keysight.com/litweb/pdf/B2910-90020.pdf?id=1240149

%% Prep workspace and connect to the GPIB instruments

delete( instrfind );    % Clean up any previous GPIB accidents

clc
close all
clear

% Input filename here
filename = 'RQE1_edge_10um_APD_run2.mat';

SMU_addr = 23;
TEMP_addr_rle = 24; % Lakeshore 331 controller on campus
TEMP_addr_ll = 12;  % Lakeshore 336 controller at LL

% instrhwinfo( 'visa', 'ni' )

SMU = visa( 'ni', [ 'GPIB0::' num2str( SMU_addr ) '::INSTR' ] );
TEMP = visa( 'ni', [ 'GPIB0::' num2str( TEMP_addr_rle ) '::INSTR' ] );

fopen( SMU );
fopen( TEMP );

%% Configure the SMU for 0V output and 100uA compliance
fprintf( SMU, '*RST' ); % Reset to default state

fprintf( SMU, ':SOUR1:VOLT 0' );

fprintf( SMU, ':SENS1:FUNC ""CURR""' );      % Measure voltage
fprintf( SMU, ':SENS1:CURR:RANG:AUTO ON' );  % Auto-ranging measurement
fprintf( SMU, ':SENS1:CURR:NPLC 1' );        % Integrate over 10 power line cycle
fprintf( SMU, ':SENS1:CURR:PROT 100e-6' );   % 100uA compliance

%% Start continuously collecting data points roughly every second
fprintf( SMU, ':OUTP1 ON' );

temp_list = [];
photocurrent_list = [];
step = 1;

while( 1 )  % Hit ctrl+c to stop when ready, then run next section

    for i = 1 : 5
        fprintf( SMU, ':MEAS:CURR?' );
        photocurrent_last = str2double( fgetl( SMU ) );
        
        photocurrent_list( step, i ) = photocurrent_last;
    end
    disp( [ 'Avg. Photocurrent = ' num2str( mean( photocurrent_list( step, : ) ) ) ] );
    
    [ temp_inst_id, temps_last ] = TEMP_get_temps( [], true );   % addr = default, verbose = true
    temp_list( step ) = temps_last( 2 );
    
    save( filename );
    
    step = step + 1;
    pause( 1 );
    
end

%% close instruments
fprintf( SMU, ':OUTP1 OFF' );                 % Disable the output

fclose( SMU );
fclose( TEMP );
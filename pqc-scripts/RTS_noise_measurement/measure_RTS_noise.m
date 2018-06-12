close all
clear
clc

delete( instrfind );

% Open instruments
COUNTER = COUNTER_open_gpib( [ ] ); % Use default address
SMU = SMU_open_gpib( [ ] ); % Use default address

VA = 13.2;
compliance = 1e-3;
channel = 1;

SMU_set_voltage( SMU, channel, VA, compliance );

Vt = 15e-3;
delta_T = 100e-6;   % 100us
bins = 1e3;

figure( )

tic;
raw_counts = [ ];
start_times = [ ];
start_temps = [ ];

while( true )
    [ temp_inst_id, temps_last ] = TEMP_get_temps( [ ], [ ] ); % default addr, verbose output
    
    start_temps = [ start_temps temps_last ];
    start_times = [ start_times toc ];
    raw_counts = [ raw_counts COUNTER_run_single_totalize( COUNTER, 'POS', Vt, delta_T, bins ) ];
    
    plot( raw_counts );
    save( 'RTS_test_1_300K.mat' );
end
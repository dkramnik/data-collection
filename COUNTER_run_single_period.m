function [ interarrival_times ] = COUNTER_run_single_period( num_samples, addr, verbose )
% Gets 'num_samples' of single period measurements from universal counter on
% GPIB address 'addr'

    if( isempty( addr ) )   % Default address = 3
        addr = 3;
    end
    
    if( isempty( verbose ) )   % Default is verbose
        verbose = true;
    end
    
    if( verbose )
        fprintf( 'Collecting %d interarrivals from the frequency counter...\n', num_samples );
    end
    
    % Create instrument object and open communication
    COUNTER = visa( 'ni', [ 'GPIB0::' num2str( addr ) '::INSTR' ] );
    set( COUNTER, 'Timeout', 100 ); % Long timeout for slow measurements
    fopen( COUNTER );
    
    % Configure instrument for single period measurement
    fprintf( COUNTER, 'CONF:SPER' );
    
    % Configure the channel 1 input (change from default SPER values)
    fprintf( COUNTER, 'INP1:COUP DC' );     % DC coupled
    fprintf( COUNTER, 'INP1:IMP 50' );      % 50 ohm input impedance
    fprintf( COUNTER, 'INP1:LEV 1.0' );     % 1V threshold
    fprintf( COUNTER, 'INP1:SLOP POS' );    % Positive slope trigger
    
    % Get some measurements
    fprintf( COUNTER, [ 'SAMP:COUN ' num2str( num_samples ) ] );
    
    pause( 1 );
    
    % Fetch the results from the counter
    fprintf( COUNTER, 'READ?' );
    
    results_raw = [];
    count = 512;
    while count == 512
        [ new_data, count ] = fgetl( COUNTER );
        results_raw = [ results_raw new_data ];
    end
    interarrival_times = str2num( results_raw );
    
    fclose( COUNTER );
    delete( COUNTER );
    
    if( verbose )
        fprintf( 'Done!\n' );
    end
end
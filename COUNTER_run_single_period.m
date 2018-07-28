function [ interarrival_times ] = COUNTER_run_single_period( COUNTER, num_samples, verbose )
% Gets 'num_samples' of single period measurements from universal counter
    
    if( isempty( verbose ) )   % Default is verbose
        verbose = true;
    end
    
    if( verbose )
        fprintf( 'Collecting %d interarrivals from the frequency counter...\n', num_samples );
    end
    
    set( COUNTER, 'Timeout', 30 ); % Long timeout for slow measurements
    
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
    interarrival_times = str2double( results_raw );
    
    fclose( COUNTER );
    delete( COUNTER );
    
    if( verbose )
        fprintf( 'Done!\n' );
    end
end
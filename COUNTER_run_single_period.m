function [ interarrival_times ] = COUNTER_run_single_period( COUNTER, num_samples, verbose )
% Gets 'num_samples' of single period measurements from universal counter
    
    if( isempty( verbose ) )   % Default is verbose
        verbose = true;
    end
    
    if( verbose )
        fprintf( 'Collecting %d interarrivals from the frequency counter...\n', num_samples );
    end
    
    set( COUNTER, 'Timeout', 300 ); % Very long timeout for very slow measurements, set dynamically in the future!
    
    % Configure instrument for single period measurement
    fprintf( COUNTER, 'CONF:SPER' );
    
    % Configure the channel 1 input (change from default SPER values)
    fprintf( COUNTER, 'INP1:COUP DC' );     % DC coupled
    fprintf( COUNTER, 'INP1:IMP 50' );      % 50 ohm input impedance
    fprintf( COUNTER, 'INP1:LEV 1.0' );     % 1V threshold
    fprintf( COUNTER, 'INP1:SLOP POS' );    % Positive slope trigger
    
    % Get some measurements
    fclose( COUNTER );
    COUNTER.InputBufferSize = 23 * num_samples;
    fopen( COUNTER );
    
    fprintf( COUNTER, [ 'SAMP:COUN ' num2str( num_samples ) ] );
    
    pause( 1 );
    
    % Fetch the results from the counter
    fprintf( COUNTER, 'READ?' );
    [ results_raw, ~ ] = fgetl( COUNTER );
    
    size( results_raw )
    interarrival_times = str2num( results_raw ); % str2double does NOT work here!
    
    if( verbose )
        fprintf( 'Done!\n' );
    end
end
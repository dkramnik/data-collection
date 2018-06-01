function data = COUNTER_run_single_totalize( COUNTER, slope, threshold, time, bins )
    
    % Configure instrument for totalize measurement
    %fprintf( COUNTER, 'CONF:TOT' );
    
    % Configure the channel 1 input (change from default values)
    fprintf( COUNTER, 'INP1:COUP DC' );     % DC coupled
    fprintf( COUNTER, 'INP1:IMP 50' );      % 50 ohm input impedance
    fprintf( COUNTER, [ 'INP1:LEV ' num2str( threshold ) ] );     % set threshold
    
    if( strcmp( slope, 'POS' ) || strcmp( slope, 'NEG' ) )
        fprintf( COUNTER, [ 'INP1:SLOP ' slope ] );
    else
        disp( 'Configuring for positive slope by default.' );
        fprintf( COUNTER, 'INP1:SLOP POS' );    % By default, positive slope trigger
    end
    
    % Record the number of edges in 'time' for 'bins' number of times
    data = zeros( 1, bins );
    for i = 1 : bins
        fprintf( COUNTER, [ 'MEAS:TOT:TIM? ' num2str( time ) ] );
        pause( time );
        data( i ) = str2double( fscanf( COUNTER ) );
    end
    
end
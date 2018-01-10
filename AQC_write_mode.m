function [ message ] = AQC_write_mode( mode )
% Set the AQC relays (0 = AQC, 1 = IV test)
    
    AQC = AQC_open_serial( [] );

    fprintf( AQC, [ 'M' num2str( mode ) ] );
    pause( 0.1 );   % Wait to allow time for response

    message = [];
    while AQC.BytesAvailable > 0
        message = [ message fgets( AQC ) ];
    end
    
    fclose( AQC );

end
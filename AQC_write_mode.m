function [ message ] = AQC_write_mode( AQC, mode )
% Set the AQC relays (0 = AQC, 1 = IV test)
% Can pass an 'AQC' serial instrument for faster execution
% Otherwise, one will be created, used, and then closed
    
    empty_flag = isempty( AQC );
    
    if( empty_flag )
        AQC = AQC_open_serial( [] );
    end
    
    % Allows strings to be passed in for improved code readability
    if( strcmp( mode, 'AQC' ) )
        mode = 0;
    end
    if( strcmp( mode, 'IV_TEST' ) )
        mode = 1;
    end
    
    fprintf( AQC, [ 'M' num2str( mode ) ] );
    pause( 0.1 );   % Wait to allow time for response

    message = [];
    while AQC.BytesAvailable > 0
        message = [ message fgets( AQC ) ];
    end
    
    if( empty_flag )
        fclose( AQC );
    end
end
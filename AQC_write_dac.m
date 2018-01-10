function [ message ] = AQC_write_dac( dac, channel, value )
% Write a value to a DAC connected to AQC
    
    AQC = AQC_open_serial( [] );

    fprintf( AQC, [ 'W' num2str( dac ) value num2str( channel ) ] );
    pause( 0.1 );   % Wait to allow time for response

    message = [];
    while AQC.BytesAvailable > 0
        message = [ message fgets( AQC ) ];
    end
    
    fclose( AQC );
    
end
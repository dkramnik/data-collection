function COUNTER = COUNTER_open_usb( )
% For Keysight 53220A frequency counter

    % Find a VISA-USB object.
    COUNTER = instrfind( 'Type', 'visa-usb', 'RsrcName', 'USB0::0x0957::0x1807::MY50009613::0::INSTR', 'Tag', '' );

    % Create the VISA-USB object if it does not exist
    % otherwise use the object that was found.
    if isempty( COUNTER )
        COUNTER = visa( 'NI', 'USB0::0x0957::0x1807::MY50009613::0::INSTR' );
    else
        fclose(COUNTER);
        COUNTER = COUNTER(1);
    end

    fopen( COUNTER );
    
    fprintf( COUNTER, '*RST' );                     % Reset to default settings
    fprintf( COUNTER, ':DISP:ENAB ON' );
    
end
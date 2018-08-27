function [ AQC ] = AQC_open_serial( port_name )
% Opens a USB COM port to talk to the AQC
% 'port_name' specifies the serial port to use, if specifically known
    
    serial_list = seriallist;

    if( isempty( port_name ) )  % port name is not known
        serial_inds = strfind( serial_list, '/dev/cu.usbmodem' ); % OSX systems
    else
        serial_inds = strfind( serial_list, port_name );
    end
        
    port_inds = find( not( cellfun( 'isempty', serial_inds ) ) );

    if length( port_inds ) > 1
        port_inds = port_inds( 1 ); % If more than one, pick first and print warning
        disp( 'Warning: multiple USB serial ports detected, picking first one.' );
    end
    
    AQC = serial( serial_list( port_inds ) );
    set( AQC, 'BaudRate', 9600 );
    fopen( AQC );
    
    disp( ['Connected to ' serial_list( port_inds ) ] );
    
end


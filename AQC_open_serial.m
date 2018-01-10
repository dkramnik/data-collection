function [ AQC ] = AQC_open_serial( aqc_index )
% Opens a USB COM port to talk to the AQC
% 'index' specifies the serial_list index to use, if specifically known
    
    if( isempty( aqc_index ) )  % index is not known
        
        serial_list = seriallist;
        serial_inds = strfind( serial_list, '/dev/cu.usbmodem' );
        aqc_index = find( not( cellfun( 'isempty', serial_inds ) ) );
        
        if length( aqc_index ) > 1
            aqc_index = aqc_index( 1 ); % If more than one, pick first and print warning
            disp( 'Warning: multiple USB serial ports detected, picking first one.' );
        end
    end
    
    AQC = serial( serial_list( aqc_index ) );
    set( AQC, 'BaudRate', 9600 );
    fopen( AQC );
    
    disp( ['Connected to ' serial_list( aqc_index ) ] );
    
end


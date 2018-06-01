function COUNTER = COUNTER_open_gpib( counter_addr )
% For Keysight 53220A frequency counter

    if( isempty( counter_addr ) )  % Use default address
        counter_addr = 3;
    end
    
    COUNTER = visa( 'ni', [ 'GPIB0::' num2str( counter_addr ) '::INSTR' ] );
    fopen( COUNTER );
    
    fprintf( COUNTER, '*RST' );                     % Reset to default settings
    fprintf( COUNTER, ':DISP:ENAB ON' );
    
end
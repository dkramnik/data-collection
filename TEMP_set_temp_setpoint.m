function [ temp_inst_id ] = TEMP_set_temp_setpoint( addr, temp_setpoint, verbose )
% Gets a Kelvin temp. reading of channels A, B, C, and D of a Lakeshore
% controller. If the controller has fewer channels, then then invalid
% channel requests will return values from the available channels. Toss in
% data post-processing.

    if( isempty( addr ) )   % Default address = 12 for 331 in flow cryostat
        addr = 12;
    end
    
    if( isempty( verbose ) )   % Default is verbose
        verbose = true;
    end
    
    % Check to see if a VISA instrument with the selected address exists
    if ~VISA_check_addr_exists( addr )
        fprintf( 'Error: no VISA instrument with address %d exists.\n', addr );
        temp_inst_id = [];
        temps = []; % Return empty variables, use 'isempty' to check
        return
    end
    
    % Create instrument object and open communication
    TEMP = visa( 'ni', [ 'GPIB0::' num2str( addr ) '::INSTR' ] );
    fopen( TEMP );
        
    % Fetch and store instrument ID. Useful for picking the appropriate
    % temp. channels during data processing
    fprintf( TEMP, '*IDN?' );
    temp_inst_id = fgetl( TEMP );
    
    % Update the setpoint
    fprintf( TEMP, 'RANGE 2' ); % Set medium heater range
    fprintf( TEMP, [ 'SETP 1,' num2str( temp_setpoint ) ] );
    
    fclose( TEMP );
    delete( TEMP );
    
end
function [ result ] = VISA_check_addr_exists( addr )
% Check to see if there is a VISA instrument on address 'addr'
    
    info = instrhwinfo( 'visa', 'ni' );
    constructors = info.ObjectConstructorName;  % Return an Nx1 cell array
    
    % Check to see if the constructor string for VISA address 'addr' is in
    % the cell array
    result = any( strcmp( constructors, ...
        [ 'visa(''ni'', ''GPIB0::' num2str( addr ) '::INSTR'');' ]) );
    
end
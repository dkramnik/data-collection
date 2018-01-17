function [ result ] = VISA_check_addr_exists( addr )
% Check to see if there is a VISA instrument on address 'addr'
    
    result = false;
    
    info = instrhwinfo( 'visa', 'ni' );
    constructors = info.ObjectConstructorName;
    
    if any( strcmp( constructors, [ 'visa(''ni'', ''GPIB0::' num2str( addr ) '::INSTR'');' ]) )
        result = true;
    end
    
end


function list = VISA_find_instruments( )
    
    % For instructions, run: instrhelp instrhwinfo
    list = instrhwinfo( 'visa', 'ni' );
    
end


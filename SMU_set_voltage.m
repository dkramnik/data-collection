function SMU_set_voltage( SMU, channel, voltage, compliance )
    
    if( channel == 1 || channel == 2 )
        ch_str   = num2str( channel );
        volt_str = num2str( voltage );
        cmp_str  = num2str( compliance );
        
        fprintf( SMU, [ ':SOUR' ch_str ':FUNC:MODE VOLT' ] );    % Configure voltage output
        fprintf( SMU, [ ':SOUR' ch_str ':VOLT ' volt_str ] );
        fprintf( SMU, [ ':SENS' ch_str ':CURR:PROT ' cmp_str ] );
        fprintf( SMU, ':OUTP ON' );
    else
        disp( 'Error: invalid SMU channel selected, no action taken' )
    end
    
end
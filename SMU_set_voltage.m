function voltage_measured = SMU_set_voltage( SMU, channel, voltage, compliance )
    
    if( channel == 1 || channel == 2 )
        ch_str   = num2str( channel );
        volt_str = num2str( voltage );
        cmp_str  = num2str( compliance );
        
        fprintf( SMU, [ ':SOUR' ch_str ':FUNC:MODE VOLT' ] );    % Configure voltage output
        fprintf( SMU, [ ':SOUR' ch_str ':VOLT ' volt_str ] );
        fprintf( SMU, [ ':SENS' ch_str ':CURR:PROT ' cmp_str ] );
        fprintf( SMU, ':OUTP ON' );
        
        fprintf( SMU, ':SENS1:FUNC:OFF:ALL' );
        fprintf( SMU, ':SENS1:FUNC "VOLT:DC"' );
        fprintf( SMU, ':SENS1:VOLT:NPLC 10' );
        fprintf( SMU, ':MEAS:VOLT:DC?' );
        voltage_measured = str2double( fgetl( SMU ) );
    else
        disp( 'Error: invalid SMU channel selected, no action taken' )
    end
    
end
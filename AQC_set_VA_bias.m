function [ message ] = AQC_set_VA_bias( AQC, V_A )
% Write a value to the AQC's cascode current bias DAC so as to set the SPAD
% bias voltage to 'V_A'
% Can pass an 'AQC' serial instrument for faster execution
% Otherwise, one will be created, used, and then closed
    
    % Define the fixed parameters in the circuit.
    % Measured with a multimeter for more-precise results.
    % The rails are set by feedback voltage dividers, so the errors from 
    % nominal "+15V" and "+5V" should be consistent between builds.
    V_A_RAIL = 14.93;
    V_CCS_RAIL = 4.916;
    R_L = 220;
    R_E = 470;
    R_CCS = 330;
    V_BE = 0.6;
    
    % Calculate the required DAC values to set the desired parameters
    CASCODE_IBIAS = round( 1000 * ( V_CCS_RAIL - ( R_CCS / R_L ) * ...
        ( V_A_RAIL - V_A - ( R_L / R_E ) * ( V_CCS_RAIL - V_BE ) ) ) );
    if CASCODE_IBIAS > 4095
       CASCODE_IBIAS = 4095;
       disp( 'Warning, CASCODE_IBIAS saturated to 4095.' );
       V_A_ACT = V_A_RAIL - ( R_L / R_E ) * ( V_CCS_RAIL - V_BE ) - ...
           ( R_L / R_CCS ) * ( V_CCS_RAIL - CASCODE_IBIAS / 1000 );
       disp( [ 'Actual V_A is ' num2str( V_A_ACT ) 'V' ] );
    end
    CASCODE_IBIAS = num2str( CASCODE_IBIAS, '%04d' );
    
    % Inputs: AQC, DAC number, channel number, value
    message = AQC_write_dac( AQC, 1, 0, CASCODE_IBIAS );
    
end


function [ message ] = AQC_set_comp_thres( AQC, V_thres )
% Write a specific voltage to the AQC's comparator threshold DAC
% Can pass an 'AQC' serial instrument for faster execution
% Otherwise, one will be created, used, and then closed
    
    % Define the fixed parameters in the circuit.
    VREF_DAC2 = 3.3;
    
    % Calculate the required DAC values to set the desired parameters
    VCOMP = round( 4096 * V_thres / VREF_DAC2 );
    VCOMP = num2str( VCOMP, '%04d' );
    
    % Inputs: AQC, DAC number, channel number, value
    message = AQC_write_dac( AQC, 2, 0, VCOMP );
    
end


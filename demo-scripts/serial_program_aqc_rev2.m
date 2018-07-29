% Writes values to all of the AQC-rev2 DACs and relays
close all
clear
clc

delete( instrfind )

% Create an AQC object to pass to each write function for faster execution
AQC = AQC_open_serial( 2 );

% Mode 1 = IV TEST
AQC_write_mode( AQC, 1 )

%% Write to AQC DACs
% Define the fixed parameters in the circuit, these are measured once the
% circuit is constructed for obtaining the most-precise results
V_A_RAIL = 14.93;
V_CCS_RAIL = 4.916;
R_L = 220;
R_E = 470;
R_CCS = 330;
V_BE = 0.6;
VREF_DAC2 = 3.3;

% 12.36V is the max. (verified)
% 9.63 is the min. (need to verify)
% 12.35V, 0.90V works well at room temp.
% Define the desired parameters in the circuit
V_A = 11.0*1.015;
VREF_COMP = 0.95;

% Calculate the required DAC values to set the desired parameters
CASCODE_IBIAS = round( 1000 * ( V_CCS_RAIL - (R_CCS/R_L)*( V_A_RAIL - V_A - (R_L/R_E)*( V_CCS_RAIL - V_BE ) ) ) );
if CASCODE_IBIAS > 4095
   CASCODE_IBIAS = 4095;
   disp( 'Warning, CASCODE_IBIAS saturated to 4095.' );
   V_A_ACT = V_A_RAIL - (R_L/R_E)*( V_CCS_RAIL - V_BE ) - (R_L/R_CCS)*( V_CCS_RAIL - CASCODE_IBIAS / 1000 );
   disp( [ 'Actual V_A is ' num2str( V_A_ACT ) 'V' ] );
end
CASCODE_IBIAS = num2str( CASCODE_IBIAS, '%04d' );

VCOMP = round( 4096 * VREF_COMP / 3.3 );
VCOMP = num2str( VCOMP, '%04d' );

% Define the any reamining DAC values directly
DIAMOND_IBIAS = '2000'; % 1mA/1000
ONE_SHOT = '0500';  % Max ~ 1630
SLEW_UP = '4000';
SLEW_DOWN = '4000';
SLEW_MAX = '3300';
DELAY_UP = '4000';
DELAY_DOWN = '4000';

AQC_write_dac( AQC, 2, 0, VCOMP )

AQC_write_dac( AQC, 1, 0, CASCODE_IBIAS )
AQC_write_dac( AQC, 1, 1, DIAMOND_IBIAS )
AQC_write_dac( AQC, 1, 2, ONE_SHOT )
AQC_write_dac( AQC, 1, 3, SLEW_UP )
AQC_write_dac( AQC, 1, 4, SLEW_DOWN )
AQC_write_dac( AQC, 1, 5, SLEW_MAX )
AQC_write_dac( AQC, 1, 6, DELAY_UP )
AQC_write_dac( AQC, 1, 7, DELAY_DOWN )

%% Set the relay mode

% Mode 0 = AQC
% Mode 1 = IV TEST
AQC_write_mode( AQC, 0 )

%% End serial communication
fclose( AQC );
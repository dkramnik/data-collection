% Writes values to all of the AQC-rev3 DACs and relays
close all
clear
clc

delete( instrfind )

% Create an AQC object to pass to each write function for faster execution
AQC = AQC_open_serial( [] );

% Mode 1 = IV TEST
AQC_write_mode( AQC, 1 )

%% Write to AQC DACs
% Define the fixed parameters in the circuit, these are measured once the
% circuit is constructed for obtaining the most-precise results
V_A_RAIL = 14.92;
V_CCS_RAIL = 4.986;
R_L = 220;
R_VA_CCS = 110; % = 1/2 * R_L

VREF_DAC2 = 3.3;

% 12.36V is the max. (verified)
% 9.63 is the min. (need to verify)
% 12.35V, 0.90V works well at room temp.
% Define the desired parameters in the circuit
V_A = 11.0;
VREF_COMP = 0.425;

% Calculate the required DAC values to set the desired parameters
VA_IBIAS = ( V_A_RAIL - V_A ) / R_L;
VA_SETPOINT = round( 1000 * R_VA_CCS * VA_IBIAS );

if VA_SETPOINT > 4095
   VA_SETPOINT = 4095;
   disp( 'Warning, VA_SETPOINT saturated to 4095.' );
   V_A_ACT = V_A_RAIL - R_L * ( 5 - VA_SETPOINT / 1000 * 5/4 ) / R_CCS_RAIL;
   disp( [ 'Actual V_A is ' num2str( V_A_ACT ) 'V' ] );
end
VA_SETPOINT = num2str( VA_SETPOINT, '%04d' );

% Comparator reference voltage calculation
VCOMP = round( 4096 * VREF_COMP / 3.3 );
VCOMP = num2str( VCOMP, '%04d' );

% Define the any reamining DAC values directly
DELTAV_SETPOINT = '3000';
DIAMOND_IBIAS = '2000'; % 1mA/1000
ONE_SHOT_COMP = '3000';
ONE_SHOT_CCS = '2000';
EXTRA_1 = '4000';
EXTRA_2 = '4000';
EXTRA_3 = '4000';

AQC_write_dac( AQC, 2, 0, VCOMP )

AQC_write_dac( AQC, 1, 0, DELTAV_SETPOINT )
AQC_write_dac( AQC, 1, 1, DIAMOND_IBIAS )
AQC_write_dac( AQC, 1, 2, ONE_SHOT_COMP )
AQC_write_dac( AQC, 1, 3, VA_SETPOINT )
AQC_write_dac( AQC, 1, 4, ONE_SHOT_CCS )
AQC_write_dac( AQC, 1, 5, EXTRA_1 )
AQC_write_dac( AQC, 1, 6, EXTRA_2 )
AQC_write_dac( AQC, 1, 7, EXTRA_3 )

%% Set the relay mode

% Mode 0 = AQC
% Mode 1 = IV TEST
AQC_write_mode( AQC, 0 )

%% End serial communication
fclose( AQC );
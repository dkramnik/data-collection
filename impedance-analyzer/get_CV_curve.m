% CV Sweep Program
% MAKE SURE MICROSCOPE LIGHT IS OFF!

%close all
%clear
%clc

delete( instrfind );

IMPED_ANALYZER = IMPED_ANALYZER_open_gpib( [ ] );

fprintf( IMPED_ANALYZER, 'FREQ 1MHZ' );     % 1MHz excitation
fprintf( IMPED_ANALYZER, 'VOLT 0.01' );     % 10mV excitation
fprintf( IMPED_ANALYZER, 'FUNC:IMP CPRP' );
%fprintf( IMPED_ANALYZER, 'OUTP:DC:ISOL ON' );
fprintf( IMPED_ANALYZER, 'BIAS:STATE ON' );
fprintf( IMPED_ANALYZER, 'APER LONG, 4' );  % Comment this out for a fast test run

bias_list = 0.6 : -0.1 : -12;
CP_meas = zeros( size( bias_list ) );
RP_meas = zeros( size( bias_list ) );

for i = 1 : length( bias_list )
    
    fprintf( IMPED_ANALYZER, [ 'BIAS:VOLT ' num2str( bias_list( i ) ) ] );	% DC bias
    
    fprintf( IMPED_ANALYZER, 'TRIG' );
    fprintf( IMPED_ANALYZER, 'FETC?' );
    
    raw_data = fgetl( IMPED_ANALYZER );
    data_cells = strsplit( raw_data, ',' );
    
    CP_meas( i ) = str2double( data_cells{ 1 } );
    RP_meas( i ) = str2double( data_cells{ 2 } );
end

fclose( IMPED_ANALYZER );

%% Plot results of CV sweep
lw = 1.25;
fs = 14;

figure( );

plot( bias_list, CP_meas, 'o--', 'linewidth', lw );
%set( gca, 'yscale', 'log' );

legend( '10um Device' );
grid on;

%% Save sweep results
save( '10um_STI_GR_CV_sweep_dark', 'bias_list', 'CP_meas', 'RP_meas' );
close all
clear
clc

load( 'condensed-cryo-run1-data.mat' )

% Extract results
P_AP = zeros( size( global_experiment_data_array ) );
lambda_AP = zeros( size( global_experiment_data_array ) );
lambda_PDC = zeros( size( global_experiment_data_array ) );
temps = zeros( size( global_experiment_data_array ) );

for index = 1 : length( global_experiment_data_array )
    raw_interarrival_data = global_experiment_data_array{ index }.raw_interarrival_data;
    
    temps( index ) = global_experiment_data_array{ index }.temp;
    
    % Index the interarrivals using { overbias, holdoff }
    [ param_fit, fit_func_dual_exp_cdf ] ...
        = SRA_fit_double_exponential( raw_interarrival_data{ 2, 2 } );
    P_AP( index )       = param_fit( 1 );
    lambda_AP( index )  = param_fit( 2 );
    lambda_PDC( index ) = param_fit( 3 );
end

%% Plot some results
lw = 1.25;
fs = 14;

figure( )
plot( temps, P_AP, 'o--', 'linewidth', lw )

xlabel( 'Temperature [K]' );
ylabel( 'P_{AP}' );
grid on;

figure( )
semilogy( temps, lambda_PDC, 'o--', 'linewidth', lw )
hold on;
semilogy( temps, lambda_AP, 'o--', 'linewidth', lw )

legend( '\lambda_{PDC}', '\lambda_{AP}' )

xlabel( 'Temperature [K]' );
ylabel( 'Fitted Rate [cps]' );
grid on;

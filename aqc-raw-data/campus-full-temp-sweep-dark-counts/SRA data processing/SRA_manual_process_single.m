% Perform one-by-one manual curve fitting of SRA data
close all
clear
clc

load( 'condensed-cryo-run1-data.mat' )

temps = zeros( size( global_experiment_data_array ) );
for temp_index = 1 : length( global_experiment_data_array )
    temps( temp_index ) = global_experiment_data_array{ temp_index }.temp;
end

make_SRA_plot = true;

%% Define which index we are processing
temp_index = 5;
overbias_index= 7;
holdoff_index = 3;  % 1 -> 1us, 2 -> 3.3us, 3 -> 10us

%% Manually guess the parameters
P_AP = 0.999;
lambda_AP = 400000;
lambda_PDC = 30000;
params = [ P_AP, lambda_AP, lambda_PDC ];

raw_interarrival_data = global_experiment_data_array{ temp_index }.raw_interarrival_data;

data_to_plot = raw_interarrival_data( overbias_index, holdoff_index );
holdoff_time = min( data_to_plot{ 1 } );
%holdoff_time = 1e-6;

%% Do SRA fitting
plot_title = [ num2str( temps( temp_index ) ) 'K' ];
SRA_plot_double_exponential( data_to_plot{ 1 }, holdoff_time, params, plot_title )

% Output some goodness of fit metric for comparison?
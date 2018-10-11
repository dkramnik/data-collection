close all
clear
clc

load( 'condensed-cryo-run1-data.mat' )

for index = 1 : length( global_experiment_data_array )
    raw_interarrival_data = global_experiment_data_array{ index }.raw_interarrival_data;
    
    
end
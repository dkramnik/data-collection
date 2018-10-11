% First, we need to load the raw files
% and repackage the data into a single data structure that's less messy
% Then, save as mat file and put into the SRA data analysis directory

close all
clear
clc

data_files = dir( 'cryo*.mat' );

% Global data structure will be a [number of runs]-long cell array
% Each cell contains a struct with the following entries:
%   comp_thres_list             - avalanche comparator thresholds used
%   device                      - device number (see lab notebook for SPAD numbering)
%   diameter                    - device diameter in meters
%   holdoff_length              - holdoff points used
%   holdoff_list                - raw holdoff DAC values
%   overbias_percentage_list    - overbias values
%   raw_interarrival_data       - interarrival times from freq. counter
%   raw_totalize_data           - totalize measurement from freq. counter
%   temp                        - cold head temp, temps( 2 ) in mat file
%   V_BR                        - breakdown voltage measured at 100uA
%   VA_list                     - actual VA value based on DAC value
%   VA_target_list              - targeted VA value based on overbias %

global_experiment_data_array = cell( length( data_files ), 1 );

for index = 1 : length( data_files )
    load( data_files( index ).name );
    
    s = struct( 'comp_thres_list', 'comp_thres_list', ...
        'device', Device, ...
        'diameter', Diameter, ...
        'holdoff_length', holdoff_length, ...
        'holdoff_list', holdoff_list, ...
        'overbias_percentage_list', overbias_percentage_list, ...
        'raw_interarrival_data', raw_interarrival_data, ...
        'raw_totalize_data', raw_totalize_data, ...
        'temp', temps( 2 ), ...
        'V_BR', V_BR, ...
        'VA_list', VA_list, ...
        'VA_target_list', VA_target_list );
    
    global_experiment_data_array{ index } = s;
end

save( 'condensed-cryo-run1-data.mat', 'global_experiment_data_array' );
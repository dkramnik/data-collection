% Perform one-by-one manual curve fitting of SRA data

close all
clear
clc

load( 'condensed-cryo-run1-data.mat' )

% Extract results
P_AP = zeros( 17, 10, 3 );  % temp, overbias, holdoff
lambda_AP = zeros( 17, 10, 3 );  % temp, overbias, holdoff
lambda_PDC = zeros( 17, 10, 3 );  % temp, overbias, holdoff

temps = zeros( size( global_experiment_data_array ) );
for temp_index = 1 : length( global_experiment_data_array )
    temps( temp_index ) = global_experiment_data_array{ temp_index }.temp;
end

make_SRA_plot = true;

%% INDEX 1 OF 17 (90K)
temp_index = 1;

holdoff_time = 10e-6;   % 3 -> 10us

P_AP( temp_index, 2, 3 ) = 0.9;
lambda_AP( temp_index, 2, 3 ) = 15000;
lambda_PDC( temp_index, 2, 3 ) = 450;
params = [ P_AP( temp_index, 2, 3 ), lambda_AP( temp_index, 2, 3 ), lambda_PDC( temp_index, 2, 3 ) ];

raw_interarrival_data = global_experiment_data_array{ temp_index }.raw_interarrival_data;
data_to_plot = raw_interarrival_data( 2, 3 );

plot_title = [ num2str( temps( temp_index ) ) 'K' ];
SRA_plot_double_exponential( data_to_plot{ 1 }, holdoff_time, params, plot_title )

%% INDEX 2 OF 17 (100K)
temp_index = 2;

holdoff_time = 10e-6;   % 3 -> 10us

P_AP( temp_index, 2, 3 ) = 0.725;
lambda_AP( temp_index, 2, 3 ) = 20000;
lambda_PDC( temp_index, 2, 3 ) = 150;
params = [ P_AP( temp_index, 2, 3 ), lambda_AP( temp_index, 2, 3 ), lambda_PDC( temp_index, 2, 3 ) ];

raw_interarrival_data = global_experiment_data_array{ temp_index }.raw_interarrival_data;
data_to_plot = raw_interarrival_data( 2, 3 );

plot_title = [ num2str( temps( temp_index ) ) 'K' ];
SRA_plot_double_exponential( data_to_plot{ 1 }, holdoff_time, params, plot_title )

%% INDEX 3 OF 17 (110K)
temp_index = 3;

holdoff_time = 10e-6;   % 3 -> 10us

P_AP( temp_index, 2, 3 ) = 0.51;
lambda_AP( temp_index, 2, 3 ) = 25000;
lambda_PDC( temp_index, 2, 3 ) = 130;
params = [ P_AP( temp_index, 2, 3 ), lambda_AP( temp_index, 2, 3 ), lambda_PDC( temp_index, 2, 3 ) ];

raw_interarrival_data = global_experiment_data_array{ temp_index }.raw_interarrival_data;
data_to_plot = raw_interarrival_data( 2, 3 );

plot_title = [ num2str( temps( temp_index ) ) 'K' ];
SRA_plot_double_exponential( data_to_plot{ 1 }, holdoff_time, params, plot_title )

%% INDEX 4 OF 17 (120K)
temp_index = 4;

holdoff_time = 10e-6;   % 3 -> 10us

P_AP( temp_index, 2, 3 ) = 0.16;
lambda_AP( temp_index, 2, 3 ) = 80000;
lambda_PDC( temp_index, 2, 3 ) = 135;
params = [ P_AP( temp_index, 2, 3 ), lambda_AP( temp_index, 2, 3 ), lambda_PDC( temp_index, 2, 3 ) ];

raw_interarrival_data = global_experiment_data_array{ temp_index }.raw_interarrival_data;
data_to_plot = raw_interarrival_data( 2, 3 );

plot_title = [ num2str( temps( temp_index ) ) 'K' ];
SRA_plot_double_exponential( data_to_plot{ 1 }, holdoff_time, params, plot_title )

%% INDEX 5 OF 17 (130K)
temp_index = 5;

holdoff_time = 10e-6;   % 3 -> 10us

P_AP( temp_index, 2, 3 ) = 0.02;
lambda_AP( temp_index, 2, 3 ) = 200000;
lambda_PDC( temp_index, 2, 3 ) = 260;
params = [ P_AP( temp_index, 2, 3 ), lambda_AP( temp_index, 2, 3 ), lambda_PDC( temp_index, 2, 3 ) ];

raw_interarrival_data = global_experiment_data_array{ temp_index }.raw_interarrival_data;
data_to_plot = raw_interarrival_data( 2, 3 );

plot_title = [ num2str( temps( temp_index ) ) 'K' ];
SRA_plot_double_exponential( data_to_plot{ 1 }, holdoff_time, params, plot_title )

%% INDEX 6 OF 17 (140K)
temp_index = 6;

holdoff_time = 10e-6;   % 3 -> 10us

P_AP( temp_index, 2, 3 ) = 0;
lambda_AP( temp_index, 2, 3 ) = 0;
lambda_PDC( temp_index, 2, 3 ) = 420;
params = [ P_AP( temp_index, 2, 3 ), lambda_AP( temp_index, 2, 3 ), lambda_PDC( temp_index, 2, 3 ) ];

raw_interarrival_data = global_experiment_data_array{ temp_index }.raw_interarrival_data;
data_to_plot = raw_interarrival_data( 2, 3 );

plot_title = [ num2str( temps( temp_index ) ) 'K' ];
SRA_plot_double_exponential( data_to_plot{ 1 }, holdoff_time, params, plot_title )

%% INDEX 7 OF 17 (150K)
temp_index = 7;

holdoff_time = 10e-6;   % 3 -> 10us

P_AP( temp_index, 2, 3 ) = 0;
lambda_AP( temp_index, 2, 3 ) = 0;
lambda_PDC( temp_index, 2, 3 ) = 700;
params = [ P_AP( temp_index, 2, 3 ), lambda_AP( temp_index, 2, 3 ), lambda_PDC( temp_index, 2, 3 ) ];

raw_interarrival_data = global_experiment_data_array{ temp_index }.raw_interarrival_data;
data_to_plot = raw_interarrival_data( 2, 3 );

plot_title = [ num2str( temps( temp_index ) ) 'K' ];
SRA_plot_double_exponential( data_to_plot{ 1 }, holdoff_time, params, plot_title )

%% INDEX 8 OF 17 (160K)
temp_index = 8;

holdoff_time = 10e-6;   % 3 -> 10us

P_AP( temp_index, 2, 3 ) = 0;
lambda_AP( temp_index, 2, 3 ) = 0;
lambda_PDC( temp_index, 2, 3 ) = 1450;
params = [ P_AP( temp_index, 2, 3 ), lambda_AP( temp_index, 2, 3 ), lambda_PDC( temp_index, 2, 3 ) ];

raw_interarrival_data = global_experiment_data_array{ temp_index }.raw_interarrival_data;
data_to_plot = raw_interarrival_data( 2, 3 );

plot_title = [ num2str( temps( temp_index ) ) 'K' ];
SRA_plot_double_exponential( data_to_plot{ 1 }, holdoff_time, params, plot_title )

%% INDEX 9 OF 17 (170K)
temp_index = 9;

holdoff_time = 10e-6;   % 3 -> 10us

P_AP( temp_index, 2, 3 ) = 0;
lambda_AP( temp_index, 2, 3 ) = 0;
lambda_PDC( temp_index, 2, 3 ) = 2550;
params = [ P_AP( temp_index, 2, 3 ), lambda_AP( temp_index, 2, 3 ), lambda_PDC( temp_index, 2, 3 ) ];

raw_interarrival_data = global_experiment_data_array{ temp_index }.raw_interarrival_data;
data_to_plot = raw_interarrival_data( 2, 3 );

plot_title = [ num2str( temps( temp_index ) ) 'K' ];
SRA_plot_double_exponential( data_to_plot{ 1 }, holdoff_time, params, plot_title )

%% INDEX 10 OF 17 (180K)
temp_index = 10;

holdoff_time = 10e-6;   % 3 -> 10us

P_AP( temp_index, 2, 3 ) = 0;
lambda_AP( temp_index, 2, 3 ) = 0;
lambda_PDC( temp_index, 2, 3 ) = 5000;
params = [ P_AP( temp_index, 2, 3 ), lambda_AP( temp_index, 2, 3 ), lambda_PDC( temp_index, 2, 3 ) ];

raw_interarrival_data = global_experiment_data_array{ temp_index }.raw_interarrival_data;
data_to_plot = raw_interarrival_data( 2, 3 );

plot_title = [ num2str( temps( temp_index ) ) 'K' ];
SRA_plot_double_exponential( data_to_plot{ 1 }, holdoff_time, params, plot_title )

%% INDEX 11 OF 17 (190K)
temp_index = 11;

holdoff_time = 10e-6;   % 3 -> 10us

P_AP( temp_index, 2, 3 ) = 0;
lambda_AP( temp_index, 2, 3 ) = 0;
lambda_PDC( temp_index, 2, 3 ) = 13000;
params = [ P_AP( temp_index, 2, 3 ), lambda_AP( temp_index, 2, 3 ), lambda_PDC( temp_index, 2, 3 ) ];

raw_interarrival_data = global_experiment_data_array{ temp_index }.raw_interarrival_data;
data_to_plot = raw_interarrival_data( 2, 3 );

plot_title = [ num2str( temps( temp_index ) ) 'K' ];
SRA_plot_double_exponential( data_to_plot{ 1 }, holdoff_time, params, plot_title )

%% INDEX 12 OF 17 (200K)
temp_index = 12;

holdoff_time = 10e-6;   % 3 -> 10us

P_AP( temp_index, 2, 3 ) = 0;
lambda_AP( temp_index, 2, 3 ) = 0;
lambda_PDC( temp_index, 2, 3 ) = 32000;
params = [ P_AP( temp_index, 2, 3 ), lambda_AP( temp_index, 2, 3 ), lambda_PDC( temp_index, 2, 3 ) ];

raw_interarrival_data = global_experiment_data_array{ temp_index }.raw_interarrival_data;
data_to_plot = raw_interarrival_data( 2, 3 );

plot_title = [ num2str( temps( temp_index ) ) 'K' ];
SRA_plot_double_exponential( data_to_plot{ 1 }, holdoff_time, params, plot_title )

%% INDEX 13 OF 17 (220K)
temp_index = 13;

holdoff_time = 10e-6;   % 3 -> 10us

P_AP( temp_index, 2, 3 ) = 0;
lambda_AP( temp_index, 2, 3 ) = 0;
lambda_PDC( temp_index, 2, 3 ) = 150000;
params = [ P_AP( temp_index, 2, 3 ), lambda_AP( temp_index, 2, 3 ), lambda_PDC( temp_index, 2, 3 ) ];

raw_interarrival_data = global_experiment_data_array{ temp_index }.raw_interarrival_data;
data_to_plot = raw_interarrival_data( 2, 3 );

plot_title = [ num2str( temps( temp_index ) ) 'K' ];
SRA_plot_double_exponential( data_to_plot{ 1 }, holdoff_time, params, plot_title )

%% INDEX 14 OF 17 (240K)
temp_index = 14;

holdoff_time = 10e-6;   % 3 -> 10us

P_AP( temp_index, 2, 3 ) = 0;
lambda_AP( temp_index, 2, 3 ) = 0;
lambda_PDC( temp_index, 2, 3 ) = 550000;
params = [ P_AP( temp_index, 2, 3 ), lambda_AP( temp_index, 2, 3 ), lambda_PDC( temp_index, 2, 3 ) ];

raw_interarrival_data = global_experiment_data_array{ temp_index }.raw_interarrival_data;
data_to_plot = raw_interarrival_data( 2, 3 );

plot_title = [ num2str( temps( temp_index ) ) 'K' ];
SRA_plot_double_exponential( data_to_plot{ 1 }, holdoff_time, params, plot_title )

%% INDEX 15 OF 17 (260K)
temp_index = 15;

holdoff_time = 10e-6;   % 3 -> 10us

P_AP( temp_index, 2, 3 ) = 0;
lambda_AP( temp_index, 2, 3 ) = 0;
lambda_PDC( temp_index, 2, 3 ) = 1.5e6;
params = [ P_AP( temp_index, 2, 3 ), lambda_AP( temp_index, 2, 3 ), lambda_PDC( temp_index, 2, 3 ) ];

raw_interarrival_data = global_experiment_data_array{ temp_index }.raw_interarrival_data;
data_to_plot = raw_interarrival_data( 2, 3 );

plot_title = [ num2str( temps( temp_index ) ) 'K' ];
SRA_plot_double_exponential( data_to_plot{ 1 }, holdoff_time, params, plot_title )

%% INDEX 16 OF 17 (280K)
temp_index = 16;

holdoff_time = 10e-6;   % 3 -> 10us

P_AP( temp_index, 2, 3 ) = 0;
lambda_AP( temp_index, 2, 3 ) = 0;
lambda_PDC( temp_index, 2, 3 ) = 3.5e6;
params = [ P_AP( temp_index, 2, 3 ), lambda_AP( temp_index, 2, 3 ), lambda_PDC( temp_index, 2, 3 ) ];

raw_interarrival_data = global_experiment_data_array{ temp_index }.raw_interarrival_data;
data_to_plot = raw_interarrival_data( 2, 3 );

plot_title = [ num2str( temps( temp_index ) ) 'K' ];
SRA_plot_double_exponential( data_to_plot{ 1 }, holdoff_time, params, plot_title )

%% INDEX 17 OF 17 (300K)
temp_index = 17;

holdoff_time = 10e-6;   % 3 -> 10us

P_AP( temp_index, 2, 3 ) = 0;
lambda_AP( temp_index, 2, 3 ) = 0;
lambda_PDC( temp_index, 2, 3 ) = 4.5e6;
params = [ P_AP( temp_index, 2, 3 ), lambda_AP( temp_index, 2, 3 ), lambda_PDC( temp_index, 2, 3 ) ];

raw_interarrival_data = global_experiment_data_array{ temp_index }.raw_interarrival_data;
data_to_plot = raw_interarrival_data( 2, 3 );

plot_title = [ num2str( temps( temp_index ) ) 'K' ];
SRA_plot_double_exponential( data_to_plot{ 1 }, holdoff_time, params, plot_title )

%% Plot some results
lw = 1.25;
fs = 14;

figure( )
plot( temps, P_AP( :, 2, 3 ), 'o--', 'linewidth', lw )

xlabel( 'Temperature [K]' );
ylabel( 'P_{AP}' );
grid on;

figure( )
semilogy( temps, lambda_PDC( :, 2, 3 ), 'o--', 'linewidth', lw )
hold on;
semilogy( temps, lambda_AP( :, 2, 3 ), 'o--', 'linewidth', lw )

legend( '\lambda_{PDC}', '\lambda_{AP}' )

xlabel( 'Temperature [K]' );
ylabel( 'Fitted Rate [cps]' );
grid on;

% Script for sweeping bias voltage and holdoff time to observe the effects
% on DCR and afterpulsing

TEMP = 129.1;   % Recording manually, for now

close all
clear
clc

VA_list = linspace( 10.9, 11.3, 5 );
comp_thres_list = [ 0.925, 0.925, 0.925, 0.925, 0.900 ];
holdoff_list = logspace( log10( 1300 ), log10( 1600 ), 5 );
num_points = 10000;

% DAC val. '1572' = 10us holdoff
% '1300' is min, '1640' is max. with R47 = 10kohm
% Range is 5us to 16us
%ONE_SHOT = '1572';
%AQC_write_dac( AQC, 1, 2, ONE_SHOT )

raw_data = cell( length( VA_list ), length( holdoff_list ) );

for i = 1 : length( VA_list )
    % Set the bias voltage and comp. threshold
    AQC_write_mode( [], 'IV_TEST' );
    AQC_set_VA_bias( [], VA_list( i ) );
    AQC_set_comp_thres( [], comp_thres_list( i ) );
    AQC_write_mode( [], 'AQC' );
    
    for j = 1 : length( holdoff_list )
        % Set the holdoff time
        AQC_write_mode( [], 'IV_TEST' );
        AQC_write_dac( [], 1, 2, num2str( holdoff_list( j ) ) );
        AQC_write_mode( [], 'AQC' );

        % Take interarrival time measurements
        raw_data{ i, j } = COUNTER_run_single_period( num_points, [], [] );
    end
end

TCR = zeros( length( VA_list ), length( holdoff_list ) );
DCR = TCR;
p_ap_intercept = TCR;
p_ap_geometric = TCR;

%% Process the data using SRA method
for i = 1 : length( VA_list )
    for j = 1 : length( holdoff_list )
        [ TCR( i, j ), DCR( i, j ), p_ap_intercept( i, j ), p_ap_geometric( i, j ) ] = ...
            SRA_make_plot( raw_data{ i, j }, false );
    end
end

%% Make 2D plots with fit trends
close all

figure( );
hold on;
grid on;
for i = 1 : length( VA_list )
    dcr_fit = fit( transpose( VA_list ), DCR( :, i ), 'exp1' );
    plot( dcr_fit, VA_list, DCR( :, i ), 'o' );
end

%% DCR vs. V_A trends
figure( );
hold on;
grid on;
for i = 1 : length( VA_list )
    plot( VA_list, DCR( :, i ) / 1000, 'o--' );
end
legend_list = round( holdoff_list );
legend( num2str( legend_list( 1 ) ), ...
    num2str( legend_list( 2 ) ), ...
    num2str( legend_list( 3 ) ), ...
    num2str( legend_list( 4 ) ), ...
    num2str( legend_list( 5 ) ), ...
    'location', 'NW' );

xlabel( 'Bias Voltage [V]' );
ylabel( 'DCR [kHz]' );
set( gca, 'fontsize', 12 );

%% TCR/DCR vs. V_A trends
figure( );
hold on;
grid on;
for i = 1 : length( VA_list )
    plot( VA_list, TCR( :, i ) ./ DCR( :, i ), 'o--' );
end
legend_list = round( holdoff_list );
legend( num2str( legend_list( 1 ) ), ...
    num2str( legend_list( 2 ) ), ...
    num2str( legend_list( 3 ) ), ...
    num2str( legend_list( 4 ) ), ...
    num2str( legend_list( 5 ) ), ...
    'location', 'NW' );

xlabel( 'Bias Voltage [V]' );
ylabel( 'TCR/DCR [dimensionless]' );
set( gca, 'fontsize', 12 );

%% Make 3D plots with fit results

figure( );

[ x, y ] = meshgrid( VA_list, holdoff_list );
surf( x, y, transpose( DCR ) );

xlabel( 'Bias Voltage' );
ylabel( 'Holdoff Time' );
zlabel( 'DCR [Hz]' );

grid on;

figure( );

surf( x, y, transpose( TCR ) );

xlabel( 'Bias Voltage' );
ylabel( 'Holdoff Time' );
zlabel( 'TCR [Hz]' );

grid on;

figure( );

surf( x, y, transpose( p_ap_geometric ) );

xlabel( 'Bias Voltage' );
ylabel( 'Holdoff Time' );
zlabel( 'TCR [Hz]' );

grid on;
close all
clear
clc

file_name = 'cryo-run1-AQC-sweep-data_150K.mat';

load( file_name );   

if length( temps ) == 4 % LL Lakeshore
    TEMP = temps( 2 );
else
    TEMP = temps( 1 );  % Campus Lakeshore or Manual Entry
end

%% Process the data using SRA method
% Prep arrays for data
TCR = zeros( length( VA_list ), length( holdoff_list ) );
DCR = TCR;
p_ap_intercept = TCR;
p_ap_geometric = TCR;

for j = 1 : length( holdoff_list )
    fig_handle = figure( );
    
    for i = 1 : length( VA_list )
        [ TCR( i, j ), DCR( i, j ), p_ap_intercept( i, j ), p_ap_geometric( i, j ) ] = ...
            SRA_make_plot( raw_interarrival_data{ i, j }, true, fig_handle );
    end
    
    title( [ 'Holdoff = ' num2str( holdoff_list( j ) ) ] );
    y_limits = ylim;
    ylim( [ 0, y_limits( 2 ) ] );
end

%% Process again and plot SRA in different order
for i = 1 : length( VA_list )
    fig_handle = figure( );
    
    for j = 1 : length( holdoff_list )
        [ TCR( i, j ), DCR( i, j ), p_ap_intercept( i, j ), p_ap_geometric( i, j ) ] = ...
            SRA_make_plot( raw_interarrival_data{ i, j }, true, fig_handle );
    end
    
    title( [ 'V_A = ' num2str( VA_list( i ) ) ] );
    y_limits = ylim;
    ylim( [ 0, y_limits( 2 ) ] );
end

%% Plot some sorted raw data to show how SRA works
figure();
hold on;
grid on;
sra_legend_strings = {};
for i = 1 : length( VA_list )
    sorted_data = sort( raw_interarrival_data{ i, 1 }, 'descend' );
    len = length( sorted_data );
    
    holdoff_time = sorted_data( end );  % Small error due to 45ns delay line
    
    n = 1 : len;
    x = log( len ./ n );
    y = 1e6 * transpose( sorted_data );
    plot( x, y, 'o-', 'markersize', 3 );
    
    sra_legend_strings{ i } = [ 'V_A = ' num2str( VA_list( i ), '%.1f' ) 'V, ' ...
        't_h = ' num2str( 1e6 * holdoff_time, '%.2f' ) 'us' ];
end

legend( sra_legend_strings, 'location', 'NW' );
xlabel( 'log( N / n )' );
ylabel( 'Interarrival Time [s]' );
set( gca, 'fontsize', 12 );

% Uncomment for zooming in to the afterpulsing region
xlim( [ 0, 1 ] );
ylim( [ 0, 50 ] );

%% Make legend entry with holdoff times
legend_strings = cell( size( holdoff_list ) );
for i = 1 : length( holdoff_list )
   legend_strings{ i } = [ 't_h = ' num2str( 1e6 * min( raw_interarrival_data{ 1, i } ), '%.2f' ) 'us, T = ' num2str( TEMP, '%.1f' ) 'K' ];
end

%% Make 2D plots with exponential fits over DCR trends
figure( );
hold on;
grid on;
fit_legend_strings = {};
for i = 1 : length( holdoff_list )
    dcr_fit = fit( transpose( VA_list ), DCR( :, i ), 'exp1' );
    plot( dcr_fit, VA_list, DCR( :, i ), 'o' );
    fit_legend_strings{ 2 * i - 1 } = [ 't_h = ' num2str( 1e6 * min( raw_interarrival_data{ 1, i } ), '%.2f' ) 'us' ];
    fit_legend_strings{ 2 * i } = [ 'Fit #' num2str( i ) ];
end
legend( fit_legend_strings, 'location', 'NW' );

xlabel( 'Bias Voltage [V]' );
ylabel( 'DCR [kHz]' );
set( gca, 'fontsize', 12 );

%% DCR vs. V_A trends
fig_handle = figure( );
hold on;
grid on;
for i = 1 : length( holdoff_list )
    plot( VA_list, DCR( :, i ) / 1000, 'o--' );
end
legend( legend_strings, 'location', 'NW' );

xlabel( 'Bias Voltage [V]' );
ylabel( 'DCR [kHz]' );
set( gca, 'fontsize', 12 );

%print( [ dir_name '/' file_name ], '-dpng' );

%% TCR/DCR ratio vs. V_A trends
figure( );
hold on;
grid on;
for i = 1 : length( holdoff_list )
    plot( VA_list, TCR( :, i ) ./ DCR( :, i ), 'o--' );
end
legend( legend_strings, 'location', 'NW' );

xlabel( 'Bias Voltage [V]' );
ylabel( 'TCR/DCR [dimensionless]' );
set( gca, 'fontsize', 12 );

%% p_ap_geometric vs. V_A trends
figure( );
hold on;
grid on;
for i = 1 : length( holdoff_list )
    plot( VA_list, p_ap_geometric( :, i ), 'o--' );
end
legend( legend_strings, 'location', 'NW' );

xlabel( 'Bias Voltage [V]' );
ylabel( 'Geometric Afterpulsing Probability (%) [dimensionless]' );
set( gca, 'fontsize', 12 );

%% Try plotting a DCR curve from SRA on top of a histogram to get afterpulsing

figure();
hold on;
grid on;

num_bins = 100;
hist = histogram( raw_interarrival_data{ 1, 1 }, 'NumBins', num_bins );

x_coords = ( hist.BinEdges( 1 : end - 1 ) + hist.BinWidth / 2 )';
y_coords = hist.Values';

x_fit_coords = x_coords( end / 10 : end );
y_fit_coords = y_coords( end / 10 : end );

poisson_pdf = @( norm, x ) norm * exp( -1.0 * DCR( 1, 1 ) * x );

[ norm_fit, resnorm, ~, exitflag, output ] = lsqcurvefit( poisson_pdf, num_points / 10, x_fit_coords, y_fit_coords );

plot( x_coords, poisson_pdf( norm_fit, x_coords ), 'linewidth', 2 );

p_ap_hist = sum( y_coords - poisson_pdf( norm_fit, x_coords ) ) / num_points;

xlabel( 'Interarrival Time [s]' );
ylabel( 'Counts [dimensionless]' );
legend( [ 'Histogram' newline ...
    '(T = ' num2str( TEMP ) 'K, V_A = ' num2str( VA_list( 1 ) ) 'V, t_h = ' num2str( 1e6 * min( raw_interarrival_data{ 1, 1 } ), '%.1f' ) 'us)' ], ...
    [ 'Poisson DCR Fit' newline ...
    '(DCR = ' num2str( DCR( 1, 1 ), '%.1f' ) 'Hz, p_{ap} = ' num2str( 100 * p_ap_hist, '%.1f' ) '%)' ] );
set( gca, 'fontsize', 12 );

%% Calculate & plot p_ap_hist for all data entries

p_ap_hist = zeros( size( p_ap_geometric ) );

num_bins = 100;

for i = 1 : length( VA_list )
    for j = 1 : length( holdoff_list )
        % Process raw_interarrival_data{ i, j }
        hist = histogram( raw_interarrival_data{ i, j }, 'NumBins', num_bins );
        
        x_coords = ( hist.BinEdges( 1 : end - 1 ) + hist.BinWidth / 2 )';
        y_coords = hist.Values';

        x_fit_coords = x_coords( end / 10 : end );
        y_fit_coords = y_coords( end / 10 : end );
        
        poisson_pdf = @( norm, x ) norm * exp( -1.0 * DCR( i, j ) * x );
        
        [ norm_fit, resnorm, ~, exitflag, output ] = lsqcurvefit( poisson_pdf, num_points / 10, x_fit_coords, y_fit_coords );
        
        p_ap_hist( i, j ) = sum( y_coords - poisson_pdf( norm_fit, x_coords ) ) / num_points;
    end
end

figure( );
hold on;
grid on;
for i = 1 : length( holdoff_list )
    plot( VA_list, 100 * p_ap_hist( :, i ), 'o--' );
end
legend( legend_strings, 'location', 'NW' );

xlabel( 'Bias Voltage [V]' );
ylabel( 'Histogram Afterpulsing Probability (%) [dimensionless]' );
set( gca, 'fontsize', 12 );
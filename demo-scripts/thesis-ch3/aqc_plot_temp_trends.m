close all
clear
clc

data_files = dir( '*.mat' );

% Figure parameters
lw = 1.25;
fs = 14;

%% Basic plot of 1% overbias total counts

trend_temps = zeros( 1, length( data_files ) );
trend_total_counts = zeros( 10, length( data_files ) );

% Extract a data for each temp.
for index = 1 : length( data_files )
    load( data_files( index ).name );
    
    trend_temps( index ) = temps( 2 );
    
    totalize_means = 10 * cellfun( @mean, raw_totalize_data );  % Counts in 1s, each bin was 0.1s
    totalize_means_max_holdoff = totalize_means( :, 3 );
    
    trend_total_counts( :, index ) = totalize_means_max_holdoff;
end

figure( )

for index = 1 : 10
    plot( trend_temps, 1e3 * trend_total_counts( index, : ), 'o--', 'linewidth', lw );
    hold on;
end

xlabel( 'Temperature [K]' );
ylabel( 'kCounts in 1s' );

grid on;

set( gca, 'fontsize', fs );
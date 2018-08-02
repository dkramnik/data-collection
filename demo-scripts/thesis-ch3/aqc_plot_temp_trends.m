close all
clear
clc

data_files = dir( 'cryo*.mat' );

% Figure parameters
lw = 1.25;
fs = 14;


trend_temps = zeros( 1, length( data_files ) );
trend_total_counts = zeros( length( data_files ), 10, 3 );
% temp, overbias, holdoff

% Extract a data for each temp.
for index = 1 : length( data_files )
    load( data_files( index ).name );
    
    trend_temps( index ) = temps( 2 );
    
    totalize_means = 10 * cellfun( @mean, raw_totalize_data );  % Counts in 1s, each bin was 0.1s
    totalize_means_max_holdoff = totalize_means( :, 3 );
    
    trend_total_counts( index, :, : ) = totalize_means;
end

%% Basic plot of total counts for one holdoff time

figure( )

holdoff_index = 3;

for overbias_index = 1 : 10
    % temp, overbias, holdoff
    semilogy( trend_temps, ...
        trend_total_counts( :, 1 + length( overbias_percentage_list ) - overbias_index, holdoff_index ), ...
        'o--', 'linewidth', lw );
    hold on;
end

legend( sprintfc( '%.f%% Overbias', 100 * flip( overbias_percentage_list - 1 ) ), 'location', 'SE' );

xlabel( 'Temperature [K]' );
ylabel( 'Counts in 1s' );

grid on;

set( gca, 'fontsize', fs );

xlim( [ 90, 300 ] );
ylim( [ 1e1, 1e6 ] );

%% Basic plot of total counts for one overbias

figure( )

for index = 1 : 3
    % temp, overbias, holdoff
    semilogy( trend_temps, trend_total_counts( :, 1, index ), 'o--', 'linewidth', lw );
    hold on;
end

set( gca, 'ColorOrderIndex', 1 );
for index = 1 : 3
    % temp, overbias, holdoff
    semilogy( trend_temps, trend_total_counts( :, 3, index ), 'o--', 'linewidth', lw );
    hold on;
end

set( gca, 'ColorOrderIndex', 1 );
for index = 1 : 3
    % temp, overbias, holdoff
    semilogy( trend_temps, trend_total_counts( :, 5, index ), 'o--', 'linewidth', lw );
    hold on;
end

legend( '1\mus Holdoff Time', '3.3\mus Holdoff Time', '10\mus Holdoff Time', 'location', 'SE' );

xlabel( 'Temperature [K]' );
ylabel( 'Counts in 1s' );

grid on;

set( gca, 'fontsize', fs );

xlim( [ 90, 300 ] );
ylim( [ 1e1, 1e6 ] );
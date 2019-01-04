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

holdoff_list_manual = [ 1, 3.3, 10 ];  % [us]

for holdoff_index = 1 : 3
    
    fig1 = figure( );

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

    text( 251, 1.4e4, [ 't_{holdoff} = ' num2str( holdoff_list_manual( holdoff_index ) ) '\mus' ], 'fontsize', fs );

    grid on;

    set( gca, 'fontsize', fs );

    xlim( [ 90, 300 ] );
    ylim( [ 1e1, 1e6 ] );
    
    save_figure_as_pdf( fig1, [ 'aqc_total_dark_counts_' num2str( holdoff_list_manual( holdoff_index ), '%.f' ) 'us' ] );
end

%% Basic plot of total counts for 1%, 3%, 5% overbias at all three holdoff times

fig2 = figure( );

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

text( 150, 1.05e2, '1%', 'fontsize', fs );
text( 150, 1.6e3, '3%', 'fontsize', fs );
text( 150, 6.0e4, '5%', 'fontsize', fs );

rectangle( 'Position', [145 1.4e2 10 2.5e2] ); % x,y,w,h
rectangle( 'Position', [145 2.2e3 10 3.0e3] ); % x,y,w,h
rectangle( 'Position', [145 1.4e4 10 2.5e4] ); % x,y,w,h

xlabel( 'Temperature [K]' );
ylabel( 'Counts in 1s' );

grid on;

set( gca, 'fontsize', fs );

xlim( [ 90, 300 ] );
ylim( [ 1e1, 1e6 ] );

save_figure_as_pdf( fig2, 'aqc_total_dark_count_holdoff_comparison' );
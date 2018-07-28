close all
clear
clc

% Figure parameters
lw = 1.25;
fs = 14;

% Load and plot 68kohm temp. trends
load( 'pqc-wirebonded-cryo-1-processed-data.mat' );
RQ1 = pqc.RQ

fig1 = figure( );

for k = 1 : length( overbias_sample_points )
    ax = gca;
    ax.ColorOrderIndex = 1;
    h1 = plot( round( data_file_temps ), ...
        countrates_interpolated( :, length( overbias_sample_points ) - k + 1 ), ...
        'o--', ...
        'linewidth', lw );
    set( h1, 'MarkerFaceColor', get( h1, 'Color' ) ); 
    hold on;
end

% Load and plot 204kohm temp. trends
load( 'pqc-wirebonded-cryo-2-triple-R-processed-data.mat' );
RQ2 = pqc.RQ

for k = 1 : length( overbias_sample_points )
    ax = gca;
    ax.ColorOrderIndex = 2;
    h2 = plot( round( data_file_temps ), ...
        countrates_interpolated( :, length( overbias_sample_points ) - k + 1 ), ...
        'd--', ...
        'linewidth', lw );
    
    hold on;
end

set( gca, 'YScale', 'log' );
grid on;
xlabel( 'Temperature [K]' );
ylabel( 'Counts in 1s' );
set( gca, 'fontsize', fs );
%legend( sprintfc( '%.1f%% Overbias', 100 * flip( overbias_sample_points ) ), 'location', 'SE' );

xlim( [ 100 300 ] );
text( 190, 5e7, [ 'D = 10 ' char(181) 'm' ], 'fontsize', fs );
legend( [ h1 h2 ], ...
    { [ 'R_Q = ' num2str( RQ1 / 1e3 ) ' k' char( 937 ) ], [ 'R_Q = ' num2str( RQ2 / 1e3 ) ' k' char( 937 ) ] }, ...
    'location', 'SE' );

save_figure_as_pdf( fig1, 'pqc_wirebonded_compare_RQ_sweeps' );
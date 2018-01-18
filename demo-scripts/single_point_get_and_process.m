%% Get and plot single SRA data point
% Useful for monitoring what's going on during a cooldown

delete( instrfind );    % Clean up any previous GPIB accidents

close all
clear
clc

% Edit these parameters
save_data = false;
num_points = 10000;

% Get temps
[ temp_inst_id, temps ] = TEMP_get_temps( [], true );   % addr = default, verbose = true
if isempty( temps )
    temp_inst_id = 'Manual Entry';
    temps = input( 'Enter temperature manually: ' );
end

raw_data = COUNTER_run_single_period( num_points, [], [] );

if save_data
    save( [ 'AQC-single-point-data_' datestr( now, 'mm-dd-yyyy_HH-MM-SS' ) ] );
end

[ TCR, DCR, p_ap_intercept, p_ap_geometric ] = SRA_make_plot( raw_data, true );
        
% Try plotting a DCR curve from SRA on top of a histogram to get afterpulsing

figure();
hold on;
grid on;

num_bins = 100;
hist = histogram( raw_data, 'NumBins', num_bins );

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
%legend( [ 'Histogram' newline ...
%    '(T = ' num2str( TEMP ) 'K, V_A = ' num2str( VA ) 'V, t_h = ' num2str( 1e6 * min( raw_data ), '%.1f' ) 'us)' ], ...
%    [ 'Poisson DCR Fit' newline ...
%    '(DCR = ' num2str( DCR( 1, 1 ), '%.1f' ) 'Hz, p_{ap} = ' num2str( 100 * p_ap_hist, '%.1f' ) '%)' ] );
set( gca, 'fontsize', 12 );
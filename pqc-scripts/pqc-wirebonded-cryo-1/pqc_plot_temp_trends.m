close all
clear
clc

data_files = dir( '*.mat' );

% Figure parameters
lw = 1.25;
fs = 14;

%% Get temp list
data_file_temps = zeros( size( data_files ) );

for k = 1 : length( data_files )
    load( data_files( k ).name );
    
    temp_mean = 0;
    for l = 1 : length( data_cells )
        temp_mean = temp_mean + data_cells{ l }.temp_readings( 2 ); % Cold head temp.
    end
    temp_mean = temp_mean / length( data_cells );
    
    data_file_temps( k ) = temp_mean;
end

[ temps_sorted, temps_order ] = sort( data_file_temps );

%% Plot total pulses vs. overbias for all temps in 2D
figure( )
for k = 1 : length( data_files )
    
    load( data_files( k ).name );
    
    % Get temp.
    temp_sum = 0;
    for l = 1 : length( data_cells )
        temp_sum = temp_sum + data_cells{ l }.temp_readings( 2 ); % Cold head temp.
    end
    data_file_temps( k ) = temp_sum / length( data_cells );
    
    % Get CDF peaks
    CDF_peaks_mean = zeros( 1, length( data_cells ) );
    CDF_peaks_std = zeros( 1, length( data_cells ) );
        
    for i = 1 : length( data_cells )
        [ val, ind ] = max( data_cells{ i }.pulse_CDF_mean );
        CDF_peaks_mean( i ) = val;
        CDF_peaks_std( i ) = data_cells{ i }.pulse_CDF_std( ind );
    end
    
    % Find the breakdown voltage (midpt. between first zero and nonzero
    % entry)
    %VA_no_counts = VA_list( find( CDF_peaks_mean == 0 ) );
    %V_BR_extrapolated = VA_no_counts( end ) + VA_delta / 2;
    % BETTER: USE OUR PREVIOUS LINEAR FIT!
    V_BR_extrapolated = 12.20 - 7.2e-3 * (300 - data_file_temps( k ) );
    
    % Add some tiny entries instead of zero for plotting on log scale
    CDF_peaks_mean_log_modified = CDF_peaks_mean;
    CDF_peaks_std_log_modified = CDF_peaks_std;
    CDF_peaks_mean_log_modified( CDF_peaks_mean_log_modified == 0 ) = 1e-10;
    CDF_peaks_std_log_modified( CDF_peaks_std_log_modified == 0 ) = 1e-10;
    
    % Plot counts vs. overbias normalized to V_BR
    errorbar( VA_list / V_BR_extrapolated, CDF_peaks_mean_log_modified / delta_T, ...
        CDF_peaks_std_log_modified / delta_T, 'o--', 'linewidth', lw );
    hold on;
    
end

xlim( [ 1 1.25 ] ); % Up to 25% overbias
ylim( [ 1 1e8 ] );
grid on;
xlabel( 'V_A / V_{BR} [dimensionless]' );
ylabel( 'Counts in 1s' );
set( gca, 'fontsize', fs );
set( gca, 'YScale', 'log' );

%% Plot total pulses vs. overbias for all temps in 3D
figure( )

overbias_sample_points = [ 0.025, 0.05, 0.10, 0.15, 0.20 ];
countrates_interpolated = zeros( length( data_files ), length( overbias_sample_points ) );
errorbars_interpolated = zeros( length( data_files ), length( overbias_sample_points ) );

for k = 1 : length( data_files )
    
    load( data_files( k ).name );
    
    % Get temp.
    temp_sum = 0;
    for l = 1 : length( data_cells )
        temp_sum = temp_sum + data_cells{ l }.temp_readings( 2 ); % Cold head temp.
    end
    data_file_temps( k ) = temp_sum / length( data_cells );
    
    % Get CDF peaks
    CDF_peaks_mean = zeros( 1, length( data_cells ) );
    CDF_peaks_std = zeros( 1, length( data_cells ) );
        
    for i = 1 : length( data_cells )
        [ val, ind ] = max( data_cells{ i }.pulse_CDF_mean );
        CDF_peaks_mean( i ) = val;
        CDF_peaks_std( i ) = data_cells{ i }.pulse_CDF_std( ind );
    end
    
    % Find the breakdown voltage (midpt. between first zero and nonzero
    % entry)
    VA_no_counts = VA_list( find( CDF_peaks_mean == 0 ) );
    V_BR_extrapolated = VA_no_counts( end ) + VA_delta / 2;
    
    % Add some tiny entries instead of zero for plotting on log scale
    CDF_peaks_mean_log_modified = CDF_peaks_mean;
    CDF_peaks_std_log_modified = CDF_peaks_std;
    CDF_peaks_mean_log_modified( CDF_peaks_mean_log_modified == 0 ) = 1e-10;
    CDF_peaks_std_log_modified( CDF_peaks_std_log_modified == 0 ) = 1e-10;
    
    % Try 3D plot
    temp_vec = data_file_temps( k ) * ones( size( VA_list ) );
    overbias_normalized = VA_list / V_BR_extrapolated - ones( size( VA_list ) );
    plot3( temp_vec, 100 * overbias_normalized, CDF_peaks_mean_log_modified / delta_T, ...
        'o--', 'linewidth', lw );
    hold on;
    
    % Create and store a linear interpolation of the countrates, so we can
    % compare different temps. at the same overbias percentage in the next
    % section
    countrates_interpolated( k, : ) = interp1( overbias_normalized', ...
        CDF_peaks_mean_log_modified' / delta_T, ...
        overbias_sample_points', ...
        'linear' );
    errorbars_interpolated( k, : ) = interp1( overbias_normalized', ...
        CDF_peaks_std_log_modified' / delta_T, ...
        overbias_sample_points', ...
        'linear' );
end

ylim( [ 0 25 ] ); % Up to 25% overbias
zlim( [ 1 1e8 ] );
set( gca, 'ZScale', 'log' );

grid on;
xlabel( 'Temperature [K]' );
ylabel( 'Percent Overbias' );
zlabel( 'Counts in 1s' );
set( gca, 'fontsize', fs );

% Create 2D plot of countrate vs. temp. as we sweep overbias percent
% Note: the weird indexing and legend flip are to get the legend and plots
% to have the same vertical order, otherwise it looks confusing
fig_3 = figure( );

for k = 1 : length( overbias_sample_points )
    %errorbar( data_file_temps, ...
    %    countrates_interpolated( :, length( overbias_sample_points ) - k + 1 ), ...
    %    errorbars_interpolated( :, length( overbias_sample_points ) - k + 1 ), ...
    %    'o--', ...
    %    'linewidth', lw );
    plot( round( data_file_temps ), ...
        countrates_interpolated( :, length( overbias_sample_points ) - k + 1 ), ...
        'o--', ...
        'linewidth', lw );
    hold on;
end

set( gca, 'YScale', 'log' );
grid on;
xlabel( 'Temperature [K]' );
ylabel( 'Counts in 1s' );
set( gca, 'fontsize', fs );
legend( sprintfc( '%.1f%% Overbias', 100 * flip( overbias_sample_points ) ), 'location', 'SE' );

xlim( [ 100 300 ] );
text( 175, 5e7, [ 'D = 10 ' char(181) 'm, R_Q = ' num2str( pqc.RQ / 1000 ) ' k' char( 937 ) ], 'fontsize', fs );

save_figure_as_pdf( fig_3, 'pqc_wirebonded_cryo_1_overbias_trends' );

% Save overbias sweep data using a new struct
data_struct.data_file_temps = data_file_temps;
data_struct.countrates_interpolated = countrates_interpolated;
data_struct.overbias_sample_points = overbias_sample_points;
data_struct.pqc = pqc;
save( 'outputs/pqc-wirebonded-cryo-1-processed-data.mat', '-struct', 'data_struct' );
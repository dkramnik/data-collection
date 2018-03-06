close all
clear
clc

% Specify experiment set and measurement number
directory = 'PDP1';
trial = 'm1';

mu = char( 181 );             % Non-italicized symbol '\mu'
thin_space = char( 8239 );  % Shorter than regular ' ' space, put between value and units
fs = 14;

% Currently, laser power is entered manually using notes from lab notebook
% p_laser is the output from the cleaved fiber with no ND filters
% atten is the total ND filter attenuation; filters are characterized
% manually due to big error from their nominal specs. at 405nm

% m1 settings
p_laser = 1.90e-6;
atten = 139.2e-6 / 1.360e-3 * 0.9e-9 / 1.360e-3;

% m2 - m5 settings
p_laser = 1.90e-6 * 14.5e-6 / 15.9e-6;
atten = 139.2e-6 / 1.360e-3 * 14.8e-9 / 1.382e-3;

wavelength = 405e-9;
f_laser = power2countrate( atten * p_laser, wavelength );

%% Find the relevant file names for the trial and measurement
file_list = dir( directory );
for i = 1 : length( file_list )
    test_name = file_list( i ).name;
    if startsWith( test_name, [ directory '-' trial '-laser-off' ] )
        dark_data_file = test_name;
    elseif startsWith( test_name, [ directory '-' trial '-laser-on' ] )
        light_data_file = test_name;
    end
end

%% First, load and process dark data
load( [directory '/' dark_data_file ] );

% Process the data using SRA method
% Prep arrays for data
TCR_dark = zeros( length( VA_list ), length( holdoff_list ) );
DCR_dark = TCR_dark;
p_ap_intercept_dark = TCR_dark;
p_ap_geometric_dark = TCR_dark;

for j = 1 : length( holdoff_list )
    fig_handle = figure( );
    
    for i = 1 : length( VA_list )
        [ TCR_dark( i, j ), DCR_dark( i, j ), p_ap_intercept_dark( i, j ), p_ap_geometric_dark( i, j ) ] = ...
            SRA_make_plot( raw_data{ i, j }, true, fig_handle );
    end
end

%% Make legend entry with holdoff times
legend_strings = cell( size( holdoff_list ) );
for i = 1 : length( holdoff_list )
   legend_strings{ i } = [ 't_h = ' num2str( 1e6 * min( raw_data{ 1, i } ), '%.2f' ) 'us' ];
end

%% Calculate & plot p_ap_hist for all dark data entries

p_ap_hist = zeros( size( p_ap_geometric_dark ) );

%num_bins = 50;

for i = 1 : length( VA_list )
    for j = 1 : length( holdoff_list )
        %hist = histogram( raw_data{ i, j }, 'NumBins', num_bins );
        figure();
        hist = histogram( raw_data{ i, j } );
        hold on;
        
        num_bins = hist.NumBins;
        
        x_coords = ( hist.BinEdges( 1 : end - 1 ) + hist.BinWidth / 2 )';
        y_coords = hist.Values';

        x_fit_coords = x_coords( end / 2 : end );
        y_fit_coords = y_coords( end / 2 : end );
        
        poisson_pdf = @( norm, x ) norm * exp( -1.0 * DCR_dark( i, j ) * x );
        
        [ norm_fit, resnorm, ~, exitflag, output ] = lsqcurvefit( poisson_pdf, num_points / 2, x_fit_coords, y_fit_coords );
        
        %diffs = y_coords - poisson_pdf( norm_fit, x_coords );
        %sum_length = num_points;
        %p_ap_hist( i, j ) = sum( diffs( 1 : sum_length ) ) / num_points;
        
        p_ap_hist( i, j ) = sum( y_coords - poisson_pdf( norm_fit, x_coords ) ) / num_points;
        
        plot( x_coords, poisson_pdf( norm_fit, x_coords ) );
    end
end

fig_handle = figure( );
hold on;
grid on;
for i = 1 : length( VA_list )
    plot( VA_list, 100 * p_ap_hist( :, i ), 'o--' );
end
legend( legend_strings, 'location', 'NW' );

xlabel( 'Bias Voltage [V]' );
ylabel( 'Histogram Afterpulsing Probability (%) [dimensionless]' );
set( gca, 'fontsize', 12 );

print( fig_handle, [ directory '/' directory '-' trial '-afterpulsing' ], '-dpng' );

%% Now, load and process light data
load( [directory '/' light_data_file ] );

% Process the data using SRA method
% Prep arrays for data
TCR_light = zeros( length( VA_list ), length( holdoff_list ) );
DCR_light = TCR_light;
p_ap_intercept_light = TCR_light;
p_ap_geometric_light = TCR_light;

for j = 1 : length( holdoff_list )
    fig_handle = figure( );
    
    for i = 1 : length( VA_list )
        [ TCR_light( i, j ), DCR_light( i, j ), p_ap_intercept_light( i, j ), p_ap_geometric_light( i, j ) ] = ...
            SRA_make_plot( raw_data{ i, j }, true, fig_handle );
    end
end

DCR_diffs = DCR_light - DCR_dark;
PDP = DCR_diffs / f_laser;

%% Calculate & plot p_ap_hist for all light data entries

p_ap_hist = zeros( size( p_ap_geometric_light ) );

num_bins = 30;

for i = 1 : length( VA_list )
    for j = 1 : length( holdoff_list )
        hist = histogram( raw_data{ i, j }, 'NumBins', num_bins );
        
        x_coords = ( hist.BinEdges( 1 : end - 1 ) + hist.BinWidth / 2 )';
        y_coords = hist.Values';

        x_fit_coords = x_coords( end / 3 : end );
        y_fit_coords = y_coords( end / 3 : end );
        
        poisson_pdf = @( norm, x ) norm * exp( -1.0 * DCR_light( i, j ) * x );
        
        [ norm_fit, resnorm, ~, exitflag, output ] = lsqcurvefit( poisson_pdf, num_points / 10, x_fit_coords, y_fit_coords );
        
        p_ap_hist( i, j ) = sum( y_coords - poisson_pdf( norm_fit, x_coords ) ) / num_points;
    end
end

figure( );
hold on;
grid on;
for i = 1 : length( VA_list )
    plot( VA_list, 100 * p_ap_hist( :, i ), 'o--' );
end
legend( legend_strings, 'location', 'NW' );

xlabel( 'Bias Voltage [V]' );
ylabel( 'Light Histogram Afterpulsing Probability (%) [dimensionless]' );
set( gca, 'fontsize', 12 );

%% Plot PDP vs. V_A trends
fig_handle = figure( );
hold on;
grid on;
for i = 1 : length( holdoff_list )
    plot( VA_list - V_BR, 100 * PDP( :, i ), 'o--' );
end
legend( legend_strings, 'location', 'NW' );

xlabel( [ 'Overbias Voltage [V] (V_{BR} = ' num2str( V_BR ) 'V)' ] );
ylabel( 'PDP %' );
set( gca, 'fontsize', 12 );

xlim( [ VA_list( 1 ) - V_BR, VA_list( end ) - V_BR ] );

dim = [.75 .1 .1 .125];
annot_str = [ 'D = 10' thin_space mu 'm' newline 'T = ' num2str( temps( 1 ) ) thin_space 'K' ];
annotation( 'textbox', dim, 'String', annot_str, ...
    'FitBoxToText', 'on', 'BackgroundColor', 'white' );

%% Save figure as MATLAB fig and flattened PNG
savefig( fig_handle, [ directory '/' directory '-' trial '-PDP' ] );

print( fig_handle, [ directory '/' directory '-' trial '-PDP' ], '-dpng' );

%% Now plot the DCR vs. V_A trends
fig_handle = figure( );
hold on;
grid on;
for i = 1 : length( holdoff_list )
    plot( VA_list - V_BR, DCR_dark( :, i ), 'o--' );
end
legend( legend_strings, 'location', 'NW' );

xlabel( [ 'Overbias Voltage [V] (V_{BR} = ' num2str( V_BR ) 'V)' ] );
ylabel( 'Fitted Dark Count Rate [kHz]' );
set( gca, 'fontsize', 12 );

xlim( [ VA_list( 1 ) - V_BR, VA_list( end ) - V_BR ] );

print( fig_handle, [ directory '/' directory '-' trial '-DCR' ], '-dpng' );

%% Now find the peak detection probability for 10ms readout for each overvoltage and plot
PDP_means = mean( PDP, 2 );
DCR_dark_means = mean( DCR_dark, 2 );

max_events = 1000;
events = 0 : max_events;
p_ap = 0.0;

max_p_good = [];

rate_50um_trap_10um_SPAD_cps = 12.5e6 * 0.0025 * 0.8;

for i = 1 : length( VA_list )
    
    poisson_rate_light = PDP_means( i ) * rate_50um_trap_10um_SPAD_cps;
    poisson_rate_dark = DCR_dark_means( i );
    rate_light = poisson_rate_light / ( 1 - p_ap );
    rate_dark = poisson_rate_dark / ( 1 - p_ap );

    delta_t = 10e-3;    % 10ms, let's shoot for fairly slow readout with STI GR SPADs

    dist_light = poisspdf( events, (rate_light + rate_dark) * delta_t );
    dist_dark = poisspdf( events, rate_dark * delta_t );

    % If counts above threshold, register a detection
    p_good_given_light = zeros( 1, length( events ) );
    p_error_given_light = zeros( 1, length( events ) );
    p_good_given_dark = zeros( 1, length( events ) );
    p_error_given_dark = zeros( 1, length( events ) );
    p_good = zeros( 1, length( events ) );

    for j = 1 : length( events )
        thres = events( j );
        p_good_given_light( j ) = sum( dist_light( j + 1 : end ) );
        p_error_given_light( j ) = sum( dist_light( 1 : j ) );
        p_good_given_dark( j ) = sum( dist_dark( 1 : j ) );
        p_error_given_dark( j ) = sum( dist_dark( j + 1 : end ) );
        p_good( j ) = min( p_good_given_light( j ), p_good_given_dark( j ) );
    end
    
    max_p_good( i ) = max( p_good );
    
end

figure()
plot( VA_list - V_BR, max_p_good, 'o--' );

grid on;
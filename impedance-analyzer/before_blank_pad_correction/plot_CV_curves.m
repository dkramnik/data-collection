load( '5um_STI_GR_CV_sweep_dark.mat' );

bias_list_5um = bias_list;
CP_meas_5um = CP_meas;
C_per_area_5um = CP_meas_5um / ( pi * ( 2.5e-6 )^2 );

load( '10um_STI_GR_CV_sweep_dark.mat' );

bias_list_10um = bias_list;
CP_meas_10um = CP_meas;
C_per_area_10um = CP_meas_10um / ( pi * ( 5.0e-6 )^2 );

load( '15um_STI_GR_CV_sweep_dark.mat' );

bias_list_15um = bias_list;
CP_meas_15um = CP_meas;
C_per_area_15um = CP_meas_15um / ( pi * ( 7.5e-6 )^2 );

%% Plot raw CV curves
figure( );

plot( bias_list_5um, CP_meas_5um, 'o--' );
hold on;
plot( bias_list_10um, CP_meas_10um, 'o--' );
plot( bias_list_15um, CP_meas_15um, 'o--' );

grid on;

legend( '5um', '10um', '15um' );

%% Plot C per area vs. V for 3 devices (all should ideally be equal)
figure( );

plot( bias_list_5um, C_per_area_5um, 'o--' );
hold on;
plot( bias_list_10um, C_per_area_10um, 'o--' );
plot( bias_list_15um, C_per_area_15um, 'o--' );

grid on;

legend( '5um', '10um', '15um' );
grid on;

%% Make 1/CA^2 plot
figure( );

C_per_area_15um_corrected = C_per_area_15um - 0.03e-12 / ( pi * ( 7.5e-6 )^2 ) * ones( size( C_per_area_15um ) );

plot( bias_list_15um, 1 ./ ( C_per_area_15um_corrected.^2 ), 'o--' );
hold on;

plot_limits = [ -1, 1 ];
xlim( plot_limits );
grid on;

P = polyfit( bias_list_15um( bias_list_15um >= -1 ), ...
    1 ./ C_per_area_15um_corrected( bias_list_15um >= -1 ).^2, ...
    1 );
plot( plot_limits, polyval( P, plot_limits ) );

V_bi = -1 * P(2) / P(1);

y_limits_orig = ylim;
ylim( [ 0 y_limits_orig( 2 ) ] );
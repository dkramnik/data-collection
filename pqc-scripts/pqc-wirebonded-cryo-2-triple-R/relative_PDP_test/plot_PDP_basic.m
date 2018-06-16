close all
clear
clc

lw = 1.25;
fs = 14;

load( 'pqc_wirebonded_cryo_2_fast_laser_off_140K.mat' );

% Plot total pulses vs. overbias
figure( )

CDF_peaks = zeros( 1, length( data_cells ) );
for i = 1 : length( data_cells )
    CDF_peaks( i ) = max( data_cells{ i }.pulse_CDF_mean );
end
%plot( VA_list, CDF_peaks / delta_T, 'o--', 'linewidth', lw );
CDF_peaks_log_modified_laser_off = CDF_peaks;
CDF_peaks_log_modified_laser_off( CDF_peaks_log_modified_laser_off == 0 ) = 1e-10;
semilogy( VA_list, CDF_peaks_log_modified_laser_off / delta_T, 'o--', 'linewidth', lw );
ylim( [ 1 1e8 ] );
hold on;
grid on;

xlabel( 'V_A [V]' );
ylabel( 'Counts in 1s' );
set( gca, 'fontsize', fs );

load( 'pqc_wirebonded_cryo_2_fast_laser_20mA_140K.mat' );

CDF_peaks = zeros( 1, length( data_cells ) );
for i = 1 : length( data_cells )
    CDF_peaks( i ) = max( data_cells{ i }.pulse_CDF_mean );
end
%plot( VA_list, CDF_peaks / delta_T, 'o--', 'linewidth', lw );
CDF_peaks_log_modified_laser_on = CDF_peaks;
CDF_peaks_log_modified_laser_on( CDF_peaks_log_modified_laser_on == 0 ) = 1e-10;
semilogy( VA_list, CDF_peaks_log_modified_laser_on / delta_T, 'o--', 'linewidth', lw );
ylim( [ 1 1e8 ] );

figure( )

plot( VA_list, ( CDF_peaks_log_modified_laser_on - CDF_peaks_log_modified_laser_off ) / delta_T, 'o--', 'linewidth', lw );
%ylim( [ 1 1e8 ] );

xlabel( 'V_A [V]' );
ylabel( 'Photon Counts in 1s' );
set( gca, 'fontsize', fs );

%% Plots data collected using 'pqc_get_single_pulse_dist.m' at a single
% temperature

% First, clean up
close all
clear
clc

load( 'room_temp_test_10x_0pt1s.mat' );

% Figure parameters
lw = 1.25;
fs = 14;

%% Smooth CDF and calculate PDF from smoothed CDF
% for i = 1 : length( VA_list )
%     data_cells{ i }.pulse_CDF_mean_smoothed = smooth( data_cells{ i }.pulse_CDF_mean, 'loess' );
%     pulse_PDF_mean_smoothed = -1 * diff( data_cells{ i }.pulse_CDF_mean_smoothed );
%     pulse_PDF_mean_smoothed( pulse_PDF_mean_smoothed < 0 ) = 0;
%     data_cells{ i }.pulse_PDF_mean_smoothed = pulse_PDF_mean_smoothed;
% end

%% Plot total pulses vs. overbias
figure( )

CDF_peaks = zeros( 1, length( data_cells ) );
for i = 1 : length( data_cells )
    CDF_peaks( i ) = max( data_cells{ i }.pulse_CDF_mean );
end
plot( VA_list, CDF_peaks / delta_T, 'o--', 'linewidth', lw );
grid on;

xlabel( 'V_A [V]' );
ylabel( 'Counts in 1s' );
set( gca, 'fontsize', fs );

%% Plot CDF vs. overbias
figure( )

for i = 1 : length( data_cells )
    plot( 1e3 * data_cells{ i }.Vt_list_current, data_cells{ i }.pulse_CDF_mean );
    hold on;
end
grid on;

title( 'CDF, No Smoothing' );
xlabel( 'V_{thres.} [mV]' );
ylabel( 'Pulses in Bin' );
legend( sprintfc( 'V_A = %.1fV', VA_list ) );
set( gca, 'fontsize', fs );

%% Plot raw PDF vs. overbias
figure( )

for i = 1 : length( data_cells )
    plot( 1e3 * data_cells{ i }.Vt_bin_centers, data_cells{ i }.pulse_PDF_mean );
    hold on;
end
grid on;

xlabel( 'V_{thres.} [mV]' );
ylabel( 'Pulses in Bin' );
legend( sprintfc( 'V_A = %.1fV', VA_list ) );
set( gca, 'fontsize', fs );

%% Plot y-normalized PDF vs. overbias
figure( )

for i = 1 : length( data_cells )
    plot( 1e3 * data_cells{ i }.Vt_bin_centers, data_cells{ i }.pulse_PDF_mean / norm( data_cells{ i }.pulse_PDF_mean ) );
    hold on;
end
grid on;

xlabel( 'V_{thres.} [mV]' );
ylabel( 'Normalized PDF' );
legend( sprintfc( 'V_A = %.1fV', VA_list ) );
set( gca, 'fontsize', fs );

%% Plot x-normalized and y-normalized PDF vs. overbias
figure( )

for i = 1 : length( data_cells )
    if( sum(data_cells{ i }.pulse_PDF_mean( : ) ) ~= 0 ) % Eliminate all-zero vectors
        % Find the "max" pulse height (1/1000 the mode on the upper side)
        logical_vec = data_cells{ i }.pulse_PDF_mean < 1 / 100 * max( data_cells{ i }.pulse_PDF_mean );
        logical_inds = find( logical_vec == 0 );
        peak_pulse_index = logical_inds( end );

        plot( data_cells{ i }.Vt_bin_centers / data_cells{ i }.Vt_bin_centers( peak_pulse_index ), data_cells{ i }.pulse_PDF_mean / norm( data_cells{ i }.pulse_PDF_mean ) );
        hold on;
    end
end
grid on;

xlabel( 'V_{pulse} / V_{max} [dimensionless]' );
ylabel( 'Normalized PDF' );
legend( sprintfc( 'V_A = %.1fV', VA_list ) );
set( gca, 'fontsize', fs );
xlim( [ 0 2 ] );

%% Plot PDF peak V_thres and height vs. overbias
figure( )

PDF_peaks = zeros( 1, length( data_cells ) );
PDF_peak_thresh = zeros( 1, length( data_cells ) );
for i = 1 : length( data_cells )
    [ PDF_peaks( i ), ind ] = max( data_cells{ i }.pulse_PDF_mean );
    PDF_peak_thresh( i ) = data_cells{ i }.Vt_bin_centers( ind );
end
yyaxis left
plot( VA_list, PDF_peaks, 'o--', 'linewidth', lw );
hold on;
ylabel( 'PDF Peak Value [Counts]' );

yyaxis right
plot( VA_list, 1000 * PDF_peak_thresh, 'o--', 'linewidth', lw );
ylabel( 'PDF Peak Bin [mV]' );

grid on;

xlabel( 'V_A [V]' );
set( gca, 'fontsize', fs );
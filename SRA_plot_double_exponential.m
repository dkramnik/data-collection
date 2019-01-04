function SRA_plot_double_exponential( raw_interarrival_times, holdoff_time, params, plot_title )
% SRA_fit_double_exponential
%   Fit a double-exponential model to a sequence of ranged amplitudues
%   (SRA) made from an input vector of SPAD interarrival time data

    % Check if all interarrivals are greater than stated holdoff time and warn user if they aren't
    if( holdoff_time > min( raw_interarrival_times ) )
       warning( 'Holdoff time is greater than minimum interarrival time, fit may be invalid.' ); 
    end

    % Sort data
    sorted_data = sort( raw_interarrival_times, 'descend' );
    sorted_data = reshape( sorted_data, 1, length( sorted_data ) );
    
    % Make CDF vector
    len = length( sorted_data );   
    n = 1 : len;    % SRA indices with n = 1 being the longest interarrival
    cdf_vec = ( len - n ) / len;
    
    % Define dual exponential fitting function:
    %   params = [ P_AP, lambda_AP, lambda_PDC ]
    fit_func_dual_exp_cdf = @( params, x_data ) ...
        1 ...
        - ( 1 - params( 1 ) ) .* exp( -1 .* params( 3 ) .* ( x_data - holdoff_time ) ) ...
        - params( 1 ) .* exp( -1 .* params( 2 ) .* ( x_data - holdoff_time ) );
    
    % Reformat results to plot them on a standard SRA axis (put in
    % different function?)
    x_plot_data_realistic = -1 * log( 1 - cdf_vec );
    x_plot_fit_realistic = -1 * log( 1 - fit_func_dual_exp_cdf( params, sorted_data ) );
    y_plot_realistic = sorted_data / mean( sorted_data );
    
    figure( )
    plot( x_plot_data_realistic, y_plot_realistic, 'o' );
    hold on;
    plot( x_plot_fit_realistic, y_plot_realistic, 'o--' );
    title( plot_title );
    legend( 'Data', 'Fit', 'location', 'best' );
    xlabel( 'ln[N/n(x_n)]' );
    ylabel( 'SRA Data, x_n/<x_n>' );
    
    %figure( )
    %plot( x_plot_fit_realistic, 'o--' )
    
    x_limits = xlim;
    xlim( [ 0, x_limits( 2 ) ] );
    
    grid on;
end
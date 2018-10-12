function [ param_fit, fit_func_dual_exp_cdf ] = SRA_fit_double_exponential( raw_interarrival_times )
% SRA_fit_double_exponential
%   Fit a double-exponential model to a sequence of ranged amplitudues
%   (SRA) made from an input vector of SPAD interarrival time data

    % Sort data
    sorted_data = sort( raw_interarrival_times, 'descend' );
    %sorted_data = transpose( sorted_data ); % Why?
    sorted_data = reshape( sorted_data, 1, length( sorted_data ) );
    
    % Make CDF vector
    len = length( sorted_data );   
    n = 1 : len;    % SRA indices with n = 1 being the longest interarrival
    cdf_vec = ( len - n ) / len;
    
    % Estimate holdoff time (assuming dense data set for characterization)
    holdoff_time = sorted_data( end );  % Small error due to comparator blanking time
     
    % Define dual exponential fitting function:
    %   params = [ P_AP, lambda_AP, lambda_PDC ]
    fit_func_dual_exp_cdf = @( params, x_data ) ...
        + 1 ...
        - ( 1 - params( 1 ) ) .* exp( -1 .* params( 3 ) .* ( x_data - holdoff_time ) ) ...
        - params( 1 ) .* exp( -1 .* params( 2 ) .* ( x_data - holdoff_time ) );
    
    % Make a rough initial parameter guess
    P_AP_guess = 0.1;
    lambda_PDC_guess = 1 / mean( sorted_data );
    lambda_AP_guess = 100 * lambda_PDC_guess;   % Large initial separation tends to make fit run faster
    param_guess = [ P_AP_guess, lambda_AP_guess, lambda_PDC_guess ];
        
    % Perform gradient descent least squares fit
    [ param_fit, ~, ~, ~, ~ ] = lsqcurvefit( fit_func_dual_exp_cdf, param_guess, sorted_data, cdf_vec );
    
    % Reformat results to plot them on a standard SRA axis (put in
    % different function?)
    x_plot_data_realistic = - log( 1 - cdf_vec );
    x_plot_fit_realistic = - log( 1 - fit_func_dual_exp_cdf( param_fit, sorted_data ) );
    y_plot_realistic = sorted_data / mean( sorted_data );
    
end
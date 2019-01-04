function [ TCR, DCR, p_ap_fast ] = SRA_make_plot( raw_data, draw_figure, fig_handle, x_fit_lim )
% time data to extract total count rate (TCR), dark count rate (DCR), and
% afterpulsing probability.
    
    % Default fit limits:
    if isempty( x_fit_lim )
        x_fit_lim = [ 1.0 4.0 ];
    end
    
    len = length( raw_data );
    sorted_data = sort( raw_data, 'descend' );
    
    holdoff_time = sorted_data( end );  % Small error due to 45ns delay line
    
    n = 1 : len;
    x = log( len ./ n );
    y = transpose( sorted_data );
    
    mdl = fitlm( ...
        x( x > x_fit_lim( 1 ) & x < x_fit_lim( 2 ) ), ...
        y( x > x_fit_lim( 1 ) & x < x_fit_lim( 2 ) ) );
    mdl = fitlm( ...
        x( y > 0.01 * max( y ) ), ...
        y( y > 0.01 * max( y ) ) );
    slope = mdl.Coefficients{ 'x1', 'Estimate' };
    y_intercept = mdl.Coefficients{ '(Intercept)', 'Estimate' };
    x_intercept = ( abs( y_intercept ) + holdoff_time ) / slope;
    
    TCR = 1 / mean( sorted_data );
    DCR = 1 / slope;
    
    % Approximation assuming fast afterpulse decay time
    p_ap_fast = 1 + DCR * ( holdoff_time - mean( sorted_data ) );
    
    disp( [ 'TCR = ' num2str( TCR ) ', DCR = ' num2str( DCR ) ...
        ', p_ap_fast = ' num2str( p_ap_fast ) ] );
    
    if draw_figure
        
        if isempty( fig_handle )
            figure( );
        end
        
        hold on;
        grid on;
        
        plot( x, slope * x + y_intercept, 'k--' );
        plot( x, y );
        
    end
    
end


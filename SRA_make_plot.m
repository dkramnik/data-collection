function [ TCR, DCR, p_ap_intercept, p_ap_geometric ] = SRA_make_plot( raw_data, draw_figure, fig_handle, x_fit_lim )
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
    
    % Using intercept method
    p_ap_intercept = x_intercept;
    % Using geometric series estimate, without dead time correction
    p_ap_geometric = ( TCR / DCR - 1 ) / ( TCR / DCR );
    
    disp( [ 'TCR = ' num2str( TCR ) ', DCR = ' num2str( DCR ) ...
        ', p_ap_intercept = ' num2str( p_ap_intercept ) ...
        ', p_ap_geometric = ' num2str( p_ap_geometric ) ] );
    
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


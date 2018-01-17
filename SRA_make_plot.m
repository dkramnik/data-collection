function [ TCR, DCR, p_ap_intercept, p_ap_geometric ] = SRA_make_plot( raw_data, draw_figure )
% Apply sequence of ranged amplitudes method to analyzer SPAD interarrival
% time data to extract total count rate (TCR), dark count rate (DCR), and
% afterpulsing probability.
    
    len = length( raw_data );
    sorted_data = sort( raw_data, 'descend' );
    
    holdoff_time = sorted_data( end );  % Small error due to 45ns delay line
    
    n = 1 : len;
    x = log( len ./ n );
    y = transpose( sorted_data );
    
    if draw_figure
        figure( );
        plot( x, y );
    end
    
    mdl = fitlm( x( x > 1.0 & x < 6.0 ), y( x > 1.0 & x < 6.0 ) );
    slope = mdl.Coefficients{ 'x1', 'Estimate' };
    y_intercept = mdl.Coefficients{ '(Intercept)', 'Estimate' };
    x_intercept = ( abs( y_intercept ) + holdoff_time ) / slope;
    
    TCR = 1 / mean( sorted_data );
    DCR = 1 / slope;
    
    % Using intercept method
    p_ap_intercept = x_intercept;
    % Using geometric series estimate
    p_ap_geometric = ( TCR / DCR - 1 ) / ( TCR / DCR );
    
    disp( [ 'TCR = ' num2str( TCR ) ', DCR = ' num2str( DCR ) ...
        ', p_ap_intercept = ' num2str( p_ap_intercept ) ...
        ', p_ap_geometric = ' num2str( p_ap_geometric ) ] );
    
end


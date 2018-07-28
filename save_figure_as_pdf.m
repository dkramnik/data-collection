function save_figure_as_pdf( figure, filename )

    set( figure, 'Units', 'Inches' );
    pos = get( figure, 'Position' );
    set( figure, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [pos(3), pos(4)] );
    print( figure, '-dpdf', [ filename '.pdf' ], '-r0' );

end


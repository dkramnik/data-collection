function IMPED_ANALYZER = IMPED_ANALYZER_open_gpib( imped_analyzer_addr )
% For HP 4284A/4285A

    if( isempty( imped_analyzer_addr ) )  % Use default address for lab's 4284A
        imped_analyzer_addr = 18;
    end
    
    IMPED_ANALYZER = visa( 'ni', [ 'GPIB0::' num2str( imped_analyzer_addr ) '::INSTR' ] );
    fopen( IMPED_ANALYZER );
    
    fprintf( IMPED_ANALYZER, '*RST' );                     % Reset to default settings
    
end
function [ inst_id, temps ] = TEMP_get_temps( addr, verbose )
% Gets a Kelvin temp. reading of channels A, B, C, and D of a Lakeshore
% controller. If the controller has fewer channels, then then invalid
% channels will cycle through A and B.

    if( isempty( addr ) )   % Default address = 12
        addr = 12;
    end
    
    if( isempty( verbose ) )   % Default is verbose
        verbose = true;
    end
    
    % Create instrument object and open communication
    TEMP = visa( 'ni', [ 'GPIB0::' num2str( addr ) '::INSTR' ] );
    fopen( TEMP );
    
    temps = zeros( 4, 1 );
    
    % Fetch and store the instrument ID. Useful for picking the appropriate
    % temp. channels during data processing
    fprintf( TEMP, '*IDN?' );
    inst_id = fgetl( TEMP );
    
    % Fetch the readings from the temp. controller
    fprintf( TEMP, 'KRDG? A' );
    temps( 1 ) = str2double( fgetl( TEMP ) );
    
    fprintf( TEMP, 'KRDG? B' );
    temps( 2 ) = str2double( fgetl( TEMP ) );
    
    fprintf( TEMP, 'KRDG? C' );
    temps( 3 ) = str2double( fgetl( TEMP ) );
    
    fprintf( TEMP, 'KRDG? D' );
    temps( 4 ) = str2double( fgetl( TEMP ) );
    
    if( verbose )
        fprintf( 'Lakeshore temps: ' );
        fprintf( [ 'A = ' num2str( temps( 1 ) ) 'K, ' ] );
        fprintf( [ 'B = ' num2str( temps( 2 ) ) 'K, ' ] );
        fprintf( [ 'C = ' num2str( temps( 3 ) ) 'K, ' ] );
        fprintf( [ 'D = ' num2str( temps( 4 ) ) 'K\n' ] );
    end
    
    fclose( TEMP );
    delete( TEMP );
    
end
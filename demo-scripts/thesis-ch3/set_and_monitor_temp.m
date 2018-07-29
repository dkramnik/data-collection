delete( instrfind );

setpoint = 125;

TEMP_set_temp_setpoint( [ ], setpoint, 'true' );

times = [ ];
temps_cold_head = [ ];
temps_rad_shield = [ ];

figure( )

zoom_threshold = 1;
lw = 1.25;
fs = 14;

tic;
while( 1 )
    
    times = [ times toc ];
	[ id, temps_last ] = TEMP_get_temps( [ ], [ ] );
	temps_cold_head = [ temps_cold_head temps_last( 2 ) ];
    temps_rad_shield = [ temps_rad_shield temps_last( 1 ) ];
    
    % Zoom in when the regulation gets close
    if( abs( temps_cold_head( end ) - setpoint ) < zoom_threshold )
        plot( times( temps_cold_head - setpoint < zoom_threshold ), ...
            temps_cold_head( temps_cold_head - setpoint < zoom_threshold ), 'o--' );
        hold on;
    else
        plot( times, temps_cold_head, 'o--' );
        hold on;
    end
    
    plot( times, setpoint * ones( size( times ) ) );
    hold off;
    grid on;
    
    pause( 0.1 );   % Required for re-drawing the figure each time
end
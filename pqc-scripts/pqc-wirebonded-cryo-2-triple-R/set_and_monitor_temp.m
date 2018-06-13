setpoint = 280;

TEMP_set_temp_setpoint( [ ], setpoint, 'true' );

times = [ ];
temps_cold_head = [ ];
temps_rad_shield = [ ];

figure( )
lw = 1.25;
fs = 14;

tic;
while( 1 )
    times = [ times toc ];
	[ id, temps_last ] = TEMP_get_temps( [ ], [ ] );
	temps_cold_head = [ temps_cold_head temps_last( 2 ) ];
    temps_rad_shield = [ temps_rad_shield temps_last( 1 ) ];
    
    plot( times, temps_cold_head, 'o--' );
    hold on;
    plot( times, setpoint * ones( size( times ) ) );
    hold off;
    
end
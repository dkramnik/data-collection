I_ph_5um_edge = 0.36;
I_ph_10um_edge = 0.38;
I_ph_10um_center = 0.21;
I_ph_15um_edge = 0.46;

I_ph_list = [ I_ph_5um_edge, I_ph_10um_edge, I_ph_15um_edge ];

EQE_mean_list = zeros( size( I_ph_list ) );
EQE_std_list = zeros( size( I_ph_list ) );

lambda = 405e-9;

P_laser_list = [ 3.74, 5.75, 5.93 ];

for ind = 1 : length( I_ph_list )
    
    [ ~, ~, qe_list ] = power2quantumeff( P_laser_list, lambda, I_ph_list( ind ) );
    
    EQE_mean_list( ind ) = mean( qe_list );
    EQE_std_list( ind ) = std( qe_list );
end

disp( EQE_mean_list );
disp( EQE_std_list );
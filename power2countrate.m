function [ countrate ] = power2countrate( power, lambda )
% Find photons/second given power and wavelength
    
    h = 6.626176 * 10^-34;  % MKS units
    E_photon = h * physconst('LightSpeed') / lambda;
    
    countrate = power / E_photon;

end


function [ countrate ] = power2countrate( power, lambda )
% Syntax:
%   [ countrate ] = power2countrate( power, lambda )
%
% Description:
%   Find photons/second given light power and wavelength
    
    h = 6.626176 * 10^-34;  % MKS units
    E_photon = h * physconst('LightSpeed') / lambda;
    
    countrate = power / E_photon;

end
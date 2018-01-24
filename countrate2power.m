function [ power ] = countrate2power( countrate, lambda )
% Syntax:
%   [ power ] = countrate2power( countrate, lambda )
%
% Description:
%   Find light power given photons/second and wavelength
    
    h = 6.626176 * 10^-34;  % MKS units
    E_photon = h * physconst('LightSpeed') / lambda;
    
    power = E_photon * countrate;

end
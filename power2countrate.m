function [ countrate, photocurrent ] = power2countrate( power, lambda )
% Syntax:
%   [ countrate ] = power2countrate( power, lambda )
%
% Description:
%   Find photons/second given light power and wavelength
    
    q_e = 1.602176487 * 10^-19;  % Electron charge (MKS units)
    h = 6.626176 * 10^-34;  % Planck's constant (MKS units)
    E_photon = h * physconst('LightSpeed') / lambda;
    
    countrate = power / E_photon;
    photocurrent = countrate * q_e;
end
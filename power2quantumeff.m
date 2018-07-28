function [ countrate, photocurrent_expected, qe ] = power2quantumeff( power, lambda, photocurrent_measured )
% Syntax:
%   [ countrate, photocurrent_expected, qe ] = power2countrate( power, lambda )
%
% Description:
%   Find photons/second given light power and wavelength
    
    q_e = 1.602176487 * 10^-19;  % Electron charge (MKS units)
    h = 6.626176 * 10^-34;  % Planck's constant (MKS units)
    E_photon = h * physconst('LightSpeed') / lambda;
    
    countrate = power / E_photon;
    photocurrent_expected = countrate * q_e;
    qe = photocurrent_measured / photocurrent_expected;
end
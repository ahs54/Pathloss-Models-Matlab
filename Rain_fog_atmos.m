close all
clear all
clc
%% Rain
distance = 1e3;                
rain = [1 4 16 50]; 
elev = 0;                 
pol = 0;                
f = (10:1000).'*1e9;
freq = (10:1000).'*1e9;
range = 1e3;  

for m = 1:numel(rain)
    rain_atten(:,m) = rainpl(distance,f,rain(m),elev,pol)';
end
figure
loglog(f/1e9,rain_atten,'LineWidth',2); grid on;

xlabel('Frequency (GHz)');
ylabel('Rain Attenuation (dB/km)')
title('Rain Losses for Horizontal Polarization');
legend('Little rain','Medium rain','Heavy rain','Extreme rain','location','Southeast')

%%
%%fog attenuation 
Tem = 15;                      % 15 degree Celsius
dens = [0.05 0.5];   % water density in g/m^3
for m = 1: numel(dens)
    fog_atten(:,m) = fogpl(range,freq,Tem,dens(m))';
end
figure
loglog(freq/1e9,fog_atten,'LineWidth',2); grid on;

xlabel('Frequency in GHz');
ylabel('Fog Losses in dB/km')
title('Fog Attenuation');
legend('Medium fog','Heavy fog','location','Southeast')

%% atmospheric gas losses 
Press = 101300; % air pressure in Pa
Vapor = 7.5;  % vapour density in g/m^3
gas_atten = gaspl(range,freq,Tem,Press,Vapor);
figure
loglog(freq/1e9,gas_atten,'LineWidth',2); grid on;
axis([0 100 0 10^5])
xlabel('Frequency in GHz');
ylabel('Losses in dB/km')
title('Atmospheric Gas Losses');

% legend('Medium fog','Heavy fog','Atmospheric Gasses','Location','north');
clc
% close all
% clear all
%% To change the value of the frequency the change the variable "f" 

%% foliage attenuation "fixed distance"


d = 1:400;

f = 28e9;% in paper we have 28 GHz 

L = 0.2*(f^0.3)*(d.^0.6);  %ITU-R model between 200 MHz and 95 GHz and d < 400 m


for ii=1:length(d)
if d(ii)<14 
   L2(ii) = 0.45*f^0.284 .*d(ii) ;% f should be in GHz
elseif d(ii)>=14   
    L2(ii) = 1.33*(f^0.284)*(d(ii).^0.588);%Weissberger’s modified exponential decay model between 230 MHz and 95 GHz 
end
end
  
for ii=1:length(d)
 
if d(ii)<200
    L3(ii) = 15.6*(f^-0.009)*(d(ii).^0.26);%Cost 235 model between 9.6 and 57 GHz and d < 200 m
    else
    L3(ii) = 0;
end
end
  


%% Rain
distance = 1e3;                
rain_rate = 16; 
elev = 0;                 
pol = 0;                
% f = (10:1000).'*1e9;
% freq = (10:1000).'*1e9;
range = 1e3;  


rain_atten = rainpl(d,f,rain_rate,elev,pol)';

%%
%%fog attenuation 
Tem = 15;                      % 15 degree Celsius
dens = 0.5;   % water density in g/m^3
fog_atten = fogpl(d,f,Tem,dens)';



%% atmospheric gas losses 
Press = 101300; % air pressure in Pa
Vapor = 7.5;  % vapour density in g/m^3
gas_atten = gaspl(d,f,Tem,Press,Vapor);



% L4= 0.39*(f^0.39)*d.^0.25; % FITU-R model between 11.2 and 20 GHz

%% PL Models
gamma = 2.7;
d0 = 1;
% k=7.94328234e-5
% kdb=10*log10(k);
c = 3e8;

lamda = c/f;

for d=1:400
%free space pathloss


FSPLC(d) = 20*log10(4*pi*d*f/c);


%% CI Pathloss model
Gr = 1;
Gt = 1;
c = 3e8;

lamda = c/f;



nci = 2.9;
sigmaci = 7;
FSPL = 20*log10((4*pi*f)/c);
Xci = sigmaci*randn(1);

PLCI(d) = FSPL+10*nci*log10(d);
PLCI_rain_withoutshadowing(d) = FSPL+10*nci*log10(d)+rain_atten(d) + fog_atten(d) + gas_atten(d)+10*log10(L2(d));
PLCI_rain(d) = FSPL+10*nci*log10(d)+Xci+rain_atten(d) + fog_atten(d) + gas_atten(d)+10*log10(L2(d));
%% ABG model
alfaABG = 3.5;
betaABG = 13.6;
gammaABG = 2.4;
sigmaABG = 7;
ABGPL_noise_rain(d) = 10*alfaABG*log10(d)+betaABG+10*gammaABG*log10(f/(10^9))+sigmaABG*randn(1)+ rain_atten(d) + fog_atten(d) + gas_atten(d)+10*log10(L2(d)); %to get f in GHz
ABGPL_rain(d) = 10*alfaABG*log10(d)+betaABG+10*gammaABG*log10(f/(10^9)) + rain_atten(d) + fog_atten(d) + gas_atten(d)+10*log10(L2(d)) ;
ABGPL_shadow(d) = 10*alfaABG*log10(d)+betaABG+10*gammaABG*log10(f/(10^9));

end

distance = 1:length(ABGPL_noise_rain);
ABGPL_noise_rain = nonzeros(ABGPL_noise_rain);
 PLCI_rain = nonzeros(PLCI_rain);
FSPLC = nonzeros(FSPLC);
figure(1);plot(distance,ABGPL_noise_rain,'LineWidth',2);
 hold on;
plot(distance,PLCI_rain,'LineWidth',2);
 hold on;
 plot(distance,FSPLC,'LineWidth',2);
 grid on;
xlabel('Distance(m)');
ylabel('PL(dB)')
legend('ABGL with shadowing ','PLCI with shadowing','FSPL','location','Southeast')
title('Rain,shadowing,fog,atmospheric losses with ABG and CI PL models');

%% 
figure(2)

ABGPL_rain = nonzeros(ABGPL_rain);
 plot(distance,ABGPL_rain,'LineWidth',2);
 grid on;
 hold on;
 


 PLCI_rain_withoutshadowing = nonzeros(PLCI_rain_withoutshadowing);
 plot(distance, PLCI_rain_withoutshadowing,'LineWidth',2);
 grid on;
 hold on;
 plot(distance,FSPLC,'LineWidth',2);

 
 
 xlabel('Distance(m)');
ylabel('PL(dB)')
legend('ABGL without Shadowing','PLCI Without shadowing','FSPL','location','Southeast')
title('Rain,fog,atmospheric losses with ABG and CI PL models ');
%%
figure(3)
ABGPL_shadow = nonzeros(ABGPL_shadow);
plot(distance,ABGPL_shadow,'LineWidth',2);
grid on;
hold on;
 


 PLCI = nonzeros(PLCI);
 plot(distance, PLCI,'LineWidth',2);
 grid on;
 hold on;
%  plot(distance,FSPLC,'LineWidth',2);
xlabel('Distance(m)');
ylabel('PL(dB)')
% legend('ABGL at 73','PLCI at 73','location','Southeast')
title( ['ABG vs CI PL models '] )
% title(['ABG vs CI PL models at GHz',num2str(f/1e9)])
% title('ABG vs CI PL models at %f',f);

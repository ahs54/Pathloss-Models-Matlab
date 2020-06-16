clc
clear all

gamma=2.7;
d0=1;
% k=7.94328234e-5
% kdb=10*log10(k);
c = 3e8;
f = 73e9;
lamda=c/f;

for d=1:400
%free space pathloss


FSPLC(d) = 20*log10(4*pi*d*f/c);


%% CI Pathloss model
Gr = 1;
Gt = 1;
c = 3e8;
f = 73e9;
lamda = c/f;



nci = 2.9;
sigmaci = 7;
FSPL = 20*log10((4*pi*f)/c);
Xci = sigmaci*randn(1);
PLCI_noise(d) = FSPL+10*nci*log10(d)+Xci;
PLCI(d) = FSPL+10*nci*log10(d);
%% ABG model
alfaABG = 3.5;
betaABG = 13.6;
gammaABG = 2.4;
sigmaABG = 7;
ABGPL_noise(d) = 10*alfaABG*log10(d)+betaABG+10*gammaABG*log10(f/(10^9))+sigmaABG*randn(1); %to get f in GHz
ABGPL(d) = 10*alfaABG*log10(d)+betaABG+10*gammaABG*log10(f/(10^9));


end

distance = 1:length(ABGPL);
ABGPL = nonzeros(ABGPL);
PLCI_noise = nonzeros(PLCI_noise);
FSPLC = nonzeros(FSPLC);

plot(distance,ABGPL);
hold on;
plot(distance,PLCI_noise);
hold on;
plot(distance,FSPLC,'linewidth',2);
grid on;
xlabel('Distance(m)');
ylabel('PL(dB)')

hold on
%% foliage attenuation "fixed distance"

d = 1:400;

f = 73e9;

L = 0.2*(f^0.3)*(d.^0.6);  %ITU-R model between 200 MHz and 95 GHz and d < 400 m
plot(d,10*log(L));% in the eqn the frequency should be in MHz
hold on

for ii=1:length(d)
if d(ii)<14 
   L2(ii) = 0.45*f^0.284 .*d(ii) ;% f should be in GHz
elseif d(ii)>=14   
    L2(ii) = 1.33*(f^0.284)*(d(ii).^0.588);%Weissberger’s modified exponential decay model between 230 MHz and 95 GHz 
end
end
    plot(d,10*log(L2));
    hold on

L3 = 15.6*(f^-0.009)*(d.^0.26);%Cost 235 model between 9.6 and 57 GHz and d < 200 m
plot(d,10*log(L3))% in the eqn the frequency should be in MHz
hold on

L4=0.39*(f^0.39)*d.^0.25; % FITU-R model between 11.2 and 20 GHz
plot(d,10*log(L4))
grid on 
hold on

xlabel('Distance in m');
ylabel('Loss in dB')
title('Loss vs Distance for different models')
axis([0 400 0 300])


legend('ABGPL','PLCI with noise','FSPL','ITU__R model','Foliage exponential decay model','Foliage Cost 235 model','Foliage FITR model','location','north')


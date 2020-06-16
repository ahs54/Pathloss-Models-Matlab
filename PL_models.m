clc
clear all

gamma=2.7;
d0=1;
% k=7.94328234e-5
% kdb=10*log10(k);
c=3e8;
f=73e9;
lamda=c/f;

for d=1:400
%free space pathloss


FSPL_1(d) = 20*log10(4*pi*d*f/c);


%% CI Pathloss model
Gr=1;
Gt=1;
c=3e8;
f=73e9;
lamda=c/f;



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

distance=1:length(ABGPL);
ABGPL = nonzeros(ABGPL);
PLCI_noise=nonzeros(PLCI_noise);
% FSPL=nonzeros(FSPL);

plot(distance,ABGPL);
hold on;
plot(distance,PLCI_noise);
hold on;
plot(distance,FSPL_1);
grid on;
xlabel('Distance(m)');
ylabel('PL(dB)')
title('PL vs Distance for Different Models')
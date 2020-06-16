
d=1:400;

f=73e9;

L=0.2*(f^0.3)*(d.^0.6);  %ITU-R model 
plot(d,10*log(L));
hold on

for ii=1:length(d)
if d(ii)<14 
   L2(ii)=0.45*f^0.284 .*d(ii) ;
elseif d(ii)>=14   
    L2(ii)=1.33*(f^0.284)*(d(ii).^0.588); %modified exponential decay model 
end
end
    plot(d,10*log(L2));
    hold on

L3 = 15.6*(f^-0.009)*(d.^0.26);%Cost 235 model 
plot(d,10*log(L3))
hold on

L4=0.39*(f^0.39)*d.^0.25; % FITU-R model 
plot(d,10*log(L4))
grid on 
hold on

xlabel('frequency in Hertz');
ylabel('Loss due to foliage in dB')
title('Foliage loss vs frequency for different models')
legend('ITU__R model','Modified exponential decay model','Cost 235 model','FITR model','location','east')


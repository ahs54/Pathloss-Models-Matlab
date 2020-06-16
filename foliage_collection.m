
d = 1:400;

f = 73e9;

L = 0.2*(f^0.3)*(d.^0.6);  %ITU-R model between 200 MHz and 95 GHz and d < 400 m
plot(d,10*log(L),'LineWidth',2);% in the eqn the frequency should be in MHz
hold on

for ii=1:length(d)
if d(ii)<14 
   L2(ii) = 0.45*f^0.284 .*d(ii) ;% f should be in GHz
elseif d(ii)>=14   
    L2(ii) = 1.33*(f^0.284)*(d(ii).^0.588);%Weissberger’s modified exponential decay model between 230 MHz and 95 GHz 
end
end
    plot(d,10*log(L2),'LineWidth',2);
    hold on
for ii=1:length(d)
 
if d(ii)<200
    L3(ii) = 15.6*(f^-0.009)*(d(ii).^0.26);%Cost 235 model between 9.6 and 57 GHz and d < 200 m
    else
    L3(ii) = 0;
end


end
  

plot(d,10*log(L3),'LineWidth',2)% in the eqn the frequency should be in MHz
hold on

L4=0.39*(f^0.39)*d.^0.25; % FITU-R model between 11.2 and 20 GHz
plot(d,10*log(L4),'LineWidth',2)
grid on 
hold on

xlabel('Distance in m');
ylabel('Loss in dB')
title('Different Foliage Losses')
axis([0 400 0 150])
legend('ITU__R model','Foliage exponential decay model','Foliage Cost 235 model','Foliage FITR model','location','north')

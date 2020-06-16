

%Simulation for SINR coverage in mmWave cellular network
%Use exponential decay LOS probability function
% 
clear all;
fc=28*10^9;%Carrier frequency
wavelength=3*10^8./fc;
Nak=3;
d0=1;%reference distance

PLA=20*log(4*pi*d0./wavelength)/log(10);%path loss intercept in dB for reference distance


rc=300;%avg cell radius

lambda=1/pi/rc^2;% base station density
Rt=200;%average LOS distance
beta=sqrt(2)/Rt;% LOS probabiluty function is 


N=100;
R=sqrt(N/pi/lambda);
L=10000;% number of iterations

BW=100*10^6;
Noise=1.38*10^-23*290*BW;

C=1/10^(PLA/10);
Gap=1;% use if LOS and NLOS path loss exponent are different

Pt=1;%TX power at BS in Watt
sinr=zeros(1,L);
interf=sinr;


D=pi/6;% BS beamforming beamwidth
FBR=10^(-2);
M=100;% BS main lobe gain
m=M*FBR;% BS side loba gain


D1=pi/2;% MS beamforming beamwidth
FBR1=0.01;
M1=10;%MS main lobe gain
m1=M1*FBR1;%MS side lobe gain

Nakagami=3; %fading parameter

parfor i=1:L
 
flag=0; 
signal=0;

number=poissrnd(lambda*pi*(R^2));
temp=zeros(1,number);
distance=sqrt(unifrnd(0,R^2,[1,number]));
distance=sort(distance);
theta=unifrnd(0,2*pi,[1,number]);
theta1=unifrnd(0,2*pi,[1,number]);

los=exp(-beta.*distance)-unifrnd(0,1,[1,number]);
los=(sign(los)+1)/2;
fade=gamrnd(Nakagami,1/Nakagami,[1,number]);
for k=1:number
if los(k)>0
    temp(k)=C/distance(k)^2*Pt;
else
    temp(k)=C/Gap/distance(k)^4*Pt;
end
end

[signal,flag]=max(temp);
signal=signal*M*M1*fade(flag);

for k=1:number

    if theta(k)<D
        temp(k)=temp(k)*M*fade(k);
    else
        temp(k)=temp(k)*m*fade(k);
    end

end
for k=1:number
 if theta1(k)<D
        temp(k)=temp(k)*M1;
 else
        temp(k)=temp(k)*m1;
 end

end
interf(i)=sum(temp)-temp(flag);
sinr(i)=signal/(interf(i)+Noise);


end

SNR=-10:40;
count=SNR*0;
T=10.^(SNR/10);
for i=1:L
    for k=1:51
        if sinr(i)>T(k)
            count(k)=count(k)+1;
        end
    end
end
hold on;
%%
plot(SNR,(count/L),'r');
xlabel('SNR(dB)')
ylabel('BER')
grid on;
%compute average rate, threshold by 6 pbs/Hz per stream
rate=1/L*(sum(min(log2(1+sinr),6)));
%% Magda without light with light

video = VideoReader('data\Magdaz1.mp4');

N=video.NumberOfFrames;
W=video.Height;
H=video.Width;
wektor(N)=zeros;

for idx=1:N
frame = read(video, idx);
a=1;
b=2;
c=3;
planeR = frame(:, :, a);
planeG = frame(:, :, b);
planeB = frame(:, :, c);
l = 0.3*planeR + 0.59*planeG + 0.11*planeB;
bn=(1/(W*H))*sum(sum(l));
wektor(idx)=bn;
end

Fs=N/video.Duration;
f1=40/60;
f2=150/60;

%calculate a normalized cutoff frequency Wn (based on Fs-Nyquist theorem)
WnECG=[f1 f2]*2/Fs; % -  Nyquist fn=fs/2

% check an order of Butterwoth filter: ex. https://www.electronics-tutorials.ws/filter/filter_8.html
n= 3; 

%bandpass filtering
[a,b]=butter(n,WnECG);
W=filtfilt(a,b,wektor(50:end));
t=(0:length(W)-1)./Fs;
%Finding peaks
[pks,locs]=findpeaks(W,'MinPeakDistance',20);
locs=(locs-1)./Fs;

figure(1)
hold on
plot(t,W);
title('Without filter')
xlabel('time[s]');
ylabel('Amplitude[V]');
scatter(locs,pks,'o');
hold off;

figure(2)
plot(wektor)
title('Without filter');
xlabel('number og sample');
ylabel('V');
RR_intervals=diff(locs); 
RR_intervals=RR_intervals';


load('SS.txt')
%remove unnecessary data
SS(1:4:end)=[];
SS(1:3:end)=[];
Fs=2;

t=(0:length(SS)-1)./Fs;

[pks,locs]=findpeaks(SS,'MinPeakDistance',1.5);%,'MinPeakHeight',900
locs=(locs-1)./2;
figure(3)
hold on
plot(t,SS);
title('Watch')
xlabel('czas [s]');
scatter(locs,pks,'o');
ylabel('Amplitude[mV]');

hold off;
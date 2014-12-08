close all;
sr = 41000;

[d,SR] = wavread('H:\WaveMusic\Beyond 光辉岁月.wav',[sr+1 sr*15]);
% Start with the basic (linear-freq) spectrogram matxix
targetSR = 8000;
if (SR ~= targetSR)
  d = resample(d,targetSR,SR);
end

fft_ms = 64;
fft_hop = 32;
nfft = round(targetSR/1000*fft_ms);
S = abs(specgram(d,nfft,targetSR,nfft,nfft-round(targetSR/1000*fft_hop)));
% 转化为对数形式
Smax = max(S(:));
S = log(max(Smax/1e6,S));
% 将频谱幅度转化为0均值，以便高通滤波
S = S - mean(S(:));
% Design the mapping matrix to lose no bins at the top but 5 at the bottom
[M,N] = logfmap(257,6,257);
% Our 257 bin FFT expands to 1006 log-F bins
% Perform the mapping:
MS = M*S;

% 对幅度谱应用高通滤波，消除平缓波动，强化突然跳动
S = (filter([1 -1],[1 -0.98],S')');
subplot(311)
imagesc(S); axis xy
c = caxis;


MS = (filter([1 -1],[1 -0.98],MS')');
subplot(312)
imagesc(MS); axis xy
caxis(c);

% Map back to the original axis space, just to check that we can
NMS = N*MS;
subplot(313)
imagesc(NMS); axis xy
caxis(c)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2);
[d,SR] = wavread('H:\RecordMusic\Beyond 光辉岁月.wav',[sr+1 sr*15]);
% Start with the basic (linear-freq) spectrogram matxix
targetSR = 8000;
if (SR ~= targetSR)
  d = resample(d,targetSR,SR);
end
fft_ms = 64;
fft_hop = 32;
nfft = round(targetSR/1000*fft_ms);
S = abs(specgram(d,nfft,targetSR,nfft,nfft-round(targetSR/1000*fft_hop)));
% 转化为对数形式
Smax = max(S(:));
S = log(max(Smax/1e6,S));
% 将频谱幅度转化为0均值，以便高通滤波
S = S - mean(S(:));
% Design the mapping matrix to lose no bins at the top but 5 at the bottom
[M,N] = logfmap(257,6,257);
% Our 257 bin FFT expands to 1006 log-F bins
% Perform the mapping:
MS = M*S;

% 对幅度谱应用高通滤波，消除平缓波动，强化突然跳动
S = (filter([1 -1],[1 -0.98],S')');
subplot(311)
imagesc(S); axis xy
c = caxis;


MS = (filter([1 -1],[1 -0.98],MS')');
subplot(312)
imagesc(MS); axis xy
caxis(c);
% Map back to the original axis space, just to check that we can
NMS = N*MS;
subplot(313)
imagesc(NMS); axis xy
caxis(c)
close all;
sr = 41000;

[d,SR] = wavread('H:\WaveMusic\Beyond �������.wav',[sr+1 sr*15]);
% Start with the basic (linear-freq) spectrogram matxix
targetSR = 8000;
if (SR ~= targetSR)
  d = resample(d,targetSR,SR);
end

fft_ms = 64;
fft_hop = 32;
nfft = round(targetSR/1000*fft_ms);
S = abs(specgram(d,nfft,targetSR,nfft,nfft-round(targetSR/1000*fft_hop)));
% ת��Ϊ������ʽ
Smax = max(S(:));
S = log(max(Smax/1e6,S));
% ��Ƶ�׷���ת��Ϊ0��ֵ���Ա��ͨ�˲�
S = S - mean(S(:));
% Design the mapping matrix to lose no bins at the top but 5 at the bottom
[M,N] = logfmap(257,6,257);
% Our 257 bin FFT expands to 1006 log-F bins
% Perform the mapping:
MS = M*S;

% �Է�����Ӧ�ø�ͨ�˲�������ƽ��������ǿ��ͻȻ����
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
[d,SR] = wavread('H:\RecordMusic\Beyond �������.wav',[sr+1 sr*15]);
% Start with the basic (linear-freq) spectrogram matxix
targetSR = 8000;
if (SR ~= targetSR)
  d = resample(d,targetSR,SR);
end
fft_ms = 64;
fft_hop = 32;
nfft = round(targetSR/1000*fft_ms);
S = abs(specgram(d,nfft,targetSR,nfft,nfft-round(targetSR/1000*fft_hop)));
% ת��Ϊ������ʽ
Smax = max(S(:));
S = log(max(Smax/1e6,S));
% ��Ƶ�׷���ת��Ϊ0��ֵ���Ա��ͨ�˲�
S = S - mean(S(:));
% Design the mapping matrix to lose no bins at the top but 5 at the bottom
[M,N] = logfmap(257,6,257);
% Our 257 bin FFT expands to 1006 log-F bins
% Perform the mapping:
MS = M*S;

% �Է�����Ӧ�ø�ͨ�˲�������ƽ��������ǿ��ͻȻ����
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
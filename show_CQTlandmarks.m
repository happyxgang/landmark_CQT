function show_CQTlandmarks(D,SR,L,T,C)
% show_landmarks(D,SR,L[,T,C])
%    对音频D的频谱图标记显著点



if nargin < 4
  T = [];
end
if nargin < 5
  C = 'o-r';
end
%L = find_CQTlandmarks(D,SR);
targetSR = 8000;

fft_ms = 64;
nfft = round(targetSR/1000*fft_ms);


win_overlap = 2;

my_win_overlap = 4;

fbase = targetSR/nfft;
tbase = fft_ms/win_overlap/1000;
my_tbase = fft_ms/my_win_overlap/1000;

if (size(D,1)<3) || (size(D,2)<3)

   if length(D) > 0

   %%%%%%%%此部分与find_landmarks中相同

     if size(D,1) > size(D,2)
       D = D';
     end
     if size(D,1) == 2;
       D = mean(D);
     end
     
     if (SR ~= targetSR)
       srgcd = gcd(SR, targetSR);
       D = resample(D,targetSR/srgcd,SR/srgcd);
     end

     S = abs(specgram(D,nfft,targetSR,nfft,nfft-nfft/my_win_overlap));
  
% % 转化为对数形式
% Smax = max(S(:));
% S = log(max(Smax/1e6,S));
% % 将频谱幅度转化为0均值，以便高通滤波
% S = S - mean(S(:));
% 生成映射矩阵
% [M,N] = logfmap(257,6,129);
[M,N] = logfmap(257,6,65);
% 将257 FFT bins 扩展为 162 log-F bins
% 进行映射
MS = M*S;

S = MS;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   end

else
  S = D;
end

if length(D) > 0
   
  [nr,nc] = size(S);
  tt = [1:nc]*my_tbase;
  fbase = 1;
  ff = [0:nr-1]*fbase;

  imagesc(tt,ff,20*log10(abs(S)));
  axis xy
  ca = caxis;
  caxis([-80 0]+ca(2));

end
  
hold on

for i = 1:size(L,1);
  lrow = L(i,:);
  t1q = lrow(1);
  f1q = lrow(2);
  f2q = lrow(3);
  dtq = lrow(4);
  t2q = t1q+dtq;
  t1 = t1q*tbase;
  t2 = t2q*tbase;
  f1 = f1q*fbase;
  f2 = f2q*fbase;
  plot([t1 t2],[f1 f2],C);
end

hold off

if length(T) == 2
  a = axis;
  axis([T(1) T(2) a(3) a(4)]);
end

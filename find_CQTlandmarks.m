function [L,S,T,maxes] = find_CQTlandmarks(D,SR,N,bp)
% [L,S,T,maxes] = find_CQTlandmarks(D,SR,N)
%   对音频波形D提取出频谱的显著点集合L
%   输入：
%   D 音频波形； SR 采样率； N 哈希密度（默认每秒生成5个）
%   返回值：
%   L 显著点的集合, 每点包含4列{起始时间 起始频率 结束频率 时间差}
%   S 短时傅里叶谱的幅度
%   T 各局部的峰值提取阈值
%   maxes 所提取峰值点的时频位置


if nargin < 4;  N = 7; bp = 1; end %默认为 7 得到掩盖因子 a_dec = 0.998

% 本算法依赖于查询音频与音频库中音频具有一定数量的相同显著点。
% 显著点密度越大，越容易找到匹配（意味更短长度和音质更差的仍可匹配），
% 但是指纹库的规模将增大
%
% 影响所提取显著点个数的因素：
%  A.  找出局部最大点的个数，其取决于

f_sd=20;

a_dec=0.995;

%    A.3 每帧允许的最大的峰值点个数
maxpksperframe = 30;

%    A.4 高通滤波器参数，接近1意味只滤除缓慢变化部分
hpf_pole = 0.98;

%  B. 每个显著点形成的点对数量. 频谱图上目标区域的大小
% 设定频率方向的大小
targetdf = 31;  

% 设定时间方向的大小
targetdt = 63; 

verbose = 0;

% 预设保留最大点的数量
maxespersec = 20;


% 将音频 D 转化为单声道
[nr,nc] = size(D);
if nr > nc
  D = D';
  [nr,nc] = size(D);
end
if nr > 1
  D = mean(D);
  nr = 1;
end

% 将音频D重采样为8000Hz
targetSR = 8000;
if (SR ~= targetSR)
  D = resample(D,targetSR,SR);
end

% 获取频谱特征
% 短时傅里叶变换利用64 ms窗口(512点的 FFT) 
fft_ms = 64;
fft_hop = 32;
nfft = round(targetSR/1000*fft_ms);
S = abs(specgram(D,nfft,targetSR,nfft,nfft-round(targetSR/1000*fft_hop)));
% % 转化为对数形式
 Smax = max(S(:));
 %S = 10*log(max(Smax/1e6,S));
% % 将频谱幅度转化为0均值，以便高通滤波
 %S = S - mean(S(:));

% 生成映射矩阵
% [M,N] = logfmap(257,6,129);
[M,N] = logfmap(257,6,65);
% 65 对应 162 log-F bins
% 129 对应 413 log-F bins
% 257 对应 1006 log-F bins
% 将257 FFT bins 扩展为 162 log-F bins
% 进行映射
MS = M*S;

S = MS;

% % 转化为对数形式
 Smax = max(S(:));
 
 S = 10*log(max(Smax/1e6,S));
% % 将频谱幅度转化为0均值，以便高通滤波
 S = S - mean(S(:));
% 对幅度谱应用高通滤波，消除平缓波动，强化突然跳动
 %S = (filter([1 -1],[1 -hpf_pole],S')');



ddur = length(D)/targetSR;
nmaxkeep = round(maxespersec * ddur);
maxes = zeros(3,nmaxkeep);
nmaxes = 0;
maxix = 0;

%%%%% 
%% 提取所有的局部显著点，保存为 maxes(i,:) = [t,f];


T = 0*S;

% 每个dB x dT 大小的矩阵内提取出一个最强点
% 若该点大于邻域均值的Th倍，则保留
dB = 12;
dT = 32;
Th = 5;

% B = zeros(dB, dT);
% shiftB = zeros(dB, dT);
% Rect = zeros(size(S));
% indB = 1;
% indT = 1;
% for ii= 1:floor(size(S,2)/dT)-1
%     for jj = 1:floor(size(S,1)/dB)-1
%         % 得到dB x dT 大小的矩阵
%         B = S((jj*dB-dB+1):jj*dB,(ii*dT-dT+1):ii*dT);
%         % 得到平移后dB x dT 大小的矩阵
%         shiftB = S((jj*dB-dB/2+1):jj*dB+dB/2,(ii*dT-dT/2+1):ii*dT+dT/2);
%         
%         % 矩阵内提取出一个最强点
%         [indB, indT] = find(B==max(max(B)));
%         %若该点大于邻域均值的Th倍，则保留
%         if(B(indB(1),indT(1))> Th*mean(mean(B)) && B(indB(1),indT(1))> Th*mean(mean(shiftB)))
%             Rect(jj*dB-dB+indB(1),ii*dT-dT+indT(1)) = B(indB(1),indT(1));
% 
%             % 记录最强点的位置
%             nmaxes = nmaxes + 1;
%             maxes(2,nmaxes) = jj*dB-dB+indB(1);
%             maxes(1,nmaxes) = ii*dT-dT+indT(1);
%             maxes(3,nmaxes) = B(indB(1),indT(1));
%         end
%         
%     end
% end

% Estimate for how many maxes we keep - < 30/sec (to preallocate array)
% maxespersec = 100;
% 
% ddur = length(D)/targetSR;
% nmaxkeep = round(maxespersec * ddur);
% maxes = zeros(3,nmaxkeep);
% nmaxes = 0;
% maxix = 0;

%%%%% 
%% find all the local prominent peaks, store as maxes(i,:) = [t,f];

%% overmasking factor?  Currently none.
s_sup = 1.0;

% initial threshold envelope based on peaks in first 10 frames
sthresh = s_sup*spread(max(S(:,1:10),[],2),f_sd)';

% T stores the actual decaying threshold, for debugging
T = 0*S;

for i = 1:size(S,2)-1
  s_this = S(:,i);
  sdiff = max(0,(s_this - sthresh))';
  % find local maxima
  sdiff = locmax(sdiff);
  % (make sure last bin is never a local max since its index
  % doesn't fit in 8 bits)
  sdiff(end) = 0;  % i.e. bin 257 from the sgram
  % take up to 5 largest
  [vv,xx] = sort(sdiff, 'descend');
  % (keep only nonzero)
  xx = xx(vv>0);
  % store those peaks and update the decay envelope
  nmaxthistime = 0;
  for j = 1:length(xx)
    p = xx(j);
    if nmaxthistime < maxpksperframe
      % Check to see if this peak is under our updated threshold
      if s_this(p) > sthresh(p)
        nmaxthistime = nmaxthistime + 1;
        nmaxes = nmaxes + 1;
        maxes(2,nmaxes) = p;
        maxes(1,nmaxes) = i;
        maxes(3,nmaxes) = s_this(p);
        eww = exp(-0.5*(([1:length(sthresh)]'- p)/f_sd).^2);
        sthresh = max(sthresh, s_this(p)*s_sup*eww);
      end
    end
  end
  T(:,i) = sthresh;
  sthresh = a_dec*sthresh;
end

% Backwards pruning of maxes
maxes2 = [];
nmaxes2 = 0;
if bp > 0
whichmax = nmaxes;
sthresh = s_sup*spread(S(:,end),f_sd)';
for i = (size(S,2)-1):-1:1
  while whichmax > 0 && maxes(1,whichmax) == i
    p = maxes(2,whichmax);
    v = maxes(3,whichmax);
    if  v >= sthresh(p)
      % keep this one
      nmaxes2 = nmaxes2 + 1;
      maxes2(:,nmaxes2) = [i;p];
      eww = exp(-0.5*(([1:length(sthresh)]'- p)/f_sd).^2);
      sthresh = max(sthresh, v*s_sup*eww);
    end
    whichmax = whichmax - 1;
  end
  sthresh = a_dec*sthresh;
end

maxes2 = fliplr(maxes2);
else
 maxes2 = maxes;
 nmaxes2 =nmaxes;
%T = Rect;
end
%% 整理峰值点形成显著点对，以作为音频哈希
  
% 设定每个点最大允许点对数目
maxpairsperpeak=3;

% 显著点对 <starttime F1 endtime F2>
L = zeros(nmaxes2*maxpairsperpeak,4);

nlmarks = 0;

for i =1:nmaxes2
  startt = maxes2(1,i);
  F1 = maxes2(2,i);
  maxt = startt + targetdt;
  minf = F1 - targetdf;
  maxf = F1 + targetdf;
  matchmaxs = find((maxes2(1,:)>startt)&(maxes2(1,:)<maxt)&(maxes2(2,:)>minf)&(maxes2(2,:)<maxf));
  if length(matchmaxs) > maxpairsperpeak
    % 若超过最大允许点对数目，只保留前面点对
    matchmaxs = matchmaxs(1:maxpairsperpeak);
  end
  for match = matchmaxs
    nlmarks = nlmarks+1;
    L(nlmarks,1) = startt;
    L(nlmarks,2) = F1;
    L(nlmarks,3) = maxes2(2,match);  % 结束频率
    L(nlmarks,4) = maxes2(1,match)-startt;  % 时间差分
  end
end

L = L(1:nlmarks,:);

if verbose
  disp(['find_landmarks: ',num2str(length(D)/targetSR),' secs, ',...
      num2str(size(S,2)),' cols, ', ...
      num2str(nmaxes),' maxes, ', ...
      num2str(nmaxes2),' bwd-pruned maxes, ', ...
      num2str(nlmarks),' lmarks']);
end
  

maxes = maxes2;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Y = locmax(X)
%  Y contains only the points in (vector) X which are local maxima

% Make X a row
X = X(:)';
nbr = [X,X(end)] >= [X(1),X];
% >= makes sure final bin is always zero
Y = X .* nbr(1:end-1) .* (1-nbr(2:end));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Y = spread(X,E)
%  Each point (maxima) in X is "spread" (convolved) with the
%  profile E; Y is the pointwise max of all of these.
%  If E is a scalar, it's the SD of a gaussian used as the
%  spreading function (default 4).
% 2009-03-15 Dan Ellis dpwe@ee.columbia.edu

if nargin < 2; E = 4; end
  
if length(E) == 1
  W = 4*E;
  E = exp(-0.5*[(-W:W)/E].^2);
end

X = locmax(X);
Y = 0*X;
lenx = length(X);
maxi = length(X) + length(E);
spos = 1+round((length(E)-1)/2);
for i = find(X>0)
  EE = [zeros(1,i),E];
  EE(maxi) = 0;
  EE = EE(spos+(1:lenx));
  Y = max(Y,X(i)*EE);
end



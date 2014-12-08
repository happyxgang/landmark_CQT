function [L,S,T,maxes] = find_landmarks_ga(D,SR,N)
% [L,S,T,maxes] = find_landmarks(D,SR,N)
%   对音频波形D提取出频谱的显著点集合L
%   输入：
%   D 音频波形； SR 采样率； N 哈希密度（默认每秒生成5个）
%   返回值：
%   L 显著点的集合, 每点包含4列{起始时间 起始频率 结束频率 时间差}
%   S 短时傅里叶谱的幅度
%   T 各局部的峰值提取阈值
%   maxes 所提取峰值点的时频位置


if nargin < 3;  N = 7;  end %默认为 7 得到掩盖因子 a_dec = 0.998

% 本算法依赖于查询音频与音频库中音频具有一定数量的相同显著点。
% 显著点密度越大，越容易找到匹配（意味更短长度和音质更差的仍可匹配），
% 但是指纹库的规模将增大
%
% 影响所提取显著点个数的因素：
%  A.  找出局部最大点的个数，其取决于
%    A.1 扩散函数的宽度，当提取出一个显著点时用于抑制相邻点，即令若干相邻点幅度衰落
f_sd = 30;

%    A.2 掩盖因子a_dec，当提取出一个显著点时用于抑制相邻点，即令相邻点幅度衰落的程度
% a_dec = 0.998;
a_dec = 1-0.01*(N/35);
% 0.999 -> 2.5
% 0.998 -> 5 hash/sec
% 0.997 -> 10 hash/sec
% 0.996 -> 14 hash/sec
% 0.995 -> 18
% 0.994 -> 22
% 0.993 -> 27
% 0.992 -> 30
% 0.991 -> 33
% 0.990 -> 37
% 0.98  -> 67
% 0.97  -> 97

%    A.3 每帧允许的最大的峰值点个数
maxpksperframe = 5;

%    A.4 高通滤波器参数，接近1意味只滤除缓慢变化部分
hpf_pole = 0.98;

%  B. 每个显著点形成的点对数量. 频谱图上目标区域的大小
% 设定频率方向的大小
targetdf = 31;  

% 设定时间方向的大小
targetdt = 63; 


verbose = 0;

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
%S = abs(specgram(D,nfft,targetSR,nfft,nfft-round(targetSR/1000*fft_hop)));

[S,F] = gammatonegram(D,targetSR);
S = abs(S);

% 转化为对数形式
Smax = max(S(:));
S = log(max(Smax/1e6,S));
% 将频谱幅度转化为0均值，以便高通滤波
S = S - mean(S(:));
% 对幅度谱应用高通滤波，消除平缓波动，强化突然跳动
S = (filter([1 -1],[1 -hpf_pole],S')');


% 预设保留最大点的数量
maxespersec = 30;

ddur = length(D)/targetSR;
nmaxkeep = round(maxespersec * ddur);
maxes = zeros(3,nmaxkeep);
nmaxes = 0;
maxix = 0;

%%%%% 
%% 提取所有的局部显著点，保存为 maxes(i,:) = [t,f];

s_sup = 1.0;

% 利用前10帧初始化峰值提取所使用的阈值
sthresh = s_sup*spread(max(S(:,1:min(10,size(S,2))),[],2),f_sd)';

T = 0*S;

for i = 1:size(S,2)-1
  s_this = S(:,i);
  sdiff = max(0,(s_this - sthresh))';
  % 找出所有局部最大点
  sdiff = locmax(sdiff);
 
  sdiff(end) = 0;  
 
  [vv,xx] = sort(sdiff, 'descend');
  
  xx = xx(vv>0);

  nmaxthistime = 0;
  for j = 1:length(xx)
    p = xx(j);
    if nmaxthistime < maxpksperframe
      % 大于阈值，保留该峰值点，且更新阈值
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

% 重新从后面后向提取峰值点，只保留下前后向均能提取的峰值点
maxes2 = [];
nmaxes2 = 0;
whichmax = nmaxes;
sthresh = s_sup*spread(S(:,end),f_sd)';
for i = (size(S,2)-1):-1:1
  while whichmax > 0 && maxes(1,whichmax) == i
    p = maxes(2,whichmax);
    v = maxes(3,whichmax);
    if  v >= sthresh(p)
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
%  提取 X 中的所有局部最大值

X = X(:)';
nbr = [X,X(end)] >= [X(1),X];
% 通过差分点乘保留局部最大值，其他位置为0
Y = X .* nbr(1:end-1) .* (1-nbr(2:end));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Y = spread(X,E)
%  对X应用窗函数E加窗

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



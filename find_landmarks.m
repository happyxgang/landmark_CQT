function [L,S,T,maxes] = find_landmarks(D,SR,N)
% [L,S,T,maxes] = find_landmarks(D,SR,N)
%   ����Ƶ����D��ȡ��Ƶ�׵������㼯��L
%   ���룺
%   D ��Ƶ���Σ� SR �����ʣ� N ��ϣ�ܶȣ�Ĭ��ÿ������5����
%   ����ֵ��
%   L ������ļ���, ÿ�����4��{��ʼʱ�� ��ʼƵ�� ����Ƶ�� ʱ���}
%   S ��ʱ����Ҷ�׵ķ���
%   T ���ֲ��ķ�ֵ��ȡ��ֵ
%   maxes ����ȡ��ֵ���ʱƵλ��


if nargin < 3;  N = 7;  end %Ĭ��Ϊ 7 �õ��ڸ����� a_dec = 0.998

% ���㷨�����ڲ�ѯ��Ƶ����Ƶ������Ƶ����һ����������ͬ�����㡣
% �������ܶ�Խ��Խ�����ҵ�ƥ�䣨��ζ���̳��Ⱥ����ʸ�����Կ�ƥ�䣩��
% ����ָ�ƿ�Ĺ�ģ������
%
% Ӱ������ȡ��������������أ�
%  A.  �ҳ��ֲ�����ĸ�������ȡ����
%    A.1 ��ɢ�����Ŀ�ȣ�����ȡ��һ��������ʱ�����������ڵ㣬�����������ڵ����˥��
f_sd = 30;

%    A.2 �ڸ�����a_dec������ȡ��һ��������ʱ�����������ڵ㣬�������ڵ����˥��ĳ̶�
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

%    A.3 ÿ֡��������ķ�ֵ�����
maxpksperframe = 5;

%    A.4 ��ͨ�˲����������ӽ�1��ζֻ�˳������仯����
hpf_pole = 0.98;

%  B. ÿ���������γɵĵ������. Ƶ��ͼ��Ŀ������Ĵ�С
% �趨Ƶ�ʷ���Ĵ�С
targetdf = 31;  

% �趨ʱ�䷽��Ĵ�С
targetdt = 63; 


verbose = 0;

% ����Ƶ D ת��Ϊ������
[nr,nc] = size(D);
if nr > nc
  D = D';
  [nr,nc] = size(D);
end
if nr > 1
  D = mean(D);
  nr = 1;
end

% ����ƵD�ز���Ϊ8000Hz
targetSR = 8000;
if (SR ~= targetSR)
  D = resample(D,targetSR,SR);
end

% ��ȡƵ������
% ��ʱ����Ҷ�任����64 ms����(512��� FFT) 
fft_ms = 64;
fft_hop = 32;
nfft = round(targetSR/1000*fft_ms);
%S = abs(specgram(D,nfft,targetSR,nfft,nfft-round(targetSR/1000*fft_hop)));

[S,F] = gammatonegram(D,targetSR);
S = abs(S);

% ת��Ϊ������ʽ
Smax = max(S(:));
S = log(max(Smax/1e6,S));
% ��Ƶ�׷���ת��Ϊ0��ֵ���Ա��ͨ�˲�
S = S - mean(S(:));
% �Է�����Ӧ�ø�ͨ�˲�������ƽ��������ǿ��ͻȻ����
S = (filter([1 -1],[1 -hpf_pole],S')');


% Ԥ�豣�����������
maxespersec = 30;

ddur = length(D)/targetSR;
nmaxkeep = round(maxespersec * ddur);
maxes = zeros(3,nmaxkeep);
nmaxes = 0;
maxix = 0;

%%%%% 
%% ��ȡ���еľֲ������㣬����Ϊ maxes(i,:) = [t,f];

s_sup = 1.0;

% ����ǰ10֡��ʼ����ֵ��ȡ��ʹ�õ���ֵ
sthresh = s_sup*spread(max(S(:,1:min(10,size(S,2))),[],2),f_sd)';

T = 0*S;

for i = 1:size(S,2)-1
  s_this = S(:,i);
  sdiff = max(0,(s_this - sthresh))';
  % �ҳ����оֲ�����
  sdiff = locmax(sdiff);
 
  sdiff(end) = 0;  
 
  [vv,xx] = sort(sdiff, 'descend');
  
  xx = xx(vv>0);

  nmaxthistime = 0;
  for j = 1:length(xx)
    p = xx(j);
    if nmaxthistime < maxpksperframe
      % ������ֵ�������÷�ֵ�㣬�Ҹ�����ֵ
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

% ���´Ӻ��������ȡ��ֵ�㣬ֻ������ǰ���������ȡ�ķ�ֵ��
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

%% �����ֵ���γ�������ԣ�����Ϊ��Ƶ��ϣ
  
% �趨ÿ���������������Ŀ
maxpairsperpeak=3;

% ������� <starttime F1 endtime F2>
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
    % �����������������Ŀ��ֻ����ǰ����
    matchmaxs = matchmaxs(1:maxpairsperpeak);
  end
  for match = matchmaxs
    nlmarks = nlmarks+1;
    L(nlmarks,1) = startt;
    L(nlmarks,2) = F1;
    L(nlmarks,3) = maxes2(2,match);  % ����Ƶ��
    L(nlmarks,4) = maxes2(1,match)-startt;  % ʱ����
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
%  ��ȡ X �е����оֲ����ֵ

X = X(:)';
nbr = [X,X(end)] >= [X(1),X];
% ͨ����ֵ�˱����ֲ����ֵ������λ��Ϊ0
Y = X .* nbr(1:end-1) .* (1-nbr(2:end));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Y = spread(X,E)
%  ��XӦ�ô�����E�Ӵ�

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



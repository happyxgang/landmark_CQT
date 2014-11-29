function [L,S,T,maxes] = find_CQTlandmarks(D,SR,N)
% [L,S,T,maxes] = find_CQTlandmarks(D,SR,N)
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

%    A.3 ÿ֡��������ķ�ֵ�����
maxpksperframe = 10;

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
S = abs(specgram(D,nfft,targetSR,nfft,nfft-round(targetSR/1000*fft_hop)));
% % ת��Ϊ������ʽ
% Smax = max(S(:));
% S = log(max(Smax/1e6,S));
% % ��Ƶ�׷���ת��Ϊ0��ֵ���Ա��ͨ�˲�
% S = S - mean(S(:));

% ����ӳ�����
% [M,N] = logfmap(257,6,129);
[M,N] = logfmap(257,6,65);
% 65 ��Ӧ 162 log-F bins
% 129 ��Ӧ 413 log-F bins
% 257 ��Ӧ 1006 log-F bins
% ��257 FFT bins ��չΪ 162 log-F bins
% ����ӳ��
MS = M*S;

S = MS;
% �Է�����Ӧ�ø�ͨ�˲�������ƽ��������ǿ��ͻȻ����
%S = (filter([1 -1],[1 -hpf_pole],S')');



% Ԥ�豣�����������
maxespersec = 20;

ddur = length(D)/targetSR;
nmaxkeep = round(maxespersec * ddur);
maxes = zeros(3,nmaxkeep);
nmaxes = 0;
maxix = 0;

%%%%% 
%% ��ȡ���еľֲ������㣬����Ϊ maxes(i,:) = [t,f];


T = 0*S;

% ÿ��dB x dT ��С�ľ�������ȡ��һ����ǿ��
% ���õ���������ֵ��Th��������
dB = 12;
dT = 32;
Th = 5;

B = zeros(dB, dT);
shiftB = zeros(dB, dT);
Rect = zeros(size(S));
indB = 1;
indT = 1;
for ii= 1:floor(size(S,2)/dT)-1
    for jj = 1:floor(size(S,1)/dB)-1
        % �õ�dB x dT ��С�ľ���
        B = S((jj*dB-dB+1):jj*dB,(ii*dT-dT+1):ii*dT);
        % �õ�ƽ�ƺ�dB x dT ��С�ľ���
        shiftB = S((jj*dB-dB/2+1):jj*dB+dB/2,(ii*dT-dT/2+1):ii*dT+dT/2);
        
        % ��������ȡ��һ����ǿ��
        [indB, indT] = find(B==max(max(B)));
        %���õ���������ֵ��Th��������
        if(B(indB(1),indT(1))> Th*mean(mean(B)) && B(indB(1),indT(1))> Th*mean(mean(shiftB)))
            Rect(jj*dB-dB+indB(1),ii*dT-dT+indT(1)) = B(indB(1),indT(1));

            % ��¼��ǿ���λ��
            nmaxes = nmaxes + 1;
            maxes(2,nmaxes) = jj*dB-dB+indB(1);
            maxes(1,nmaxes) = ii*dT-dT+indT(1);
            maxes(3,nmaxes) = B(indB(1),indT(1));
        end
        
    end
end




maxes2 = maxes;
nmaxes2 =nmaxes;
T = Rect;

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

function [N,T] = add_tracks(D,SR,ID)
% [N,T] = add_tracks(D,SR,ID)
%    ��Ӹ�����D��ָ�����ݿ�
%    ���룺
%    <D, SR> ��ʾ���������Ƶ����, DΪ�ַ������飬 ID ��Ӧ������š�ע��SR��ID������ʱ��ʹ��Ĭ��˳����
%    ����ֵ��
%    N ��ӵ��ܹ�ϣ����, T �����Ƶ����ʱ��
%
%================================
%ָ����Ƶ�������Ŀ¼��ע����\����
PA = 'i:\mayday\';

% Ԥ���ù�ϣ�ܶȣ�ÿ�����������ϣ��
dens = 10;


if isnumeric(D)
  % ��ȡ��ƵƬ��D�������㣬������ת��Ϊ��ϣֵH
  H = landmark2hash(find_CQTlandmarks(D,SR,dens),ID);
  % ����ϣֵH���浽ָ�ƿ�
  record_hashes(H);
  N = length(H);
  T = length(D)/SR;
elseif ischar(D)
  if nargin < 3
    ID = SR;
  end
  % ������Ƶ����
  [D,SR] = wavread([PA D]);
  [N,T] = add_tracks(D,SR,ID);
elseif iscell(D)
  
  disp(['Target density = ',num2str(dens),' hashes/sec']);
  
  nd = length(D);
  if nargin < 3
    skip = 0;
  else
    skip = ID;
  end
  if nargin < 2
    SR = [];
  end
  if length(SR) == 0
    % ʹ��Ĭ��˳����
    ID = 1:nd;
  else
    ID = SR;
  end
  N = 0;
  T = 0;
  for i = (skip+1):nd
    disp(['Adding #',num2str(ID(i)),' ',D{i},' ...']);
    [n,t] = add_tracks(D{i},ID(i));
    N = N + n;
    T = T + t;
  end
  disp(['added ',num2str(nd),' tracks (',num2str(T),' secs, ', ...
        num2str(N),' hashes, ',num2str(N/T),' hashes/sec)']);
else
  error('D is unknown');
end



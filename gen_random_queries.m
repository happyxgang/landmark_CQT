function [Q,SR] = gen_random_queries(IDs,Dur,Noise,Seed)
% [Q,SR] = gen_random_queries(IDs,Dur,Noise,Seed)
% ���ɴ��ģ����������Ĳ������ּ���Q
% ���룺
% IDs �ַ������飬��Ƶ�����ļ�������
% Dur ����ÿ����Ƶ����Ƭ�γ���ΪDur��
% Noise ��������ǿ��
% Seed �������������
% ���أ�
% Q ����������Ĳ������ּ���
% SR ������


nIDs = length(IDs);

prepend = '';
postpend = '';

PA = 'D:\wav\';


SR = 0;

if nargin > 3
  rns = RandStream.create('mt19937ar','seed',Seed);
  RandStream.setDefaultStream(rns);
end

for i = 1:length(IDs)
  
  id = IDs{i};
  fname = [prepend,PA,id,postpend];
  [pth,nm,ext] = fileparts(fname);
  if strcmp(ext,'.mp3') == 1
    [d,sr] = mp3read(fname);
  else
    [d,sr] = wavread(fname);
  end
  if size(d,2) == 2
    % ����˫������תΪ������
    d = mean(d,2);
  end
  
  ld = length(d);
  qlen = round(Dur * sr);
  % qlen������Ƶ����ʱqlen=ld-1
  if ld<qlen
      qlen=ld-1;
  end
  % ���ѡ����Ƶ���
  sp = round((ld - qlen)*rand(1));
  Q{i} = d(sp + [1:qlen]) + Noise * randn(qlen,1);
  

  if SR == 0
    SR = sr;
  elseif SR ~= sr
    error(['File ',fname,' has sr ',num2str(sr),' not ', num2str(SR)]);
  end
  
end

  

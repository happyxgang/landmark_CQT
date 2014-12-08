function [Q,SR] = gen_random_queries(IDs,Dur,Noise,Seed)
% [Q,SR] = gen_random_queries(IDs,Dur,Noise,Seed)
% 生成大规模叠加噪声后的测试音乐集合Q
% 输入：
% IDs 字符串数组，音频库中文件名集合
% Dur 生成每个音频测试片段长度为Dur秒
% Noise 叠加噪声强度
% Seed 随机生成器种子
% 返回：
% Q 叠加噪声后的测试音乐集合
% SR 采样率


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
    % 若是双声道则转为单声道
    d = mean(d,2);
  end
  
  ld = length(d);
  qlen = round(Dur * sr);
  % qlen大于音频长度时qlen=ld-1
  if ld<qlen
      qlen=ld-1;
  end
  % 随机选择音频起点
  sp = round((ld - qlen)*rand(1));
  Q{i} = d(sp + [1:qlen]) + Noise * randn(qlen,1);
  

  if SR == 0
    SR = sr;
  elseif SR ~= sr
    error(['File ',fname,' has sr ',num2str(sr),' not ', num2str(SR)]);
  end
  
end

  

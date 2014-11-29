function [N,T] = add_tracks(D,SR,ID)
% [N,T] = add_tracks(D,SR,ID)
%    添加歌曲组D到指纹数据库
%    输入：
%    <D, SR> 表示歌曲组的音频波形, D为字符串数组， ID 对应歌曲编号。注：SR、ID不输入时，使用默认顺序编号
%    返回值：
%    N 添加的总哈希数量, T 添加音频的总时长
%
%================================
%指定音频库的所在目录，注意以\结束
PA = 'i:\mayday\';

% 预设置哈希密度（每秒产生几个哈希）
dens = 10;


if isnumeric(D)
  % 提取音频片段D的显著点，并将其转化为哈希值H
  H = landmark2hash(find_CQTlandmarks(D,SR,dens),ID);
  % 将哈希值H保存到指纹库
  record_hashes(H);
  N = length(H);
  T = length(D)/SR;
elseif ischar(D)
  if nargin < 3
    ID = SR;
  end
  % 读入音频波形
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
    % 使用默认顺序编号
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



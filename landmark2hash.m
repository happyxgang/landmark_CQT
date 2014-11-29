function H = landmark2hash(L,S)
% H = landmark2hash(L,S)
%  将显著点<t1 f1 f2 dt> 的集合转化为音频指纹<ID 起始时间 显著点的哈希值>
%  输入：
%  L 显著点<t1 f1 f2 dt> 的集合
%  S 歌曲ID
%  返回值：
%  H 音频指纹，由三部分组成<ID 起始时间 显著点的哈希值>


% 哈希值为 20 bits: 8 bits  F1, 6 bits  delta-F, 6 bits  delta-T

if nargin < 2
  S = 0;
end
if length(S) == 1
  S = repmat(S, size(L,1), 1);
end

H = uint32(L(:,1));
%确保 F1 为0..255, 不是 1..256
F1 = rem(round(L(:,2)-1),2^8);
DF = round(L(:,3)-L(:,2));
if DF < 0
  DF = DF + 2^8;
end
DF = rem(DF,2^6);
DT = rem(abs(round(L(:,4))), 2^6);
H = [S,H,uint32(F1*(2^12)+DF*(2^6)+DT)];

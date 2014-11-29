function L = hash2landmark(H)
% L = hash2landmark(H)
%  将音频指纹<ID 起始时间 显著点的哈希值>集合转化为显著点<t1 f1 f2 dt> 的集合
%  输入：
%  H 音频指纹，由三部分组成<ID 起始时间 显著点的哈希值>
%  返回值：
%  L 显著点<t1 f1 f2 dt> 的集合


% 哈希值为 20 bits: 8 bits  F1, 6 bits  delta-F, 6 bits  delta-T

if size(H,2) == 3
  H = H(:,[2 3]);
end

H1 = H(:,1);
H2 = double(H(:,2));
F1 = floor(H2/(2^12));
H2 = H2 - (2^12)*F1;
F1 = F1 + 1;
DF = floor(H2/(2^6));
H2 = H2 - (2^6)*DF;
if DF > 2^5
  DF = DF-2^6;
end
F2 = F1+DF;

DT = H2;

L = [H1,F1,F2,DT];

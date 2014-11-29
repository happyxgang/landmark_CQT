function [S,R] = eval_fprint(Q,SR,T)
% [S,R] = eval_fprint(Q,SR,T)
%    使用音频片段的集合Q进行查询，得到正确率S
%    输入参数：
%    Q 是查询音频波形的集合，   SR 对应采样率，  T 对应真实歌曲编号
%    返回值：
%    S 平均正确率， R 对应的最佳匹配


nq = length(Q);
s = 0;

for i = 1:nq
  r = match_query(Q{i},SR);
  R(i,:) = r(1,:);
end

if nargin > 2
 % S = mean(R(:,1)==T');
 S = mean(R(:,2)>7);    % 大于7个哈希匹配则判定歌曲匹配
else
  S = 0;
end


  
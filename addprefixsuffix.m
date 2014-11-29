function Y = addprefixsuffix(X,P,S)
%   对cell数组X中的每个字符串添加前缀字符串P 和后缀字符串 S，
%   得到 新的cell数组Y


if nargin < 3
  S = '';
end

len = length(X);
for i = 1:len
  Y{i} = [P,X{i},S];
end

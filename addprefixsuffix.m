function Y = addprefixsuffix(X,P,S)
%   ��cell����X�е�ÿ���ַ������ǰ׺�ַ���P �ͺ�׺�ַ��� S��
%   �õ� �µ�cell����Y


if nargin < 3
  S = '';
end

len = length(X);
for i = 1:len
  Y{i} = [P,X{i},S];
end

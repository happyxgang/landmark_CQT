function H = landmark2hash(L,S)
% H = landmark2hash(L,S)
%  ��������<t1 f1 f2 dt> �ļ���ת��Ϊ��Ƶָ��<ID ��ʼʱ�� ������Ĺ�ϣֵ>
%  ���룺
%  L ������<t1 f1 f2 dt> �ļ���
%  S ����ID
%  ����ֵ��
%  H ��Ƶָ�ƣ������������<ID ��ʼʱ�� ������Ĺ�ϣֵ>


% ��ϣֵΪ 20 bits: 8 bits  F1, 6 bits  delta-F, 6 bits  delta-T

if nargin < 2
  S = 0;
end
if length(S) == 1
  S = repmat(S, size(L,1), 1);
end

H = uint32(L(:,1));
%ȷ�� F1 Ϊ0..255, ���� 1..256
F1 = rem(round(L(:,2)-1),2^8);
DF = round(L(:,3)-L(:,2));
if DF < 0
  DF = DF + 2^8;
end
DF = rem(DF,2^6);
DT = rem(abs(round(L(:,4))), 2^6);
H = [S,H,uint32(F1*(2^12)+DF*(2^6)+DT)];

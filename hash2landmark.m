function L = hash2landmark(H)
% L = hash2landmark(H)
%  ����Ƶָ��<ID ��ʼʱ�� ������Ĺ�ϣֵ>����ת��Ϊ������<t1 f1 f2 dt> �ļ���
%  ���룺
%  H ��Ƶָ�ƣ������������<ID ��ʼʱ�� ������Ĺ�ϣֵ>
%  ����ֵ��
%  L ������<t1 f1 f2 dt> �ļ���


% ��ϣֵΪ 20 bits: 8 bits  F1, 6 bits  delta-F, 6 bits  delta-T

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

function [S,R] = eval_fprint(Q,SR,T)
% [S,R] = eval_fprint(Q,SR,T)
%    ʹ����ƵƬ�εļ���Q���в�ѯ���õ���ȷ��S
%    ���������
%    Q �ǲ�ѯ��Ƶ���εļ��ϣ�   SR ��Ӧ�����ʣ�  T ��Ӧ��ʵ�������
%    ����ֵ��
%    S ƽ����ȷ�ʣ� R ��Ӧ�����ƥ��


nq = length(Q);
s = 0;

for i = 1:nq
  r = match_query(Q{i},SR);
  R(i,:) = r(1,:);
end

if nargin > 2
 % S = mean(R(:,1)==T');
 S = mean(R(:,2)>7);    % ����7����ϣƥ�����ж�����ƥ��
else
  S = 0;
end


  
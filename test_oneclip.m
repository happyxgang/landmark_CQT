% test_oneclip()
% ��ʾ����1����ƵƬ�εĲ�ѯ
%%
% ����ָ�ƿ�Ͷ�Ӧ�����б�
%load HashDB.mat

% �������ѯ��Ƭ��
fs = 44100;
[dt,srt] = wavread('F:\RecordMusic\���� С����.wav',[fs*90 fs*105]);

%[dt,srt] = wavread('D:\gen_wav\Beyond - �������_noise10.wav');

% �����ѯʱ��
tic
R = match_query(dt,srt);
toc

% ��ϣƥ������С��6ʱ�жϲ�ѯƬ�β�����ָ�ƿ���
if R(1,2)<6
    disp('*** No found in the database ***');
else
    % ������ƥ��Ľ��
    R(1,:)
    
    % ��Ƶָ�ƿ������õ�ʱ�侫��
    tbase = 0.032;
    matchtrk = R(1,1);
    matchdt = R(1,3);
    
    [p,name,e] = fileparts(tks{matchtrk});
    name(find(name == '_')) = ' ';
    disp(['Match: ',name,' at ',num2str(matchdt*tbase),' sec']);
    
end

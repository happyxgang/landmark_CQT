% test_noise()
% ���ģ�������ֵ����������ƥ��
% �����ݿ������ѡ��nQuery����Ƶ������ΪDur�룬��ʼλ��������ֱ��������ǿ��ΪNoise�ĸ�˹��������
% �ֱ𽫵������������Ƶ����ƥ�䣬�õ�ƽ��׼ȷ��ΪS

% ����ָ�ƿ�Ͷ�Ӧ�����б�
load HashDB.mat
list= struct2cell(dir('D:\wav\*.wav'));
tks = list(1,:);
% ָ�ƿ����Ŀ��
nDB = length(tks);
% �����ѯ��Ŀ��
nQuery = 1000;
% ���ڷֱ��¼��ѯ����ȷ��
S_05 = zeros(4,10);
S_01 = zeros(4,10);
S_02 = zeros(4,10);
S_08 = zeros(4,10);
S_10 = zeros(4,10);

%���10��
for tt=1:10
    
    T = round(nDB * rand(1,nQuery));
    IDs = tks(T);
    %%%%%%%%%%%%%%%% Noise = 0.05 %%%%%%%%%%%
    Dur = 15;   %��ѯƬ��Ϊ15��
    Noise = 0.05; % ����ǿ��0.05
    % ������Ƶ��ѯƬ����Q
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    [S15,R] = eval_fprint(Q,SR,T);
    
    Dur = 20; %��ѯƬ��Ϊ20��
    Noise = 0.05; % ����ǿ��0.05
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    [S20,R] = eval_fprint(Q,SR,T);
    
    Dur = 25; %��ѯƬ��Ϊ25��
    Noise = 0.05; % ����ǿ��0.05
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    [S25,R] = eval_fprint(Q,SR,T);
    
    Dur = 30;  %��ѯƬ��Ϊ30��
    Noise = 0.05; % ����ǿ��0.05
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    [S30,R] = eval_fprint(Q,SR,T);
    
    S_05(:,tt) = [S15 S20 S25 S30];
    
    
    %%%%%%%%%%%%%%%% Noise = 0.01 %%%%%%%%%%%
    Dur = 15;
    Noise = 0.01;
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    tic
    [S15,R] = eval_fprint(Q,SR,T);
    toc
    
    
    Dur = 20;
    Noise = 0.01;
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    tic
    [S20,R] = eval_fprint(Q,SR,T);
    toc
    
    Dur = 25;
    Noise = 0.01;
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    tic
    [S25,R] = eval_fprint(Q,SR,T);
    toc
    
    Dur = 30;
    Noise = 0.01;
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    tic
    [S30,R] = eval_fprint(Q,SR,T);
    toc
    
    S_01(:,tt) = [S15 S20 S25 S30];
    
    %%%%%%%%%%%%%%%% Noise = 0.02 %%%%%%%%%%%
    Dur = 15;
    Noise = 0.02;
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    [S15,R] = eval_fprint(Q,SR,T);
    
    Dur = 20;
    Noise = 0.02;
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    [S20,R] = eval_fprint(Q,SR,T);
    
    Dur = 25;
    Noise = 0.02;
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    [S25,R] = eval_fprint(Q,SR,T);
    
    Dur = 30;
    Noise = 0.02;
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    [S30,R] = eval_fprint(Q,SR,T);
    
    S_02(:,tt) = [S15 S20 S25 S30];
    
    %%%%%%%%%%%%%%%% Noise = 0.08 %%%%%%%%%%%
    Dur = 15;
    Noise = 0.08;
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    [S15,R] = eval_fprint(Q,SR,T);
    
    Dur = 20;
    Noise = 0.08;
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    [S20,R] = eval_fprint(Q,SR,T);
    
    Dur = 25;
    Noise = 0.08;
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    [S25,R] = eval_fprint(Q,SR,T);
    
    Dur = 30;
    Noise = 0.08;
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    [S30,R] = eval_fprint(Q,SR,T);
    
    S_08(:,tt) = [S15 S20 S25 S30];
    
    %%%%%%%%%%%%%%%% Noise = 0.10 %%%%%%%%%%%
    Dur = 15;
    Noise = 0.1;
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    [S15,R] = eval_fprint(Q,SR,T);
    
    Dur = 20;
    Noise = 0.1;
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    [S20,R] = eval_fprint(Q,SR,T);
    
    Dur = 25;
    Noise = 0.1;
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    [S25,R] = eval_fprint(Q,SR,T);
    
    Dur = 30;
    Noise = 0.1;
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    [S30,R] = eval_fprint(Q,SR,T);
    
    S_10(:,tt) = [S15 S20 S25 S30];
    
end
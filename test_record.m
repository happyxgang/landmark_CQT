% test_record()
% ���ģ�������ַ�¼���ƥ��
% �����ݿ������ѡ��nQuery����Ƶ������ΪDur�룬��ʼλ�����
% �ֱ𽫷�¼�����Ƶ����ƥ�䣬�õ�ƽ��׼ȷ��ΪS

% ����ָ�ƿ�Ͷ�Ӧ�����б�
load HashDB.mat

% ���뷭¼�����б�
list= struct2cell(dir('F:\RecordMusic\*.wav'));
tks_record = list(1,:);


nDB = length(tks_record);
% �����ѯ��Ŀ��
nQuery = 200;

S_01 = zeros(4,10);

%���5��
for tt=1:5
    
    T = ceil(nDB * rand(1,nQuery));
    IDs = tks_record(T);
    
    Noise = 0;
    
    Dur = 15;
     % ������Ƶ��ѯƬ����Q
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    tic
    [S15,R] = eval_fprint(Q,SR,T);
    toc
    
    
    Dur = 20;
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    tic
    [S20,R] = eval_fprint(Q,SR,T);
    toc
    
    Dur = 25;
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    tic
    [S25,R] = eval_fprint(Q,SR,T);
    toc
    
    Dur = 30;
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    tic
    [S30,R] = eval_fprint(Q,SR,T);
    toc
    
    S_01(:,tt) = [S15 S20 S25 S30];
    
end
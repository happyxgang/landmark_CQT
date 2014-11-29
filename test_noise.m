% test_noise()
% 大规模测试音乐叠加噪声后的匹配
% 从数据库中随机选出nQuery个音频，长度为Dur秒，起始位置随机，分别叠加噪声强度为Noise的高斯白噪声；
% 分别将叠加噪声后的音频进行匹配，得到平均准确率为S

% 加载指纹库和对应歌曲列表
load HashDB.mat
list= struct2cell(dir('D:\wav\*.wav'));
tks = list(1,:);
% 指纹库的条目数
nDB = length(tks);
% 随机查询条目数
nQuery = 1000;
% 用于分别记录查询的正确率
S_05 = zeros(4,10);
S_01 = zeros(4,10);
S_02 = zeros(4,10);
S_08 = zeros(4,10);
S_10 = zeros(4,10);

%随机10次
for tt=1:10
    
    T = round(nDB * rand(1,nQuery));
    IDs = tks(T);
    %%%%%%%%%%%%%%%% Noise = 0.05 %%%%%%%%%%%
    Dur = 15;   %查询片段为15秒
    Noise = 0.05; % 噪声强度0.05
    % 生成音频查询片段组Q
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    [S15,R] = eval_fprint(Q,SR,T);
    
    Dur = 20; %查询片段为20秒
    Noise = 0.05; % 噪声强度0.05
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    [S20,R] = eval_fprint(Q,SR,T);
    
    Dur = 25; %查询片段为25秒
    Noise = 0.05; % 噪声强度0.05
    [Q,SR] = gen_random_queries(IDs,Dur,Noise);
    [S25,R] = eval_fprint(Q,SR,T);
    
    Dur = 30;  %查询片段为30秒
    Noise = 0.05; % 噪声强度0.05
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
% test_record()
% 大规模测试音乐翻录后的匹配
% 从数据库中随机选出nQuery个音频，长度为Dur秒，起始位置随机
% 分别将翻录后的音频进行匹配，得到平均准确率为S

% 加载指纹库和对应歌曲列表
load HashDB.mat

% 读入翻录歌曲列表
list= struct2cell(dir('F:\RecordMusic\*.wav'));
tks_record = list(1,:);


nDB = length(tks_record);
% 随机查询条目数
nQuery = 200;

S_01 = zeros(4,10);

%随机5次
for tt=1:5
    
    T = ceil(nDB * rand(1,nQuery));
    IDs = tks_record(T);
    
    Noise = 0;
    
    Dur = 15;
     % 生成音频查询片段组Q
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
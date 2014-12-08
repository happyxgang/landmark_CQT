% test_oneclip()
% 演示输入1个音频片段的查询
%%
% 加载指纹库和对应歌曲列表
%load HashDB.mat

% 读入待查询的片段
fs = 44100;
[dt,srt] = wavread('F:\RecordMusic\彭羚 小玩意.wav',[fs*90 fs*105]);

%[dt,srt] = wavread('D:\gen_wav\Beyond - 光辉岁月_noise10.wav');

% 计算查询时间
tic
R = match_query(dt,srt);
toc

% 哈希匹配数量小于6时判断查询片段不存在指纹库中
if R(1,2)<6
    disp('*** No found in the database ***');
else
    % 返回最匹配的结果
    R(1,:)
    
    % 音频指纹库所采用的时间精度
    tbase = 0.032;
    matchtrk = R(1,1);
    matchdt = R(1,3);
    
    [p,name,e] = fileparts(tks{matchtrk});
    name(find(name == '_')) = ' ';
    disp(['Match: ',name,' at ',num2str(matchdt*tbase),' sec']);
    
end

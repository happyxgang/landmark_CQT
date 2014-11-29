%% demo_fingerprint.m
%% 音频指纹系统演示，包括生成指纹库HashDB.mat和对输入的音频片段查询
%% 生成音频指纹库保存到HashDB.mat
% 生成音乐库条目列表，请替换相应本地音乐库所在目录
list= struct2cell(dir('H:\TestWave\*.wav'));
tks = list(1,:);

% 初始化指纹库数组 
clear_hashtable

% 将音频列表tks的音频添加到指纹库
add_tracks(tks);

% 将指纹保存到HashDB.mat
global HashTable HashTableCounts
save HashDB3.mat HashTable HashTableCounts tks

%% 演示音频匹配

% 读入待查询的片段
fs = 44100;
[dt,srt] = wavread('H:\RecordMusic\Beyond 光辉岁月.wav',[1 fs*15]);

%  查询匹配
R = match_query(dt,srt);
% R 返回所有匹配，按匹配哈希的数量降序排列。
% R的每行对应一个匹配，包括4个数值：指纹库中匹配的序号、匹配的哈希数量、时间偏移、总匹配的哈希数量
if R(1,2)<8
    disp('*** No found in the database ***');
else
    disp(['Match: ',tks{R(1,1)},' at ',num2str(R(1,3)*0.032),' sec']);
    R(1,:)
end
% 8185  35  3056  36 表示指纹库中的 tks{8185}有35 个匹配哈希，在第3056
% 帧（每帧32ms）匹配上，总匹配哈希数为36

% 显示匹配情况（必须有生成指纹库的音乐存在情况下），匹配的显著点使用绿色标记
illustrate_CQTmatch(dt,srt,tks);
colormap(1-gray)
%%




function clear_hashtable()
% clear_hashtable()
%  初始化指纹数据库，设定数据库大小

% 定义全局变量数组保存哈希值
% HashTable 是个2^20 X 100 的数组，若歌曲id包含有哈希值h，则HashTable的第h列保存有id
% HashTableCounts 保存HashTable每一列的id总数
global HashTable HashTableCounts

% 数据库的列数
nhashes = 2^20;

% 数据库的行数，即每列最大保存id个数
% 对于10万以上的歌曲数量，设定为200比较合适；
% 对于万级别的歌曲数量，设定为100足够。
% 1M hashes x 32 bit/hash x 100 entries = 400MB 
maxnentries = 100;
%maxnentries = 20;

disp(['Max entries per hash = ',num2str(maxnentries)]);

%if length(HashTable) == 0
  HashTable = zeros(maxnentries, nhashes, 'uint32');
  HashTableCounts = zeros(1, nhashes);
%end



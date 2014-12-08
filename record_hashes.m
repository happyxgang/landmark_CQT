function N = record_hashes(H)
% N = record_hashes(H)
%   保存指纹集合到指纹数据库
%   输入：
%   H 指纹集合，每个指纹由三部分组成<ID 起始时间 显著点的哈希值>
%   返回值：
%   N 保存的指纹数目
%   ID 24 bit
%   起始时间 8 bit



% 使用全局数组保存指纹和指纹数目
global HashTable HashTableCounts


maxnentries = size(HashTable,1);

nhash = size(H,1);

N = 0;

TIMESIZE = 16384;

for i=1:nhash
  song = H(i,1);
  toffs = mod(round(H(i,2)), TIMESIZE);
  hash = 1+H(i,3);  % 避免哈希值为0
  htcol = HashTable(:,hash);
  nentries =  HashTableCounts(hash) + 1;
  if nentries <= maxnentries
	% 将hash保存到下一位置
	r = nentries;
  else
    r = ceil(nentries*rand(1));
  end
  if r <= maxnentries
    hashval = int32(song*TIMESIZE + toffs);
%    disp(num2str(floor(double(hashval)/TIMESIZE)));
    HashTable(r,hash) = hashval;
    N = N+1;
  end
HashTableCounts(hash) = nentries;
end

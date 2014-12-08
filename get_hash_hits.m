function R = get_hash_hits(H)
% R = get_hash_hits(H)
%   输入：
%   H 待查询音频中提取出的哈希值
%   返回值：
%    R 所有匹配，每个匹配包括：指纹库中匹配的序号、匹配的哈希数量、时间偏移、总匹配的哈希数量



if size(H,2) == 3
  H = H(:,[2 3]);
end

if min(size(H))==1
  H = [zeros(length(H),1),H(:)];
end

global HashTable HashTableCounts
nhtcols = size(HashTable,1);

TIMESIZE=16384;

Rsize = 1000;  % 预分配
R = zeros(Rsize,3);
Rmax = 0;

for i = 1:length(H)
  hash = H(i,2);
  htime = double(H(i,1));
  nentries = min(nhtcols,HashTableCounts(hash+1));
  htcol = double(HashTable(1:nentries,hash+1));
  songs = floor(htcol/TIMESIZE);
  times = round(htcol-songs*TIMESIZE);
  if Rmax+nentries > Rsize
    R = [R;zeros(Rsize,3)];
    Rsize = size(R,1);
  end
  dtimes = times-htime;
  R(Rmax+[1:nentries],:) = [songs, dtimes, repmat(double(hash),nentries,1)];
  Rmax = Rmax + nentries;
end

R = R(1:Rmax,:);

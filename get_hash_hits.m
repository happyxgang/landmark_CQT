function R = get_hash_hits(H)
% R = get_hash_hits(H)
%   ���룺
%   H ����ѯ��Ƶ����ȡ���Ĺ�ϣֵ
%   ����ֵ��
%    R ����ƥ�䣬ÿ��ƥ�������ָ�ƿ���ƥ�����š�ƥ��Ĺ�ϣ������ʱ��ƫ�ơ���ƥ��Ĺ�ϣ����



if size(H,2) == 3
  H = H(:,[2 3]);
end

if min(size(H))==1
  H = [zeros(length(H),1),H(:)];
end

global HashTable HashTableCounts
nhtcols = size(HashTable,1);

TIMESIZE=16384;

Rsize = 1000;  % Ԥ����
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

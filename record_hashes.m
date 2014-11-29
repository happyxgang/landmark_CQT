function N = record_hashes(H)
% N = record_hashes(H)
%   ����ָ�Ƽ��ϵ�ָ�����ݿ�
%   ���룺
%   H ָ�Ƽ��ϣ�ÿ��ָ�������������<ID ��ʼʱ�� ������Ĺ�ϣֵ>
%   ����ֵ��
%   N �����ָ����Ŀ
%   ID 24 bit
%   ��ʼʱ�� 8 bit



% ʹ��ȫ�����鱣��ָ�ƺ�ָ����Ŀ
global HashTable HashTableCounts


maxnentries = size(HashTable,1);

nhash = size(H,1);

N = 0;

TIMESIZE = 16384;

for i=1:nhash
  song = H(i,1);
  toffs = mod(round(H(i,2)), TIMESIZE);
  hash = 1+H(i,3);  % �����ϣֵΪ0
  htcol = HashTable(:,hash);
  nentries =  HashTableCounts(hash) + 1;
  if nentries <= maxnentries
	% ��hash���浽��һλ��
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

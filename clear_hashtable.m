function clear_hashtable()
% clear_hashtable()
%  ��ʼ��ָ�����ݿ⣬�趨���ݿ��С

% ����ȫ�ֱ������鱣���ϣֵ
% HashTable �Ǹ�2^20 X 100 �����飬������id�����й�ϣֵh����HashTable�ĵ�h�б�����id
% HashTableCounts ����HashTableÿһ�е�id����
global HashTable HashTableCounts

% ���ݿ������
nhashes = 2^20;

% ���ݿ����������ÿ����󱣴�id����
% ����10�����ϵĸ����������趨Ϊ200�ȽϺ��ʣ�
% �����򼶱�ĸ����������趨Ϊ100�㹻��
% 1M hashes x 32 bit/hash x 100 entries = 400MB 
maxnentries = 100;
%maxnentries = 20;

disp(['Max entries per hash = ',num2str(maxnentries)]);

%if length(HashTable) == 0
  HashTable = zeros(maxnentries, nhashes, 'uint32');
  HashTableCounts = zeros(1, nhashes);
%end



%% demo_fingerprint.m
%% ��Ƶָ��ϵͳ��ʾ����������ָ�ƿ�HashDB.mat�Ͷ��������ƵƬ�β�ѯ
%% ������Ƶָ�ƿⱣ�浽HashDB.mat
% �������ֿ���Ŀ�б����滻��Ӧ�������ֿ�����Ŀ¼
% list= struct2cell(dir('e:\mayday\*.wav'));
% tks = list(1,:);
% 
% % ��ʼ��ָ�ƿ����� 
% clear_hashtable
% 
% % ����Ƶ�б�tks����Ƶ��ӵ�ָ�ƿ�
% add_tracks(tks);

% ��ָ�Ʊ��浽HashDB.mat
global HashTable HashTableCounts
%save HashDB3.mat HashTable HashTableCounts tks
load HashDB3.mat HashTable HashTableCounts tks
%% ��ʾ��Ƶƥ��

test_dir='I:\id_testfiles\';
dir_files = dir(test_dir);

% �������ѯ��Ƭ��
fs = 8000;
n = length(dir_files);
for k=1:n
    %&& (dir_files(k).name(end-3,end) == 'wav'
    if (length(dir_files(k).name) > 4) && (strcmp(dir_files(k).name(end-2:end), 'wav'))
        s = dir_files(k).name;
        [dt,srt] = wavread([test_dir s]);
        %  ��ѯƥ��
        R = match_query(dt,srt);
        % R ��������ƥ�䣬��ƥ���ϣ�������������С�
        % R��ÿ�ж�Ӧһ��ƥ�䣬����4����ֵ��ָ�ƿ���ƥ�����š�ƥ��Ĺ�ϣ������ʱ��ƫ�ơ���ƥ��Ĺ�ϣ����
        if R(1,2)<8
            disp('*** No found in the database ***');
        else
            disp(['Origin:',dir_files(k).name]);
            disp(['Match: ',tks{R(1,1)},' at ',num2str(R(1,3)*0.032),' sec']);
            R(1,:)
        end
        % 8185  35  3056  36 ��ʾָ�ƿ��е� tks{8185}��35 ��ƥ���ϣ���ڵ�3056
        % ֡��ÿ֡32ms��ƥ���ϣ���ƥ���ϣ��Ϊ36

        % ��ʾƥ�����������������ָ�ƿ�����ִ�������£���ƥ���������ʹ����ɫ���
        % illustrate_CQTmatch(dt,srt,tks);
        % colormap(1-gray)
    end
end
%%




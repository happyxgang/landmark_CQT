function [R,L] = match_query(D,SR,IX)
% [R,L] = match_query(D,SR,IX)
%     ��ָ�ƿ���ƥ����ƵD
%   ���룺
%   D ����ѯ��Ƶ�� SR �����ʣ� IX ָ�����صڼ��������Ĭ��Ϊ1��
%   ����ֵ��
%    R ����ƥ�䣬ÿ��ƥ�������ָ�ƿ���ƥ�����š�ƥ��Ĺ�ϣ������ʱ��ƫ�ơ���ƥ��Ĺ�ϣ����
%    L ƥ���ϵ������� <t1 f1 f2 dt> �ļ���



if nargin < 3
  IX = 1;
end

if ischar(D)
  if nargin > 1
    IX = SR;
  end
  [D,SR] = readaudio(D);
end

% �趨����ѯ��Ƶ�Ĺ�ϣ�ܶ�
dens = 20;

% ת��Ϊ������
if size(D,2) == 2
  D = mean(D,2);
end

Lq = find_CQTlandmarks(D,SR, dens);

% ��ȡ����ѯ��Ƶ��ʱ��ƫ�����õ���������
landmarks_hopt = 0.032;
Lq = [Lq;find_CQTlandmarks(D(round(landmarks_hopt/8*SR):end),SR, dens)];
Lq = [Lq;find_CQTlandmarks(D(round(landmarks_hopt/4*SR):end),SR, dens)];
Lq = [Lq;find_CQTlandmarks(D(round(3*landmarks_hopt/8*SR):end),SR, dens)];
Lq = [Lq;find_CQTlandmarks(D(round(landmarks_hopt/2*SR):end),SR, dens)];
Lq = [Lq;find_CQTlandmarks(D(round(5*landmarks_hopt/8*SR):end),SR, dens)];
Lq = [Lq;find_CQTlandmarks(D(round(3*landmarks_hopt/4*SR):end),SR, dens)];
Lq = [Lq;find_CQTlandmarks(D(round(7*landmarks_hopt/8*SR):end),SR, dens)];

Hq = unique(landmark2hash(Lq), 'rows');
disp(['landmarks ',num2str(size(Lq,1)),' -> ', num2str(size(Hq,1)),' hashes']);
Rt = get_hash_hits(Hq);
nr = size(Rt,1);

if nr > 0

  % �ҳ�ƥ����Ŀ���ĸ���
  [utrks,xx] = unique(sort(Rt(:,1)),'first');
  utrkcounts = diff([xx',nr]);

  [utcvv,utcxx] = sort(utrkcounts, 'descend');
  
  utcxx = utcxx(1:min(20,length(utcxx)));
  utrkcounts = utrkcounts(utcxx);
  utrks = utrks(utcxx);
  
  nutrks = length(utrks);
  R = zeros(nutrks,4);

  for i = 1:nutrks
    tkR = Rt(Rt(:,1)==utrks(i),:);
    % �ҳ�������������Ĺ�ϣ
    [dts,xx] = unique(sort(tkR(:,2)),'first');
    dtcounts = 1+diff([xx',size(tkR,1)]);
    [vv,xx] = max(dtcounts);

    R(i,:) = [utrks(i),sum(abs(tkR(:,2)-dts(xx(1)))<=1),dts(xx(1)),size(tkR,1)];
  end

  % ��������ƥ����
  [vv,xx] = sort(R(:,2),'descend');
  R = R(xx,:);


  Hix = find(Rt(:,1)==R(IX,1));
  % ����ԭʼ����ʱ��
  for i = 1:length(Hix)
    L(i,:) = [hash2landmark(Rt(Hix(i),:)), Rt(Hix(i),2)];
    hqix = find(Hq(:,3)==Rt(Hix(i),3));
    hqix = hqix(1);  
    L(i,1) = L(i,1)+Hq(hqix,2);
  end


  % ����ǰ100λ��ƥ��
  maxrtns = 100;
  if size(R,1) > maxrtns
    R = R(1:maxrtns,:);
  end
  maxhits = R(1,2);
  nuffhits = R(:,2)>(0.1*maxhits);
 
else
  R = zeros(0,4);
  disp('*** NO HITS FOUND ***');
end

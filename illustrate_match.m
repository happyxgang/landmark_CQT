function [DM,SRO,TK,T] = illustrate_match(DQ,SR,FL,IX)
% [DM,SRO,TK,T] = illustrate_match(DQ,SR,FL,IX)
% —› æ“Ù∆µ∆•≈‰

PA = 'D:\wav\';
if nargin < 4;  IX = 1; end

if isstr(DQ)
  [DQ,SR] = readaudio(DQ);
end


[R,Lm] = match_query(DQ,SR,IX);

Lm = Lm( abs(Lm(:,5)-R(IX,3)) < 1 ,:);


dens = 7;
Lq = find_landmarks(DQ,SR,dens);

subplot(211)
show_landmarks(DQ,SR,Lq);


tbase = 0.032;  
matchtrk = R(IX,1);
matchdt = R(IX,3);
[d,SRO] = wavread([PA FL{matchtrk}]);
Ld = find_landmarks(d,SRO,dens);

subplot(212)
show_landmarks(d,SRO,Ld,matchdt*tbase + [0 length(DQ)/SR]);
mbase = 1 + round(matchdt*tbase*SRO);
mend = mbase - 1 + round(length(DQ)*SRO/SR);
DM = [zeros(1,max(0,-(mbase-1))), d(max(1,mbase):mend)];
[p,name,e] = fileparts(FL{matchtrk});
name(find(name == '_')) = ' ';
title(['Match: ',name,' at ',num2str(matchdt*tbase),' sec']);


show_landmarks([],SRO,Lm,[],'o-g');
subplot(211)
show_landmarks([],SRO,Lm-repmat([matchdt 0 0 0 0],size(Lm,1),1),[],'o-g');
title('Query audio')

TK = matchtrk;
T = matchdt;

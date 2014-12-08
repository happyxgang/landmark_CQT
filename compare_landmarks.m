%% 比较landmarks 和 CQTlandmarks
close all;
name = 'Beyond 光辉岁月';

dens = 10;
[DQ,SR] = wavread(['H:\WaveMusic\' name '.wav'],[1 44100*30]);
[d,SRO] = wavread(['H:\RecordMusic\' name '.wav'],[1 44100*30]);
if (SR ~= SRO)
  DQ = resample(DQ,SRO,SR);
  SR = SRO;
end
r=xcorr(DQ(1:10*SR),d(1:10*SR));
start = find(r==max(r));
DQ(1:start) = [];
samples = min(length(DQ),length(d));
DQ = DQ(1:samples);
d = d(1:samples);

Lq = find_landmarks(DQ,SR,dens);
subplot(211)
show_landmarks(DQ,SR,Lq);
title(['Original ' name]);

Ld = find_landmarks(d,SR,dens);
subplot(212)
show_landmarks(d,SR,Ld);
title(['Record ' name]);


figure(2);
[Ld,Sd,Td,maxesd] = find_CQTlandmarks(d,SR,dens);
subplot(212)
show_CQTlandmarks(d,SR,Ld);
title(['Record ' name]);

[Lq,Sq,Tq,maxesq] = find_CQTlandmarks(DQ,SR,dens);
subplot(211)
show_CQTlandmarks(DQ,SR,Lq);
title(['Original ' name]);



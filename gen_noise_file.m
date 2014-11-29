%% ���ɼ�����Ƶ������
fname = 'D:\wav\Beyond - �������.wav';
[d,sr] = wavread(fname);

[p,name,e] = fileparts(fname);
prefix = 'D:\gen_wav\';

Dur = 20;
Noise = 0.1;
ld = length(d);
qlen = round(Dur * sr);
% qlen������Ƶ����ʱqlen=ld-1
if ld<qlen
    qlen=ld-1;
end
% ���ѡ����Ƶ���
sp = round((ld - qlen)*rand(1));
y = d(sp + [1:qlen]) + Noise * randn(qlen,1);

%���������Ƶ���ڱȽ�
wavwrite(d(sp + [1:qlen]),sr,[prefix, name, '_clip',e]);
wavwrite(y,sr,[prefix, name, '_noise',e]);
disp(['Generate ', prefix, name, '_clip',e]);
disp(['Generate ', prefix, name, '_noise',e]);
%% 生成加载音频并保存
fname = 'D:\wav\Beyond - 光辉岁月.wav';
[d,sr] = wavread(fname);

[p,name,e] = fileparts(fname);
prefix = 'D:\gen_wav\';

Dur = 20;
Noise = 0.1;
ld = length(d);
qlen = round(Dur * sr);
% qlen大于音频长度时qlen=ld-1
if ld<qlen
    qlen=ld-1;
end
% 随机选择音频起点
sp = round((ld - qlen)*rand(1));
y = d(sp + [1:qlen]) + Noise * randn(qlen,1);

%保存加噪音频用于比较
wavwrite(d(sp + [1:qlen]),sr,[prefix, name, '_clip',e]);
wavwrite(y,sr,[prefix, name, '_noise',e]);
disp(['Generate ', prefix, name, '_clip',e]);
disp(['Generate ', prefix, name, '_noise',e]);
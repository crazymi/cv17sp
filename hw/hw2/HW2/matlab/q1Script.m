datadir = '../data/q1';
resultdir = '../result/q1';

if(~exist(resultdir,'dir'))
    mkdir(resultdir);
end

[g1 d1] = separateGlobalDirect(sprintf('%s/scene1', datadir));
[g2 d2] = separateGlobalDirect(sprintf('%s/scene2', datadir));

imwrite(g1, sprintf('%s/scene1_global.png', resultdir));
imwrite(d1, sprintf('%s/scene1_direct.png', resultdir));
imwrite(g2, sprintf('%s/scene2_global.png', resultdir));
imwrite(d2, sprintf('%s/scene2_direct.png', resultdir));

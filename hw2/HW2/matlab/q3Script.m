darkThreshold = 0.34;

datadir = '../data/q3';
resultdir = '../result/q3';

if(~exist(resultdir,'dir'))
    mkdir(resultdir);
end

load(sprintf('%s/lights.mat', datadir), '-mat');

[g1 d1] = separateGlobalDirect(sprintf('%s/light01_checkerboard', datadir));
[g2 d2] = separateGlobalDirect(sprintf('%s/light02_checkerboard', datadir));
[g3 d3] = separateGlobalDirect(sprintf('%s/light03_checkerboard', datadir));

imwrite(g1, sprintf('%s/scene1_global.png', resultdir));
imwrite(d1, sprintf('%s/scene1_direct.png', resultdir));
imwrite(g2, sprintf('%s/scene2_global.png', resultdir));
imwrite(d2, sprintf('%s/scene2_direct.png', resultdir));
imwrite(g3, sprintf('%s/scene3_global.png', resultdir));
imwrite(d3, sprintf('%s/scene3_direct.png', resultdir));

img1 = double(imread(sprintf('%s/light01.png', datadir)))/255;
img2 = double(imread(sprintf('%s/light02.png', datadir)))/255;
img3 = double(imread(sprintf('%s/light03.png', datadir)))/255;

[m n] = size(img1);

[normals albedo] = computeNormals( img1, img2, img3, lv1, lv2, lv3, darkThreshold);
[normalsD albedoD] = computeNormals( double(d1), double(d2), double(d3), lv1, lv2, lv3, darkThreshold);

[Ni Z] = integrability2(normTointnorm(normals,m,n));
[Nd Zd] = integrability2(normTointnorm(normalsD,m,n));

figure(1);
surfl(uint8(Z));
shading interp;
colormap gray;

figure(2);
surfl(uint8(Zd));

shading interp;
colormap gray;

% 3*N to P*Q*3
function [normal] = normTointnorm(normals, p, q)
normal = zeros(p,q,3);

for i=1:p*q
        [x y] = ind2sub([p q], i);
        normal(x,y,1) = normals(1,i);
        normal(x,y,2) = normals(2,i);
        normal(x,y,3) = normals(3,i);
end
end
darkThreshold = 0.02;

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

% normals : 3*N, albedo : m*n
[normals albedo] = computeNormals( img1, img2, img3, lv1, lv2, lv3, darkThreshold);
[normalsD albedoD] = computeNormals( double(d1), double(d2), double(d3), lv1, lv2, lv3, darkThreshold);

% normals & albedo
% 
%  step = 10;
%  X = 1:step:size(img1,2);
%  Y = 1:step:size(img1,1);
%  U = reshape(normals(1,:), size(img1));
%  V = reshape(normals(2,:), size(img1));
%  U = U(1:10:end, 1:10:end);
%  V = V(1:10:end, 1:10:end);
%  
%  figure(1);
%  hold off;
%  imshow(img1);
%  hold on;
%  quiver(X,Y,U,V);
%  title('Computed Surface Normals');
%  
%  figure(2);
%  imagesc(albedo);
%  title('Unnormalized Albedo');

% need loop for 3dim reshape
% normals : m*n*3
% normals = reshape(normals, m, n, 3);
% normalsD = reshape(normalsD, m, n, 3);

N = zeros(m,n,3);
Nd = zeros(m,n,3);
for i=1:3
    N(:,:,i) = reshape(normals(i,:), m, n);
    Nd(:,:,i) = reshape(normalsD(i,:), m, n);
end

% Z : m*n
[Ni Z] = integrability2(N);
[Nd Zd] = integrability2(Nd);

figure(3);
surfl(Z);
shading interp;
colormap gray;

figure(4);
surfl(Zd);
shading interp;
colormap gray;
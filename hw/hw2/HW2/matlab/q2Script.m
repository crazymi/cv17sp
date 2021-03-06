circleThreshold = 0.42; %set this value 0.42
darkThreshold   = 0.34; %set this value 0.34
% decide by prctile

%path to sphere and object images
datapath = '../data/q2';

%read in the ambient light image
img1 = double(imread(sprintf('%s/sphere0.pgm', datapath)))/255;

%compute radius and center of sphereim
[cx cy r] = findCircle(img1, circleThreshold);

%find directions of light sources
img1 = double(imread(sprintf('%s/sphere1.pgm', datapath)))/255;
img2 = double(imread(sprintf('%s/sphere2.pgm', datapath)))/255;
img3 = double(imread(sprintf('%s/sphere3.pgm', datapath)))/255;

lv1 = findLight(img1, cx, cy, r);
lv2 = findLight(img2, cx, cy, r);
lv3 = findLight(img3, cx, cy, r);

%read in images of object under different lighting conditions
img1 = double(imread(sprintf('%s/object1.pgm', datapath)))/255;
img2 = double(imread(sprintf('%s/object2.pgm', datapath)))/255;
img3 = double(imread(sprintf('%s/object3.pgm', datapath)))/255;

%compute normals and albedos with photometric stereo
[normals albedo] = computeNormals( img1, img2, img3, lv1, lv2, lv3, darkThreshold);
[normalsO albedoO] = optComputeNormals( img1, img2, img3, lv1, lv2, lv3, darkThreshold);

N = normals;

%Visualization only below this line
 step = 10;
 X = 1:step:size(img1,2);
 Y = 1:step:size(img1,1);
 U = reshape(normals(1,:), size(img1));
 V = reshape(normals(2,:), size(img1));
 U = U(1:step:end, 1:step:end);
 V = V(1:step:end, 1:step:end);
 
 Uo = reshape(normalsO(1,:), size(img1));
 Vo = reshape(normalsO(2,:), size(img1));
 Uo = Uo(1:step:end, 1:step:end);
 Vo = Vo(1:step:end, 1:step:end);
 
 
 figure(1);
 subplot(1,2,1);
 hold off;
 imshow(img1);
 hold on;
 quiver(X,Y,U,V);
 title('Surface Normals');
 subplot(1,2,2);
 imshow(img1);
 hold on;
 quiver(X,Y,Uo,Vo);
 title('Optimized Normals');
 
 figure(2);
 subplot(1,2,1);
 imagesc(albedo);
 title('Unnormalized Albedo');
 subplot(1,2,2);
 imagesc(albedoO);
 title('Optimized Albedo');
 
% difference between basis - opt
% At threshold = 0.34
% concordance rate = 294792/480000 = 61.415%
% 
 
%  3d reconstruct
%  
%  [m n] = size(img1);
%  Nd = zeros(m,n,3);
%  for i=1:3
%      Nd(:,:,i) = reshape(N(i,:),m,n);
%  end
%  
%  [Ni Z]=integrability2(Nd);
%  figure(3);
%  surfl(Z);
%  shading interp;
%  color gray;
%  
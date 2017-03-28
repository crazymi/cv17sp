function [lines] = timeTest()
% img = imread('../data/img02.jpg');
% [Im Io Ix Iy] = myEdgeFilter(img, 1);
% figure, imshow(Im);

RGB = imread('../data/img03.jpg');
I  = rgb2gray(RGB);

% BW = edge(I,'sobel');
BW = myEdgeFilter(I, sqrt(2));

[H,T,R] = hough(BW,'RhoResolution',0.5,'ThetaResolution',0.5);
[H1] = myHoughTransform(BW, 0, 0.5, 0.5);

subplot(3,1,1);
imshow(RGB);
title('gantrycrane.png');

subplot(3,1,2);
imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
      'InitialMagnification','fit');
title('hough in Matlab');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(gca,hot);

subplot(3,1,3);
imshow(imadjust(mat2gray(H1)),'XData',T,'YData',R,...
      'InitialMagnification','fit');
title('myHoughTransform');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(gca,hot);

peaks = houghpeaks(H,10)
[lineRho lineTheta] = myHoughLines(H1,0.5,0.5,10)

% lines = houghlines(BW,T,R,peaks,'MinLength',7);
lines = myHoughLineSegments(lineRho, lineTheta, BW, 40);

img2 = I;
for j=1:numel(lines)
       img2 = drawLine(img2, lines(j).start, lines(j).end); 
end
subplot(1,1,1);
imshow(img2);
end
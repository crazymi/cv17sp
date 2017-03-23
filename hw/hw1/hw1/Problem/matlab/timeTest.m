function timeTest()
% img = imread('../data/img02.jpg');
% [Im Io Ix Iy] = myEdgeFilter(img, 1);
% figure, imshow(Im);

RGB = imread('../data/img02.jpg');
% I  = rgb2gray(RGB);e
I = RGB;

% BW = edge(I,'canny');
BW = myEdgeFilter(I, 1);

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
end
% Write a function to find the centroid and radius of spheres in the included
% sphere images
% function [cx cy r] = findCircle(img, threshold)
% The function will input a greyscale image img and a scalar threshold threshold
% for binarizing the image. The outputs are the image coordinates of the center
% of the sphere cx and cy and the radius of the sphere in pixels r.
% Under orthographic projection, the sphere projects into a circle on the image
% plane. You need to threshold the greyscale image to obtain a binary one. Make
% sure you choose a good threshold, so that the circle in the resulting image looks
% clean. Find the centroid and radius of the circle in the resulting binary image.

function [cx cy r] = findCircle(img, threshold)

% binarizing and find edge
img = (img >= threshold);
img = edge(img, 'canny');

[m n] = size(img);

% find possible radius range
hor = ones(n, 1);
ver = ones(1, m);
horSum = img*hor;
verSum = ver*img;
minH = min(find(horSum>0));
maxH = max(find(horSum>0));
minV = min(find(verSum>0));
maxV = max(find(verSum>0));

r = max((maxH-minH)/2, (maxV-minV)/2);
cx = (maxV-minV)/2+minV;
cy = (maxH-minH)/2+minH;

end
% Write a function to find the direction and intensity of the light source in an
% image of a sphere given the sphere's parameters under the assumption that
% there is a single point light source in the scene.
% function [lv] = findLight(img, cx, cy, r)
% The function will input a greyscale imageimg along with the center coordinates
% of the sphere in that image (cx and cy) along with the sphere's radius r. The
% function will output lv a vector of length 3 pointing in the direction of the
% light source.
% Find the normal direction corresponding to the brightest pixel in the image.
% Assume that the direction of this normal is the same as the direction of the
% light source in the image. The intensity of the light source is proportional
% to the magnitude (brightness) of the brightest pixel on the sphere, scale the
% direction vector lv so that its length equals this value.

function [lv] = findLight(img, cx, cy, r)
[m n] = size(img);
[val idx] = max(img(:));
[y x]=ind2sub(size(img), idx);

% (x,y) in circle
assert((x-cx)*(x-cx)+(y-cy)*(y-cy) <= r*r);

z = 1 + sqrt(r*r - (x-cx)*(x-cx) - (y-cy)*(y-cy));

lv = [x-cx; y-cy; z-1]*img(x,y);

lv = lv/norm(lv);

end
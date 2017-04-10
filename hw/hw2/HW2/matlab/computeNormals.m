% Write a function that inputs three images of an object along with the direc-
% tions of the light sources in the three images and outputs the surface normal
% directions at a regularly sampled grid across the image.
% function [normals albedo] = computeNormals(img1, img2, img3, lv1,
% lv2, lv3, threshold)
% The function will input 3 greyscale images img1, img2 and img3 and the light
% sources for each of those images lv1, lv2 and lv3 respectively. threshold
% 4
% decides which pixels to ignore when calculating normals. If a pixel isn't illu-
% minated by all three light sources, then the normal can not be computed. If
% the minimum value of a pixel is below the threshold then assume it falls into
% the shadows in one of the images and do not compute a normal. normals is
% a 3*N matrix which stores the normal directions at each pixel in the image.
% albedo is an image of the scene where each pixel represents the (unnormalized)
% albedo of a scene point, not the apparent brightness.
% Refer to the class notes on how to compute normals and albedos.

function [normals albedo] = computeNormals(img1, img2, img3, lv1, lv2, lv3, threshold)
% not optimized
[m n] = size(img1);
S = [lv1.';lv2.';lv3.'];
invS = inv(S);
normals = zeros(3, m*n);
albedo = zeros(m,n);

s = 1;
for j=1:n
    for i=1:m
        I = [img1(i,j); img2(i,j); img3(i,j)];
        N = invS*I;
        if(img1(i,j) < threshold || img2(i,j) < threshold || img3(i,j) < threshold)
            normals(:,s) = [0;0;0];
        else
            normals(:, s) = N / norm(N);
        end
        s = s+1;
        albedo(i,j) = norm(N);
    end
end


end
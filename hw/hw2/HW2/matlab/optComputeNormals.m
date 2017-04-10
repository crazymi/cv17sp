function [normals albedo] = optComputeNormals(img1, img2, img3, lv1, lv2, lv3, threshold)
% gives weighted least-squares to handle shadows
[m n] = size(img1);
normals = zeros(3, m*n);
albedo = zeros(m, n);

s = 1;
for j=1:n
    for i=1:m
        I = [img1(i,j)*img1(i,j) ; img2(i,j)*img2(i,j) ; img3(i,j)*img3(i,j)];
        S = [img1(i,j)*lv1' ; img2(i,j)*lv2' ; img3(i,j)*lv3'];
        N = S\I;
        if(img1(i,j) >= threshold && img2(i,j) >= threshold && img3(i,j) >= threshold)
            normals(:, s) = N / norm(N);

        end
        albedo(i,j) = norm(N);
        s=s+1;
    end
end

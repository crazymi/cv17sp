function [filtered_img] = myImageFilter(img, filter)

% flip the kernel in both horizonal and vertical direction
filter = rot90(filter, 2);

[fh, fw] = size(filter);
% assert(fw is odd && fh is odd)
if (fh == 1)
    fh = 0;
else
    fh = (fh-1)/2;
end
if (fw == 1)
    fw = 0;
else
    fw = (fw-1)/2;
end

% pad the value of nearest pixel that lies inside the image.
padded_img = padarray(img, [fh fw], 'replicate', 'both');
[ih, iw] = size(padded_img);

% copy of original img
filtered_img = padded_img;

for i = 1+fh:ih-fh
    for j = 1+fw:iw-fw
        % convolution
        source = double(padded_img([i-fh:i+fh], [j-fw : j+fw]));
        multiplied_matrix = source.*filter;
        sum_of_multiply = sum(multiplied_matrix(:));
        filtered_img(i, j) = sum_of_multiply;
    end
end

% ignore padded array
filtered_img = filtered_img([1+fh:ih-fh], [1+fw:iw-fw]);

end
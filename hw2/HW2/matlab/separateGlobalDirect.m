function [globalImg directImg] = separateGlobalDirect(dirname)

imglist = dir(sprintf('%s/*.png', dirname));

img = imread(sprintf('%s/%s', dirname, imglist(1).name));
[m n] = size(img);
minImg = img;
maxImg = img;

assert(numel(imglist)>=2);

for i = 2:numel(imglist)
    [path imgname dummy] = fileparts(imglist(i).name);
    img = imread(sprintf('%s/%s', dirname, imglist(i).name));

    minImg = min(img, minImg);
    maxImg = max(img, maxImg);
end

globalImg = 2*minImg;
directImg = maxImg - minImg;

end
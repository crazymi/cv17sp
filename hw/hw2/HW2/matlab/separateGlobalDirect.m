function [globalImg directImg] = separateGlobalDirect(dirname)

imglist = dir(sprintf('%s/*.png', dirname));

img = double(imread(sprintf('%s/%s', dirname, imglist(1).name)))/255;
[m n] = size(img);
minImg = img;
maxImg = img;

assert(numel(imglist)>=2);

for i = 2:numel(imglist)
    [path imgname dummy] = fileparts(imglist(i).name);
    img = double(imread(sprintf('%s/%s', dirname, imglist(i).name)))/255;

    minImg = min(img, minImg);
    maxImg = max(img, maxImg);
end

globalImg = 2*minImg;
directImg = maxImg - minImg;

end
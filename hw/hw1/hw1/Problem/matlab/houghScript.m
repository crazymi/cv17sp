datadir     = '../data';    %the directory containing the images
resultsdir  = '../results'; %the directory for dumping results
%parameters

sigma     = 2;
threshold = 0.03;
rhoRes    = 2;
thetaRes  = pi/180;
nLines    = 20;

%end of parameters

imglist = dir(sprintf('%s/*.jpg', datadir));

for i = 1:numel(imglist)
    
    %read in images%
    [path imgname dummy] = fileparts(imglist(i).name);
    img = imread(sprintf('%s/%s', datadir, imglist(i).name));
    
    if (ndims(img) == 3)
        img = rgb2gray(img);
    end
    
    img = double(img) / 255;
   
    %actual Hough line code function calls%
    
    [Im Io Ix Iy] = myEdgeFilter(img, sigma);
    
    [H] = myHoughTransform(Im, threshold, rhoRes, thetaRes);
    
    [lineRho lineTheta] = myHoughLines(H, rhoRes, thetaRes, nLines);
    
    lines = myHoughLineSegments(lineRho, lineTheta, Im, threshold);
    
    %everything below here just saves the outputs to files%
    fname = sprintf('%s/%s_01edge.pgm', resultsdir, imgname);
    imshow(Im);
%     imshow(sqrt(Im/max(Im(:))));
%     imwrite(sqrt(Im/max(Im(:))), fname);
    fname = sprintf('%s/%s_02threshold.pgm', resultsdir, imgname);
%     imshow(Im > threshold);
%     imwrite(Im > threshold, fname);
    fname = sprintf('%s/%s_03hough.pgm', resultsdir, imgname);
%     imwrite(H/max(H(:)), fname);
    imshow(H/max(H(:)));
    fname = sprintf('%s/%s_04lines.pgm', resultsdir, imgname);
    
    img2 = img;
    for j=1:numel(lines)
       img2 = drawLine(img2, lines(j).start, lines(j).end); 
    end
    
    imshow(img2);
%     imwrite(img2, fname);
end
    
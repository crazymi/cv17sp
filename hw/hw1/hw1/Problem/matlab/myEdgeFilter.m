
function [imgEdgeMagnitude imgEdgeOrientation imgSobelX imgSobelY] = myEdgeFilter(img, sigma)

% decide filterSize 'N' with given standard derivation 'sigma'
% seems like Nvidia uses below size while gaussian blur
filterSize = floor(3*sigma);
initFilter = -filterSize:filterSize;

% 1D gaussian filter - equation from https://en.wikipedia.org/wiki/Gaussian_filter
gaussianFilter = exp(-(initFilter.*initFilter)/(2*sigma*sigma)) / (sqrt(2*pi)*sigma);

% predefined 3*3 Sobel kernel - from https://en.wikipedia.org/wiki/Sobel_operator
sobelFilterX = [[1 0 -1]; [2 0 -2]; [1 0 -1]];
sobelFilterY = rot90(sobelFilterX, -1);

% Gaussian smoothing
% apply two 1D gaussain filter with vertically and horizontally
imgGaussX = myImageFilter(img, gaussianFilter);
imgGaussXY = myImageFilter(imgGaussX, rot90(gaussianFilter));

% Sobel Filtering
imgSobelX = myImageFilter(imgGaussXY, sobelFilterX);
imgSobelY = myImageFilter(imgGaussXY, sobelFilterY);

% sqrt() require double type as parameter
imgSobelX = double(imgSobelX);
imgSobelY = double(imgSobelY);

% Edge Magnitude and Edge Orientation
% lecture pdf uses wrong equation in gradient orientation
imgEdgeMagnitude = sqrt(imgSobelX.*imgSobelX + imgSobelY.*imgSobelY);
imgEdgeOrientation = atan2(imgSobelY, imgSobelX);

% Non-maximal suppression
% O(N^2) with tangent calculation
[ih iw] = size(img);
inverseGradientTangent = 1./tan(imgEdgeOrientation);

% normalization
magnitudeMax = max(max(imgEdgeMagnitude));
if(magnitudeMax~=0)
    imgEdgeMagnitude = imgEdgeMagnitude./magnitudeMax;
end

% interpolation
% A*U**B****C   U=A(i-1,j-1)*p + B(i-1,j)*(1-p)
% ***#*******
% D****E****F   E(i,j)
% *******#***
% G****H**D*I   D=I(i+1,j+1)*p + H(i+1,j)*(1-p)

% sum = 0;
% first and last row, column is not on calculate
% for i = 2 : ih-1
%     for j = 2 : iw-1
%         if(imgEdgeOrientation(i,j) > 0)
%             if(inverseGradientTangent(i,j) > 0)
%                 % tangent > 0 == 0<theta<90
%                 interpolateUpperSide = imgEdgeMagnitude(i-1, j) * (1-inverseGradientTangent(i,j)) + imgEdgeMagnitude(i-1, j+1) * inverseGradientTangent(i,j);
%                 interpolateDownSide = imgEdgeMagnitude(i+1, j) * (1-inverseGradientTangent(i,j)) + imgEdgeMagnitude(i+1, j-1) * inverseGradientTangent(i,j); 
%             else
%                 % tangent < 0 == 90<theta<180
%                 interpolateUpperSide = imgEdgeMagnitude(i-1, j) * (1-inverseGradientTangent(i,j)) + imgEdgeMagnitude(i-1, j-1) * inverseGradientTangent(i,j);
%                 interpolateDownSide = imgEdgeMagnitude(i+1, j) * (1-inverseGradientTangent(i,j)) + imgEdgeMagnitude(i+1, j+1) * inverseGradientTangent(i,j);
%             end
%             
%             % suppress it whenever non-maximum
%             if(imgEdgeMagnitude(i,j) < interpolateDownSide || imgEdgeMagnitude(i,j) < interpolateUpperSide)
%                 imgEdgeMagnitude(i,j) = 0;
%                 sum = sum+1;
%             end
% %         else
% %             imgEdgeOrientation(i,j) = 0;
% %             sum = sum + 1;
%         end
%     end
% end

% below implementation is from matlab edge function

% divide angle as 4 sectors like below figure
% note that y axis is desending, means upper side is minus
% below side is plus
%   O 3 3 X 2 2 0
%   4 O 3 X 2 0 1
%   4 4 O X 0 1 1
%   X X X O X X X
%   1 1 O X O 4 4
%   1 0 2 X 3 0 4
%   0 2 2 X 3 3 0
for i=1:4
    % sector division
    switch i
        case 1
            sector = find((imgSobelY<=0 & imgSobelY>-imgSobelX) | (imgSobelY>=0 & imgSobleY<-imgSobelX));
        case 2
            sector = find((imgSobelX>0 & imgSobelY<=-imgSobelX) | (imgSobelX<0 & imgSobelY>=-imgSobelX));
        case 3
            sector = find((imgSobelX>=0 & imgSobelY>imgSobelX) | (imgSobelX<=0 & imgSobelY<imgSobelX));
        case 4
            sector = find((imgSobelY>0 & imgSobelY<=imgSobelX) | (imgSobelY<0 & imgSobelY>=imgSobelX));
    end
    
    % remove extra pixel
    if ~isempty(sector)
      v = mod(sector, ih);
      extraSector = find(v==1 | v==0 | idx<=ih | (idx>(iw-1)*ih));
      sector(extraSector) = [];
    end

    imgSectorX = imgSobelX(sector);  
    imgSectorY = imgSobelY(sector);   
    gradmag = imgEdgeMagnitude(sector);

    
end

% choose threshold by histogram (use same constant as matlab function)
% get top 30% of histogram as high Thresh (T1)
% low Thresh T2 = T1*0.4
imgHistogram=imhist(img, 64);
highThresh = find(cumsum(imgHistogram) > ih*iw*0.7, 1,'first') / 64
lowThresh = highThresh * 0.4;

% edge hysteresis

% return type of matlab 'edge' function is logical. follow it
% imgEdgeMagnitude = logical(imgEdgeMagnitude);
end
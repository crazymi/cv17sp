function [imgEdgeMagnitude imgEdgeOrientation imgSobelX imgSobelY] =myEdgeFilter(img, sigma)

% decide filterSize 'N' with given standard derivation 'sigma'
filterSize = floor(3*sigma);
initFilter = -filterSize:filterSize;
% 1D gaussian filter
gaussianFilter = exp(-(initFilter.*initFilter)/(2*sigma*sigma)) / (sqrt(2*pi)*sigma);

% predefined 3*3 Sobel kernel
sobelFilterX = [[1 0 -1]; [2 0 -2]; [1 0 -1]];
sobelFilterY = rot90(sobelFilterX);

% Gaussian smoothing
% apply two 1D gaussain filter with vertically and horizontally
imgGaussX = myImageFilter(img, gaussianFilter);
imgGaussXY = myImageFilter(imgGaussX, rot90(gaussianFilter));

% Sobel Filtering
imgSobelX = myImageFilter(imgGaussXY, sobelFilterX);
imgSobelY = myImageFilter(imgGaussXY, sobelFilterY);

% Edge Magnitude and Edge Orientation

% sqrt function require double type as parameter
imgSobelX = double(imgSobelX);
imgSobelY = double(imgSobelY);
imgEdgeMagnitude = sqrt(imgSobelX.*imgSobelX + imgSobelY.*imgSobelY);
imgEdgeOrientation = atan2(imgSobelY, imgSobelX);

% Non-maximal suppression
% O(N^2) with tangent calculation
[ih iw] = size(img);
inverseGradientTangent = 1./tan(imgEdgeOrientation);

% interpolation
% A*U**B****C   U=A(i-1,j-1)*p + B(i-1,j)*(1-p)
% ***#*******
% D****E****F   E(i,j)
% *******#***
% G****H**D*I   D=I(i+1,j+1)*p + H(i+1,j)*(1-p)

for i = 2 : ih-1
    for j = 2 : iw-1
        % ignore zero gradient
        if(imgEdgeOrientation(i,j) ~= 0)
            if(inverseGradientTangent(i,j) > 0)
                % tangent > 0 == 0<theta<90
                interpolateUpperSide = imgEdgeMagnitude(i-1, j) * (1-inverseGradientTangent(i,j)) + imgEdgeMagnitude(i-1, j+1) * inverseGradientTangent(i,j);
                interpolateDownSide = imgEdgeMagnitude(i+1, j) * (1-inverseGradientTangent(i,j)) + imgEdgeMagnitude(i+1, j-1) * inverseGradientTangent(i,j); 
            else
                % tangent < 0 == 90<theta<180
                interpolateUpperSide = imgEdgeMagnitude(i-1, j) * (1-inverseGradientTangent(i,j)) + imgEdgeMagnitude(i-1, j-1) * inverseGradientTangent(i,j);
                interpolateDownSide = imgEdgeMagnitude(i+1, j) * (1-inverseGradientTangent(i,j)) + imgEdgeMagnitude(i+1, j+1) * inverseGradientTangent(i,j);
            end
            
            % suppress it whenever non-maximum
            if(imgEdgeMagnitude(i,j) < interpolateDownSide || imgEdgeMagnitude(i,j) < interpolateUpperSide)
            end
        end
    end
end

% return type of matlab 'edge' function is logical. follow it
imgEdgeMagnitude = logical(imgEdgeMagnitude);
end
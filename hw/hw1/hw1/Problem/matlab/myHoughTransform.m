function [houghSpace] = myHoughTransform(imgEdgeMagnitude, minThreshold, rhoResolution, thetaResolution)
[ih iw] = size(imgEdgeMagnitude);

maxRho = floor(sqrt(ih*ih+iw*iw));
rhoSpace = -maxRho:rhoResolution:maxRho;
thetaSpace = -90:thetaResolution:90;
% to ignore last element 90
thetaSpace = thetaSpace(1:end-1);
houghSpace = zeros(max(size(rhoSpace)), max(size(thetaSpace)));

% precompute sin&cos.
sinPrecompute = zeros(size(thetaSpace));
cosPrecompute = zeros(size(thetaSpace));
idx = 1;
for i=thetaSpace
    sinPrecompute(idx) = sind(i);
    cosPrecompute(idx) = cosd(i);
    idx = idx + 1;
end
    
for i=1:ih
    for j=i:iw
        % thresholding : pixel over minThreshold can possible point on a line
        if(imgEdgeMagnitude(i,j) > minThreshold)
            % loop for thetaSpace, theta is expressed with degree
            for idxTheta = 1:max(size(thetaSpace))
                % note that, i is y, j is x
                currentRho = floor(j*cosPrecompute(idxTheta) + i*sinPrecompute(idxTheta));
                idxRho = floor((currentRho - (-maxRho)) / rhoResolution) + 1;
                % accomulate
                houghSpace(idxRho, idxTheta) = houghSpace(idxRho, idxTheta) + 1;
            end 
        end
    end
end

end

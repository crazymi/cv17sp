% function [lineRho lineTheta peaks] = myHoughLines(houghSpace, rhoResolution, thetaResolution, numberOfLines)
function [peaks] = myHoughLines(houghSpace, rhoResolution, thetaResolution, numberOfLines)
[ih iw] = size(houghSpace);

% matrix peaks : N X 3 matrix
% each column is for 'VOTE Rho Theta'
peaks = zeros(numberOfLines, 3);

% precomputed space
maxRho = (ih-1)*rhoResolution/2;
rhoSpace = -maxRho:rhoResolution:maxRho;
thetaSpace = -90:thetaResolution:90;
thetaSpace = thetaSpace(1:end-1);

% threshold
threshold = 0.5 * max(houghSpace(:));
% peaks : N*3 matrix, each columns : (i j vote)
peaks = [];
% neighborhood 50*50 matrix
% assert size(houghSpace) > (50,50)


% Non-maximal suppression for choose locally maximum value
% check nearby iDiv*jDiv matrix and suppress when non-maximum
for i=1:ih
    for j=1:iw
        % no need for check when VOTE is less than threshold
        if(houghSpace(i,j) >= threshold)
           iLow = max(i-25, 1);
           iHigh = min(i+25, ih);
           jLow = max(j-25, 1);
           jHigh = min(j+25, iw);
           subset = houghSpace([iLow:iHigh], [jLow:jHigh]);
           maxInSubset = max(subset(:));
           if(houghSpace(i,j) == maxInSubset)
               peaks = [peaks; [i j maxInSubset]]; 
           end
        end
    end
end

peaks = sortrows(peaks, 3);
[ph pw] = size(peaks);

end
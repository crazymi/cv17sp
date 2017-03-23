function [lineRho lineTheta peaks] = myHoughLines(houghSpace, rhoResolution, thetaResolution, numberOfLines)
[ih iw] = size(houghSpace);

% matrix peaks : N X 3 matrix
% each column is for 'VOTE Rho Theta'
peaks = zeros(numberOfLines, 3);

% precomputed space
maxRho = (ih-1)*rhoResolution/2;
rhoSpace = -maxRho:rhoResolution:maxRho;
thetaSpace = -90:thetaResolution:90;
thetaSpace = thetaSpace(1:end-1);

% Non-maximal suppression for choose locally maximum value
% check nearby iDiv*jDiv matrix and suppress when non-maximum
for i=1:ih
    for j=1:iw
        % no need for check when VOTE is 0
        if(houghSpace(i,j) ~= 0)
            
        end
    end
end

lineRho = peaks(:, 2);
lineTheta = peaks(:, 3);

end
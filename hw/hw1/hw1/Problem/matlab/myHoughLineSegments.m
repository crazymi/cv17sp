function [lines] = myHoughLineSegments(lineRho, lineTheta, imgEdgeMagnitude, minThreshold)

[ih iw] = size(imgEdgeMagnitude);

xIdx = 1:iw;

lines.start = [1,1];
lines.end = [1,1];

for i=1:size(lineRho,1)
    yIdx = floor((lineRho(i)-xIdx*cosd(lineTheta(i)))/sind(lineTheta(i)));
    xyIdx = [xIdx; yIdx];
    % precomputed vector which contains square distance from (0,0)
    squareOfDiffence = diff(xyIdx,1,1).^2;
    
   x0 = [1, floor((lineRho(i)-cosd(lineTheta(i)))/sind(lineTheta(i)))];
   y0 = [floor((lineRho(i)-sind(lineTheta(i)))/cosd(lineTheta(i))), 1];
   if(x0(2) > 0 && x0(2) <= iw)
       line(i).start = x0;
   else
       line(i).start = y0;
   end
   
   xm = [iw, floor((lineRho(i)-iw*cosd(lineTheta(i)))/sind(lineTheta(i)))];
   ym = [floor((lineRho(i)-ih*sind(lineTheta(i)))/cosd(lineTheta(i))), ih];
   if(xm(2) > 0 && xm(2) <= iw)
       line(i).end = xm;
   else
       line(i).end = ym;
   end
   
   if(x0(2) < 1 && x0(2) > iw && y0(2) < 1 && y0(2) > ih)
       line(i).start = xm;
       line(i).end = ym;
   end
   
   if(xm(2) < 1 && xm(2) > iw && ym(2) < 1 && ym(2) > ih)
       line(i).start = x0;
       line(i).end = y0;
   end
    
%     maximumDistance = -1;
%     startDistance = 0;
%     tmp = 1;
%     
%     for j=1:iw
%         if(yIdx(j) > 0 && yIdx(j)<=ih)
%             lines(i).start = [j,yIdx(j)];
%             lines(i).end = [1,1];
%             if(imgEdgeMagnitude(yIdx(j), j) > 0)
%                 if((squareOfDiffence(j) - startDistance) > maximumDistance)
%                     lines(i).end = [j, yIdx(j)];
%                     lines(i).start = [tmp, yIdx(tmp)];
%                 end
%             else
%                 startDistance = squareOfDiffence(j);
%                 tmp = j;
%             end
%         end
%     end
end

end

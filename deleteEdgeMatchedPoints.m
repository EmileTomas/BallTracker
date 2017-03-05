function [ matchedPointsLocation1,matchedPointsLocation2 ] = deleteEdgeMatchedPoints(matchedPointsInfo1,matchedPointsInfo2,ratio);
%This function is used to delete the matched point pairs exceed
%radius*ratio from the center.
%   The target is to delete those points pairs that not belong to the
%   feature of the Ping-Pong ball (because our program choose to detect
%   feature of ball from a rectangle) or the pairs gets too close to the
%   edge which will makes the match error become much more serious then the
%   situation that the pairs are located in the center part. 
%
%   return:
%   return [] if there is point left in matchedPointsLocation1 and
%   matchedPointsLocation2
if(size(matchedPointsInfo1{1},1)==0)
    matchedPointsLocation1=[];
    matchedPointsLocation2=[];
    return
end

matchedPointsLocation1=matchedPointsInfo1{1};
matchedPointsLocation2=matchedPointsInfo2{1};
center1=matchedPointsInfo1{2}(1:2);
center2=matchedPointsInfo2{2}(1:2);
radius1=matchedPointsInfo1{2}(3);
radius2=matchedPointsInfo2{2}(3);

tmp=matchedPointsLocation1-center1;
tmp=sqrt(tmp(:,1).^2+tmp(:,2).^2);
deletedIndex1=~(tmp<radius1*ratio);


tmp=matchedPointsLocation2-center2;
tmp=sqrt(tmp(:,1).^2+tmp(:,2).^2);
deletedIndex2=~(tmp<radius2*ratio);

deletedIndex=deletedIndex1|deletedIndex2;
matchedPointsLocation1(deletedIndex,:)=[];
matchedPointsLocation2(deletedIndex,:)=[];

end


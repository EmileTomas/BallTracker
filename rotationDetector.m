function [axis,theta,solve_flag]=rotationDetector(frame1,frame2,centerInfo1,centerInfo2)
 axis=[];
 theta=[];
 solve_flag=0;
 
 center1=centerInfo1(1:2);
 center2=centerInfo2(1:2);
 radius1=centerInfo1(3);
 radius2=centerInfo2(3);
 frame1_gray=rgb2gray(frame1);
 frame2_gray=rgb2gray(frame2);
 ROI1=getDetectArea(center1,radius1);
 ROI2=getDetectArea(center2,radius2);
 
 frame1_points=detectSURFFeatures(frame1_gray,'ROI',ROI1);
 frame2_points=detectSURFFeatures(frame2_gray,'ROI',ROI2);
 [frame1_features,frame1_valid_points]=extractFeatures(frame1_gray,frame1_points);
 [frame2_features,frame2_valid_points]=extractFeatures(frame2_gray,frame2_points);
 indexPairs=matchFeatures(frame1_features,frame2_features);
 
 matchedPoints1=frame1_valid_points(indexPairs(:,1));
 matchedPoints2=frame2_valid_points(indexPairs(:,2));
 matchedPointsLocation1=matchedPoints1.Location;
  matchedPointsLocation2=matchedPoints2.Location;
 if(size(matchedPointsLocation1,1)~=0)
     %delete those matched points exceed the ball edge
    tmp=matchedPointsLocation1-center1;
    tmp=sqrt(tmp(:,1).^2+tmp(:,2).^2);
    tmp=tmp<radius1;
    tmp=find(~tmp);
    matchedPointsLocation1(tmp,:)=[];

    tmp=matchedPointsLocation2-center2;
    tmp=sqrt(tmp(:,1).^2+tmp(:,2).^2);
    tmp=tmp<radius2;
    tmp=find(~tmp);
    matchedPointsLocation2(tmp,:)=[];
    

    if(size(matchedPointsLocation1,1)>=3)
        solve_flag=1;
        data1=getSpaceCoordinate(matchedPointsLocation1,center1,radius1);
        data2=getSpaceCoordinate(matchedPointsLocation2,center2,radius2);
        data2=data2/(radius2/radius1);
        [axis,theta]=getRotationInfoCross(data1,data2,radius1);
    end
 end

end

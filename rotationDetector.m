function [axis,theta]=rotationDetector(frame1,frame2,circleInfo1,circleInfo2)
 axis=[];
 theta=[];
 
 center1=circleInfo1(1:2);
 center2=circleInfo2(1:2);
 radius1=circleInfo1(3);
 radius2=circleInfo2(3);
 frame1_gray=rgb2gray(frame1);
 frame2_gray=rgb2gray(frame2);
 ROI1=getDetectArea(center1,radius1);
 ROI2=getDetectArea(center2,radius2);
 
 frame1_points=detectSURFFeatures(frame1_gray,'ROI',ROI1,'MetricThreshold',1200);
 frame2_points=detectSURFFeatures(frame2_gray,'ROI',ROI2,'MetricThreshold',1200);

 [frame1_features,frame1_valid_points]=extractFeatures(frame1_gray,frame1_points);
 [frame2_features,frame2_valid_points]=extractFeatures(frame2_gray,frame2_points);
 [indexPairs,weight_metrics]=matchFeatures(frame1_features,frame2_features);
 
 
 matchedPoints1=frame1_valid_points(indexPairs(:,1));
 matchedPoints2=frame2_valid_points(indexPairs(:,2));
 
 matchedPointsLocation1=matchedPoints1.Location;
 matchedPointsLocation2=matchedPoints2.Location;
 matchedPointsInfo1={matchedPointsLocation1,circleInfo1};
 matchedPointsInfo2={matchedPointsLocation2,circleInfo2};
 
 global DELETE_RATIO;
 [processedPointsLocation1,processedPointsLocation2]=deleteEdgeMatchedPoints(matchedPointsInfo1,matchedPointsInfo2,DELETE_RATIO);
    
 if(size(processedPointsLocation1,1)>=3)
     data1=getSpaceCoordinate(processedPointsLocation1,circleInfo1);
     data2=getSpaceCoordinate(processedPointsLocation2,circleInfo2);
     data2=data2/(radius2/radius1);
     [axis,theta]=getRotationInfoCross(data1,data2,radius1);
  end

end

function [ axis,theta] = getRotationInfoCross( pointSetBefore,pointSetAfter,radius )
%GETROTATIONINFOCROSS This function is the updated version of the
%getRotationInfo.m. In this Function, we use all the information provided
%by the SURF matched point sets, and use mathematic statistics to find the
%most proper predicted rotate speed and corresponding axis, which includes, 
%eliminate those point too large and too small(close to
% zero), then find the most possible interval to present the result.
%
% Updated:
%       if the size of point set is too large, program will eliminate the
%       extra part. (20 at most by default)
%
global dimensionIndex;
global INPUT_FPS;

[axisDistrubution,thetaDistrubution]=getRotateInfoDistrubution(pointSetBefore,pointSetAfter);
theta=findFittingValue(thetaDistrubution, 0.2*2*pi/INPUT_FPS);
axis_x=findFittingValue(axisDistrubution(:,1),0.05);
axis_y=findFittingValue(axisDistrubution(:,2),0.05);
axis_z=findFittingValue(axisDistrubution(:,3),0.05);
axis=[axis_x,axis_y,axis_z];

dimensionIndex(size(dimensionIndex,2)+1)=size(pointSetBefore,2);
end


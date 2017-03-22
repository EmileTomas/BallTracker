function [ axis,theta ] = getRotationInfo( pointSetBefore,pointSetAfter,radius)
%GETROTATIONINFO This function is used to get the rotation information from
%two point set.
%  Although the calculation below seems very simple, but the mathematics
%  behind the formulas is complicated. 

featureMat=pointSetAfter(:,1:3)/pointSetBefore(:,1:3);

cosTheta=(trace(featureMat)-1)/2;
theta=acos(cosTheta);
[x,y,z]=getAxis(featureMat);
axis=[x y z];
end


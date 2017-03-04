function [ axis,theta ] = getRotationInfo( pointSetBefore,pointSetAfter,radius)
%GETROTATIONINFO This function is used to get the rotation information from
%two point set.
%  Although the calculation below seems very simple, but the mathematics
%  behind the formulas is complicated. 

featureMat=pointSetAfter(:,1:3)/pointSetBefore(:,1:3);
cosTheta=(trace(featureMat)-1)/2;
x=radius*sqrt((featureMat(1,1)-cosTheta)/(1-cosTheta));
y=radius*sqrt((featureMat(2,2)-cosTheta)/(1-cosTheta));
z=radius*sqrt((featureMat(3,3)-cosTheta)/(1-cosTheta));
theta=acos(cosTheta);

axis=[x y z];
end


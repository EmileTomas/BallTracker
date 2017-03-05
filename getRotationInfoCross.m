function [ predictedAxis,predictedTheta] = getRotationInfoCross( pointSetBefore,pointSetAfter,radius )
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

predictedAxis=[];
predictedTheta=[];

global INPUT_FPS;
pointSetSize=size(pointSetBefore,2);
if(pointSetSize>20)
    pointSetSize=20;
end

combinationNum=getNumOfCombination(pointSetSize,3);
theta=zeros(1,combinationNum);
axis=cell(1,combinationNum);

index=1;
for i =1:pointSetSize
    for j=i+1:pointSetSize
        for k=j+1:pointSetSize
            [axis{index},theta(index)]=getRotationInfo(pointSetBefore(:,[i,j,k]),pointSetAfter(:,[i,j,k]),radius);
            index=index+1;
        end
    end
end

%remove theta with image part
indexOfComplex=~~imag(theta);
theta(indexOfComplex)=[];
axis(indexOfComplex)=[];

%Check if theta is removed
if(isempty(theta)) 
    return
end

BIN_WIDTH=0.2;
rotateSpeed=theta/2/pi*INPUT_FPS;
[frequencyList,edges]=histcounts(rotateSpeed,'BinWidth',BIN_WIDTH);
[frequency,max_pos]=max(frequencyList);

count=0;
theta_sum=0;
axis_sum=[0,0,0];
UPPER_BOUND=edges(max_pos)+BIN_WIDTH;
LOWER_BOUND=edges(max_pos);
for i =1:size(theta,2)
    if(rotateSpeed(i)<UPPER_BOUND&&rotateSpeed(i)>LOWER_BOUND)
        count=count+1;
        theta_sum=theta_sum+theta(i);
        axis_sum=axis_sum+axis{i};
    end
end

predictedTheta=theta_sum/count;
predictedAxis=axis_sum/count;
dimensionIndex(size(dimensionIndex,2)+1)=pointSetSize;
end


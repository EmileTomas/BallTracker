function [ axis,theta ] = getRotateInfoDistrubution( pointSetBefore,pointSetAfter)

pointSetSize=size(pointSetBefore,2);
if(pointSetSize>20)
    pointSetSize=20;
end
combinationNum=getNumOfCombination(pointSetSize,3);

theta=zeros(combinationNum,1);
axis=zeros(combinationNum,3);
index=1;
for i =1:pointSetSize
    for j=i+1:pointSetSize
        for k=j+1:pointSetSize
            featureMat=pointSetAfter(:,[i,j,k])/pointSetBefore(:,[i,j,k]);
            [axis(index,:),theta(index)]=extractFeatureMat(featureMat);
            index=index+1;
        end
    end
end

end


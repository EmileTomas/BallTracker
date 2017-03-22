function [ fittingResult ] = findFittingValue( dataSet,bin_width)
% This function can find the most proper value from a set of data by
% removing the noise

[frequencyList,edges]=histcounts(dataSet,'BinWidth',bin_width);
[frequency,max_pos]=max(frequencyList);

count=0;
sum=0;
UPPER_BOUND=edges(max_pos)+bin_width;
LOWER_BOUND=edges(max_pos);
for i =1:size(dataSet,1)
    if(dataSet(i)<UPPER_BOUND&&dataSet(i)>LOWER_BOUND)
        count=count+1;
        sum=sum+dataSet(i);
    end
end

fittingResult=sum/count;

end


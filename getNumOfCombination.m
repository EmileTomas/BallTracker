function [ numOfCombination ] = getNumOfCombination(m,n )
% This is a function used to calculate C(m,n). In consideration of using factorial()
% will transfer the result to float number, we makes the result more
% reliable.
if(m<n) 
    numOfCombination=[];
    return 
end
numerator=1;
denominator=1;
for i=1:n
    numerator=numerator*m;
    denominator=denominator*i;
    m=m-1;
end
numOfCombination=numerator/denominator;
end


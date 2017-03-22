function [axis,theta]=extractFeatureMat(featureMat)
% m is the feature rotation matrix of size 3X3 
k0=featureMat(3,2)-featureMat(2,3);
k1=featureMat(1,3)-featureMat(3,1);
k2=featureMat(2,1)-featureMat(1,2);
root=sqrt(k0^2+k1^2+k2^2);

%get axis info
axis=[k0/root,k1/root,k2/root];

%get theta info, here we add a error range to tolerate 
if (root/2>1.1) theta=0;
elseif (root/2<=1.1 && root/2>=1) 
        theta=asin(1);
else
        theta=asin(root/2);
end    

end

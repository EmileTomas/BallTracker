function [ pointSetAfter] = triDRotate( pointSet,axis,theta)
%TRIDROTATE: This function is aimed to rotate a point set around an axis
%with a specific theta angle, and give corresponding point set location
%   Please add some args format here  
%
x0=axis(1);
y0=axis(2);
z0=axis(3);

a=x0/sqrt(x0^2+y0^2+z0^2);
b=y0/sqrt(x0^2+y0^2+z0^2);
c=z0/sqrt(x0^2+y0^2+z0^2);
d=sqrt(y0^2+z0^2)/sqrt(x0^2+y0^2+z0^2);
Rx=[1       0       0       0; 
        0   c/d     -b/d     0; 
        0   b/d     c/d     0; 
        0       0       0      1];
Ry=[d   0   -a  0;
        0   1   0   0;
        a   0   d   0;
        0   0   0   1];
Rz=[cos(theta)  -sin(theta) 0   0;
        sin(theta)  cos(theta)  0   0;
        0               0               1     0;
        0               0               0     1];
    
R=inv(Rx)*inv(Ry)*Rz*Ry*Rx;

pointSetAfter=R*pointSet;

end


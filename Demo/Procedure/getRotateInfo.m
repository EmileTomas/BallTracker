function F = getRotateInfo( x, srcPointSet,targetPointSet,radius)
%GETROTATEINFO: this function is aimed to get the axis and rotate angle
%from the original pointSet and target pointSet.
%   Usage:[x0 y0 theta]=fsolve(@(x)getRotateInfo(x,data1,data2,radius),x0
%   z0=sqrt(radius^2-x0^2-y0^2);
%   please add the args format here 

x0=x(1);
y0=x(2);
theta=x(3);

z0=sqrt(radius^2-x0^2-y0^2);

a=x0/radius;
b=y0/radius;
c=z0/radius;
d=sqrt(y0^2+z0^2)/radius;

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
    
F=inv(Rx)*inv(Ry)*Rz*Ry*Rx*srcPointSet-targetPointSet;

end
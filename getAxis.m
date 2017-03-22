function [x,y,z]=getK(m)

k0=m(3,2)-m(2,3);
k1=m(1,3)-m(3,1);
k2=m(2,1)-m(1,2);
root=sqrt(k0^2+k1^2+k2^2);

x=k0/root;
y=k1/root;
z=k2/root;

end

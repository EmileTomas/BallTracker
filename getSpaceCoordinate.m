function tri_dimension_points=getSpaceCoordinate(input_points,circleInfo)
center=circleInfo(1:2);
radius=circleInfo(3);
O_x=center(1);
O_y=center(2);
tri_dimension_points=zeros(3,size(input_points,1));
for i=1:size(input_points,1)
    P_x=input_points(i,1);
    P_y=input_points(i,2);
    
    tri_dimension_points(1,i)=P_x-O_x;
    tri_dimension_points(2,i)=P_y-O_y;
    tri_dimension_points(3,i)=sqrt(radius^2-tri_dimension_points(1,i)^2-tri_dimension_points(2,i)^2);
end

    
    
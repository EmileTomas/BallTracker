function [center_out, radius_out, find_ball_flag_out]=ballDetector(frame,radius_in,find_ball_flag_in)
% Here the program can check the validity of the circle we find from
% more aspect, for example: if the center and its around color are
% almost white. etc
% The variable radius_range, should big enough to make sure the system is
% able to detect ball wherever the ball enter the camera and what's its
% size. But there is also a possible solution is to write a specialized
% system to detect the ball.
        
if(~find_ball_flag_in)
        % find the ball from whole frame
        radius_range=[30,130];
    else
        % find the ball form cropped frame
        radius_range=[int16(radius_in)-20,int16(radius_in)+20];
    end

    [centers,radius,metrics]=imfindcircles(frame,radius_range,'Sensitivity',0.9);
    
    if(size(centers,1)~=0)
            center_out=centers(1,:);
            radius_out=radius(1);
            find_ball_flag_out=1;
    else
            center_out=[];
            radius_out=[];
            find_ball_flag_out=0;
    end
  
end

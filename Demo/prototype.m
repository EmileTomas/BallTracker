%  Args list for the feature GUI setting:
%  VideoPath:
%       For the best case, there should be one GUI, leaving it as interface
%  
%  TARGET_FRAME_SIZE:
%       The input frame may be very large like 1920x1080, there might be no
%       need for us using such a video frame, which will extremely slow
%       down the Ball Detector before it detected ball at the first time. A
%       small size of frame make this procedure much faster.
clc;
clear;

% Preset parameters
VIDEO_PATH='C:\Users\Administrator\Desktop\Ball\½»´ó\6.mp4';
TARGET_FRAME_SIZE=[360 640];
FPS_INFO_POSITION=[0 0];
RADIUS_INFO_POS=[0,25];
CENTER_INFO_POS=[1,50];
center=zeros(1,2);
radius=0;
find_ball_flag=0;

videoObj=VideoReader(VIDEO_PATH);
videoPlayer=vision.VideoPlayer('Position',[500 500 600 600]);
while hasFrame(videoObj)
    
    tic;
    frame=imresize(readFrame(videoObj), TARGET_FRAME_SIZE);
    %   if doesn't find ball yet, find it globally,
    %   else crop the picture according information before to speed up
    %   procedure
    if(~find_ball_flag)
        [center,radius,find_ball_flag_this_frame]=ballDetector(frame,radius,find_ball_flag);
    else
        rectangle=getDetectArea(center,radius);
        cropped_frame=imcrop(frame,rectangle);
        [center,radius,find_ball_flag_this_frame]=ballDetector(cropped_frame,radius,find_ball_flag);
    end
    elapsedTime=toc;
    
    %---------------------- Insert information----------------------%
    %Insert detected ball edge
    if(find_ball_flag_this_frame)
        if(find_ball_flag)
            center=center+rectangle(1:2);
        end
        frame=insertShape(frame,'circle',[center radius]);
    end
    %Insert FPS
    FPS_text=['FPS: ',num2str(1/elapsedTime,'%0.1f')];
    frame=insertText(frame,FPS_INFO_POSITION,FPS_text);
    %insert ball information
    if(find_ball_flag_this_frame)
        radius_text=['Radius: ',num2str(radius,'%0.1f')];
        center_text=['Center: ',num2str(center(1),'%0.1f'),',',num2str(center(2),'%0.1f')];
        frame=insertText(frame,RADIUS_INFO_POS,radius_text);
        frame=insertText(frame,CENTER_INFO_POS,center_text);
    end
    
    find_ball_flag=find_ball_flag_this_frame;
    videoPlayer(frame);
end

release(videoObj);
release(videoPlayer);
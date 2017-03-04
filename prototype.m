%  Args list for the feature GUI setting:
%  VideoPath:
%       For the best case, there should be one GUI, leaving it as interface
%  
%  TARGET_FRAME_SIZE:
%       The input frame may be very large like 1920x1080, there might be no
%       need for us using such a video frame, which will extremely slow
%       down the Ball Detector before it detected ball at the first time. A
%       small size of frame make this procedure much faster.
%
% Please delete dimensionIndex in the next few version, it's just for
% testing.So does detectedTimestamp
% dimensionIndex record the dimension of point set
% detectedTimestamp record the time in the video the rotation information is detected.
clc;
clear;

RotateSpeed=[];
detectedTimestamp=[];
% Preset parameters
global INPUT_FPS;
global dimensionIndex;
dimensionIndex=[];
VIDEO_PATH='C:\Users\Administrator\Desktop\Ball\½»´ó\5.mp4';
TARGET_FRAME_SIZE=[720 1280];
FPS_INFO_POSITION=[0 0];
RADIUS_INFO_POS=[0,25];
CENTER_INFO_POS=[0,50];
ROTATE_INFO_POS=[0,75];
center=zeros(1,2);
radius=0;
find_ball_flag=0;
frame_count=0;
last_frame=[];
last_frame_center=[];
last_frame_radius=0;

videoObj=VideoReader(VIDEO_PATH);
INPUT_FPS=videoObj.FrameRate;
videoPlayer=vision.VideoPlayer('Position',[500 500 600 600]);
while hasFrame(videoObj)
    tic;
    
    frame=imresize(readFrame(videoObj), TARGET_FRAME_SIZE);
    frame_count=frame_count+1;
    %   if doesn't find ball yet, find it globally,
    %   else crop the picture according information before to speed up
    %   procedure
    if(~find_ball_flag)
        [center,radius,find_ball_flag_this_frame]=ballDetector(frame,radius,find_ball_flag);
    else
        rectangle=getDetectArea(center,radius);
        cropped_frame=imcrop(frame,rectangle);
        [cropped_center,radius,find_ball_flag_this_frame]=ballDetector(cropped_frame,radius,find_ball_flag);
        if(find_ball_flag_this_frame) 
            center=cropped_center+rectangle(1:2);
        end
    end
    
    if(frame_count~=1 && find_ball_flag && find_ball_flag_this_frame)
        last_frame_center_info=[last_frame_center,last_frame_radius];
        center_info=[center,radius];
        [axis,theta]=rotationDetector(last_frame,frame,last_frame_center_info,center_info);
    else
        axis=[];
        theta=[];
    end
    
    elapsedTime=toc;
    last_frame=frame;
    last_frame_center=center;
    last_frame_radius=radius;
    find_ball_flag=find_ball_flag_this_frame;
 
    %---------------------- Insert extra information and display----------------------%
    %Insert FPS
    FPS_text=['FPS: ',num2str(1/elapsedTime,'%0.1f')];
    frame=insertText(frame,FPS_INFO_POSITION,FPS_text);
    
    %insert ball information
    if(find_ball_flag_this_frame)
        radius_text=['Radius: ',num2str(radius,'%0.1f')];
        center_text=['Center: ',num2str(center(1),'%0.1f'),',',num2str(center(2),'%0.1f')];
        frame=insertText(frame,RADIUS_INFO_POS,radius_text);
        frame=insertText(frame,CENTER_INFO_POS,center_text);
        frame=insertShape(frame,'circle',[center radius]);
    end
    if(~isempty(theta))
        rotate_text=['Rotation Speed:',num2str(theta/2/pi*INPUT_FPS,'%0.1f')];
        RotateSpeed(size(RotateSpeed,2)+1)=theta/pi/2*INPUT_FPS;
        detectedTimestamp(size(detectedTimestamp,2)+1)=frame_count/INPUT_FPS;
        frame=insertText(frame,ROTATE_INFO_POS,rotate_text);
    end
    videoPlayer(frame);
end

release(videoPlayer);
rotateInfoFilter=dimensionIndex>5;
scatter(detectedTimestamp(rotateInfoFilter),RotateSpeed(rotateInfoFilter));
xlabel('Time(s)');
ylabel('Rotation Speed(r)');
title('Rotation Info/Time');

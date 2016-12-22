clc;
clear;
%Read Video file
  videoObj=VideoReader('/home/emile/Documents/Github/Ping_Pong/720p.mp4');
  videoHeight=videoObj.Height;
  videoWidth=videoObj.Width;
%Set VideoPlayer
  videoPlayer=vision.VideoPlayer('Position',[100 100 videoWidth videoHeight]);

%Read frames
k=1;
RADIUS_RANGE=[20 40];
TARGET_FRAME_SIZE=[180 320];
FPS_position=[0 0];
find_ball=0;
x_min=0;
y_min=0;
while hasFrame(videoObj)
    tic;  %begin count time
    frame=imresize(readFrame(videoObj), TARGET_FRAME_SIZE);

    if(~find_ball)
      [centers,radius]=imfindcircles(frame,RADIUS_RANGE,'Sensitivity',0.90,'ObjectPolarity' ,'bright');
      if(exist('radius','var'))
        find_ball=1;
        ORIGIN_CENTER=centers;
        RADIUS=radius;
      end
    else
      %resize the picture according the data of find
      x_min=ORIGIN_CENTER(1)-RADIUS*1.3;
      y_min=ORIGIN_CENTER(2)-RADIUS*1.3;
      rectangle=[x_min, y_min, RADIUS*3,RADIUS*3];
      frame_part=imcrop(frame,rectangle);
     
      [centers,radius]=imfindcircles(frame_part,RADIUS_RANGE,'Sensitivity',0.95,'ObjectPolarity' ,'bright');
    end
    elapsedTime=toc;
    centers(1,1)=centers(1,1)+x_min;
    centers(1,2)=centers(1,2)+y_min;
    frame=insertShape(frame,'circle',[centers radius]);
    frame=insertText(frame,FPS_position,1/elapsedTime);
    videoPlayer(frame);
    k=k+1;  
end


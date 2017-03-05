function detectArea=getDetectArea(center,radius)
    % This is a util function for the main body
     RATIO=1.2;

     if(center(1)-radius*RATIO>=0)
         detect_x_min=center(1)-radius*RATIO;
     else
         detect_x_min=0;
     end

     if(center(2)-radius*RATIO>=0)
         detect_y_min=center(2)-radius*RATIO;
     else
         detect_y_min=0;
     end

     detectArea=[detect_x_min, detect_y_min, radius*RATIO*2,radius*RATIO*2];
end

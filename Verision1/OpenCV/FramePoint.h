//
// Created by emile on 11/26/16.
//

#ifndef OPENCV_FRAMEPOINT_H
#define OPENCV_FRAMEPOINT_H

#include <opencv2/core/core.hpp>
using namespace cv;
class FramePoint {
private:
    Point p1;
    Point center;
    int frame_num;
public:
    FramePoint(Point p1,Point center,int frame_num){
        this->p1=p1;
        this->center=center;
        this->frame_num=frame_num;
    }
    FramePoint(){
    }

    Point getCenter(){
        return center;
    }
    Point getPoint(){
        return p1;
    }

    int getFrame_num(){
        return frame_num;
    }

};


#endif //OPENCV_FRAMEPOINT_H

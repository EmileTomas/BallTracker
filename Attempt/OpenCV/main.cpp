#include <cmath>
#include <iostream>

#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/cudaimgproc.hpp>
#include "SourceCode/hough.cpp"
#include "FramePoint.h"

using namespace std;
using namespace cv;
#define PI 3.14159265

Point getMarkCenter(Mat frame,vector<Vec3f> circles);
double pointDistance(Point p1,Point p2);
double calRotateSpeed(FramePoint fp1,FramePoint fp2,double radius,double frameRate);

void initial_widgets(){
    namedWindow( "circles",0);
    namedWindow("Canny",0);
    namedWindow("detect_part",0);
    namedWindow("Mark",0);
}
const int THRESHOLD=60;


int main(int argc, char** argv)
{
    VideoCapture cap("/home/emile/Documents/Github/Ping_Pong/test.mp4");
    initial_widgets();

    bool key_pressed=true;
    bool find_circle=false;
    bool find_suitable_mark_position=false;
    Point center;
    FramePoint suitable_mark,second_mark;
    int radius=0;
    double frame_rates=cap.get(CV_CAP_PROP_FPS), rotate_rate;
    Mat frame, gray,canny,detect_frame;
    long frame_count=0; //Use this to count
    Rect rect;
    vector<Vec3f> circles;

    while(key_pressed){
        if(!cap.read(frame))
            cout<<"Error";
        frame_count++;


        if(find_circle){
            detect_frame=frame(rect);
            imshow("detect_part",detect_frame);
            cvtColor(detect_frame, gray, CV_BGR2GRAY);
            GaussianBlur( gray, gray, Size(9, 9), 2, 2 );
            Canny(gray,canny,THRESHOLD/2,THRESHOLD);
            imshow("Canny",canny);

            //the position is in the detect_frame;
            Point mark_position=getMarkCenter(detect_frame,circles);
            Point detect_frame_center(radius*1.4,radius*1.4);
            if(!find_suitable_mark_position&&pointDistance(mark_position,detect_frame_center)<=radius*0.5){
                find_suitable_mark_position=true;
                suitable_mark=FramePoint(mark_position,detect_frame_center,frame_count);
            }
            if(find_suitable_mark_position&&pointDistance(suitable_mark.getPoint(),mark_position)>=radius*0.3){
                second_mark=FramePoint(mark_position,detect_frame_center,frame_count);
                rotate_rate=calRotateSpeed(suitable_mark,second_mark,radius,frame_rates);
                find_suitable_mark_position=false;

            }

            Point botton_left=Point(40,40);
            putText(frame,to_string(rotate_rate),botton_left,CV_FONT_HERSHEY_COMPLEX, 1, Scalar(255, 0, 0) );


            self::HoughCircles(gray, circles, CV_HOUGH_GRADIENT, 2, gray.rows/4,THRESHOLD, 70 ,40);

            if(circles.size()>0){
                circles[0][0]+=rect.x;
                circles[0][1]+=rect.y;
            }

        }
        else{
            cvtColor(frame, gray, CV_BGR2GRAY);
            // smooth it, otherwise a lot of false circles may be detected
            GaussianBlur( gray, gray, Size(9, 9), 2, 2 );
            Canny(gray,canny,THRESHOLD/2,THRESHOLD);
            //imshow("Canny",canny);
            self::HoughCircles(gray, circles, CV_HOUGH_GRADIENT, 2, gray.rows/4,THRESHOLD, 120,30);

        }

        //HoughCircles(gray, circles, CV_HOUGH_GRADIENT, 2, gray.rows/4,THRESHOLD, 80);





        for( size_t i = 0; i < circles.size(); i++ )
        {
            center=Point(cvRound(circles[i][0]), cvRound(circles[i][1]));
            radius = cvRound(circles[i][2]);
            // draw the circle center
            circle( frame, center, 3, Scalar(0,255,0), -1, 8, 0 );
            // draw the circle outline
            circle( frame, center, radius, Scalar(0,0,255), 3, 8, 0 );
            Point left_below(circles[0][0]-radius*1.3,circles[0][1]-radius*1.3);
            Point right_up(circles[0][0]+radius*1.3,circles[0][1]+radius*1.3);
            rect.x=circles[0][0]-radius*1.4;
            rect.y=circles[0][1]-radius*1.4;
            rect.height=rect.width=radius*2.8;
        }

        if(circles.size()==1)
            find_circle= true;
        else
            find_circle=false;

        imshow( "circles", frame );
        if(char(waitKey(30))=='q')
            key_pressed= false;
    }
    return 0;

}

Point getMarkCenter(Mat frame,vector<Vec3f> circles){
    Mat frame_threshold_red,frame_threshold_black;

    inRange(frame,Scalar(0,0,0), Scalar(50,50,255),frame_threshold_red);
    inRange(frame,Scalar(0,0,0), Scalar(50,50,50),frame_threshold_black);
    addWeighted(frame_threshold_black,1,frame_threshold_red,1,0.,frame_threshold_black);

    int nr=frame_threshold_black.rows;
    int nc=frame_threshold_black.cols;

    int radius=cvRound(circles[0][2]);
    int center_x=radius*1.4;
    int center_y=center_x;

    long x_sum=0,y_sum=0;
    int point_found=0;
    for(int j=0;j<nr;++j){
        uchar* data=frame_threshold_black.ptr<uchar>(j);
        for(int i=0;i<nc;++i) {
            if(data[i]==255&&(radius*0.4<i&&i<radius*2.4)&&(radius*0.4<j&&j<radius*2.4)){
                x_sum+=i;
                y_sum+=j;
                ++point_found;
            }
        }
    }
    Point center(0,0);
    if(point_found!=0){
        center.x=x_sum/point_found;
        center.y=y_sum/point_found;
    }
    circle( frame_threshold_black, center, 3, Scalar(0,255,0), -1, 8, 0 );
    imshow("Mark",frame_threshold_black);
    return center;
}

double calRotateSpeed(FramePoint fp1,FramePoint fp2,double radius,double frameRate){
    /*Suppose in the different frame, the view from the highspeed camera has little change, and in this
     * way, in fact we needn't two center in the two frame, but considring the experiment is base on
     * normal video, so we take this into consideration.
    */
    Vec3i v1,v2;
    Point p1=fp1.getPoint(),p2=fp2.getPoint();
    Point center1=fp1.getCenter(),center2=fp2.getCenter();

    //Vector of ball center to p1 and p2
    v1[1]=p1.x-center1.x;
    v1[2]=p1.y-center1.y;
    v1[0]=int(sqrt(radius*radius-v1[1]*v1[1]-v1[2]*v1[2]));

    v2[1]=p2.x-center2.x;
    v2[2]=p2.y-center2.y;
    v2[0]=int(sqrt(radius*radius-v2[1]*v2[1]-v2[2]*v2[2]));

    //the calulate the included angle;
    double theta=acos((v1[0]*v2[0]+v1[1]*v2[1]+v1[2]*v2[2])/(radius*radius))/2/PI;
    double rotateSpeed=theta/((fp2.getFrame_num()-fp1.getFrame_num())/frameRate);
    return rotateSpeed;
}

double pointDistance(Point p1,Point p2){
    double distance=sqrt((p2.x-p1.x)*(p2.x-p1.x)+(p2.y-p1.y)*(p2.y-p1.y));
    return distance;
}
    /*VideoCapture cap("/home/emile/Documents/Github/Ping_Pong/test.mp4");
    if(!cap.isOpened()){
        return -1;
    }

    namedWindow( "circles", 1 );
    Mat frame,gray_frame,detect_frame;


    Ptr<cuda::HoughCirclesDetector> hough=cuda::createHoughCirclesDetector(1,30,150,100,40,80,1);   //150 这个参数越低 检测出效果越好
    vector<Vec3f> circles;
    cuda::GpuMat image_gpu,g_circles;
    int frame_num=0;
    bool key_pressed=false;
    float frameList[500];
    int radiu=0;
    int find_num=0;
    float begin;
    while(!key_pressed){
        if(!cap.read(frame))
            break;
        ++frame_num;
        detect_frame=frame;
        cvtColor(detect_frame,gray_frame,CV_RGB2GRAY);

        begin=getTickCount();
        image_gpu.upload(gray_frame);
        hough->detect(image_gpu,g_circles);

        //Show circles;
        if(!g_circles.empty()){
            ++find_num;
            circles.resize(g_circles.cols);
            Mat h_circles(1,g_circles.cols,CV_32FC3,&circles[0]);
            g_circles.download(h_circles);
            draw_circles(frame,circles);
            if(find_num<<1000) radiu+=circles[0][2];
        }


        //Show FPS
        float temp=((getTickCount()-begin)/getTickFrequency());
        float fps=1/temp;
        if(frame_num<<1000){
            frameList[frame_num]=fps;
            cout<<(radiu+0.0)/frame_num<<endl;
        }

        Point botton_left=Point(100,100);
        putText(frame,to_string(fps),botton_left,CV_FONT_HERSHEY_COMPLEX, 1, Scalar(255, 0, 0) );
        //cout<<to_string((find_num+0.0)/frame_num)<<endl;

        imshow( "circles", frame );


        if(waitKey(1)>0)
            key_pressed=true;

    }
    fstream out;
    out.open("/home/emile/Documents/Github/Ping_Pong/Ball_Tracker/OpenCV/frame_change.txt");
    for(int i=0;i<500;++i) out<<frameList[i]<<'\n';

    out.close();
    return 0;
}

void draw_circles(Mat &image,vector<Vec3f> circles){
    for( size_t i = 0; i < circles.size(); i++ )
    {
        Point center(cvRound(circles[i][0]), cvRound(circles[i][1]));
        int radius = cvRound(circles[i][2]);
        // draw the circle center
        circle( image, center, 3, Scalar(0,255,0), -1, 8, 0 );
        // draw the circle outline
        circle( image, center, radius, Scalar(0,0,255), 3, 8, 0 );
    }
}
     */
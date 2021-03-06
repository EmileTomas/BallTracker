#include <cmath>
#include <iostream>

#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/cudaimgproc.hpp>
#include <fstream>

using namespace std;
using namespace cv;
Point p1(502,142),p2(820,460);

void draw_circles(Mat &image,vector<Vec3f> circles);
int main(int argc, const char* argv[])
{
    /* //picture /home/emile/Documents/Github/Ping_Pong/Ball_Tracker/Selection_001.png
    VideoCapture cap("/home/emile/Documents/Github/Ping_Pong/720p.mp4");
    if(!cap.isOpened()){
        return -1;
    }

    namedWindow( "circles", 1 );
    Mat frame,gray_frame,detect_frame;
    Point p1(502,142),p2(820,460);
    Rect detect_rect(p1,p2);

    bool button_pressed=false;
    vector<Vec3f> circles;
    int frame_num=0;
    int circle_find=0;
    int frameList[500];
    while(!button_pressed){
        ++frame_num;
        float begin=getTickCount();
        //ReadFrame
        if(!cap.read(frame)){
            break;
        }

        detect_frame=frame(detect_rect);
        //Detect circles
        cvtColor(detect_frame,gray_frame,CV_RGB2GRAY);
        GaussianBlur(gray_frame,gray_frame,Size(9,9),2,2);
        HoughCircles(gray_frame, circles, HOUGH_GRADIENT, 2, gray_frame.rows/4, 250, 100 );


        //Show circles;
        draw_circles(frame,circles);

        //Show Dectect Block
        rectangle(frame,p1,p2,Scalar(255, 0, 0));

        if(circles[0][2]>10) ++circle_find;
        //Show FPS
        int fps=1/((getTickCount()-begin)/getTickFrequency());
        if(frame_num<500) frameList[frame_num]=fps;
        Point botton_left=Point(100,100);
        Point botton_right=Point(100,200);
        putText(frame,to_string(fps),botton_left,CV_FONT_HERSHEY_COMPLEX, 1, Scalar(255, 0, 0) );
        putText(frame,to_string((circle_find+0.0)/frame_num),botton_right,CV_FONT_HERSHEY_COMPLEX, 1, Scalar(255, 0, 0));
        imshow( "circles", frame );


        if(waitKey(1)>0)
            button_pressed=true;

    }

    fstream out;
    out.open("/home/emile/Documents/Github/Ping_Pong/Ball_Tracker/OpenCV/frame_change.txt");
    for(int i=0;i<500;++i) out<<frameList[i]<<'\n';
    out.close();
    return 0;
    */
    VideoCapture cap("/home/emile/Documents/Github/Ping_Pong/720p.mp4");
    if(!cap.isOpened()){
        return -1;
    }

    namedWindow( "circles", 1 );
    Mat frame,gray_frame,detect_frame;

    Rect detect_rect(p1,p2);
    Ptr<cuda::HoughCirclesDetector> hough=cuda::createHoughCirclesDetector(2,gray_frame.rows/6,150,100,90,140,1);   //150 这个参数越低 检测出效果越好
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
        detect_frame=frame(detect_rect);
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
        rectangle(frame,p1,p2,Scalar(255, 0, 0));
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
        Point center(cvRound(circles[i][0]+p1.x), cvRound(circles[i][1]+p1.y));
        int radius = cvRound(circles[i][2]);
        // draw the circle center
        circle( image, center, 3, Scalar(0,255,0), -1, 8, 0 );
        // draw the circle outline
        circle( image, center, radius, Scalar(0,0,255), 3, 8, 0 );
    }
}
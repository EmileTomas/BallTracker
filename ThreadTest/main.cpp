

/*
 * #include <cmath>
#include <iostream>

#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/cudaimgproc.hpp>
#include <fstream>
using namespace std;
using namespace cv;

const String VIDEO_PATH="/home/emile/Documents/Github/Ping_Pong/test.mp4";
const int THREAD_MAX=100;

Mat getFirstFrame(String videoPath);
void initialWindow();

int main(int argc, char **argv) {

    namedWindow("Circles");
    namedWindow("Canny");
    Mat img,gray,canny;

    img = getFirstFrame(VIDEO_PATH);
    cvtColor(img, gray, CV_BGR2GRAY);
    Canny(gray, canny, THREAD_MAX/2, THREAD_MAX);

    imshow("Circles", gray);
    waitKey(0);
    imshow("Canny", canny);
    waitKey(0);

    GaussianBlur(canny, canny, Size(9, 9), 2, 2);
    imshow("Canny", canny);
    waitKey(0);

    // smooth it, otherwise a lot of false circles may be detected

    vector<Vec3f> circles;

    HoughCircles(gray, circles, CV_HOUGH_GRADIENT,
                 2, gray.rows / 4, THREAD_MAX, 140);
    for (size_t i = 0; i < circles.size(); i++) {
        Point center(cvRound(circles[i][0]), cvRound(circles[i][1]));
        int radius = cvRound(circles[i][2]);
        // draw the circle center
        circle(img, center, 3, Scalar(0, 255, 0), -1, 8, 0);
        // draw the circle outline
        circle(img, center, radius, Scalar(0, 0, 255), 3, 8, 0);
    }


    imshow("Circles", img);
    waitKey(0);
    return 0;
}




void initialWindow() {

    namedWindow("Canny");

}
 */

#include "opencv2/imgproc.hpp"
#include "opencv2/highgui.hpp"
#include <iostream>
#include <stdlib.h>
using namespace std;
using namespace cv;
void on_low_r_thresh_trackbar(int, void *);
void on_high_r_thresh_trackbar(int, void *);
void on_low_g_thresh_trackbar(int, void *);
void on_high_g_thresh_trackbar(int, void *);
void on_low_b_thresh_trackbar(int, void *);
void on_high_b_thresh_trackbar(int, void *);
int low_r=0, low_g=0, low_b=0;
int high_r=50, high_g=50, high_b=50;

const String VIDEO_PATH="/home/emile/Documents/Github/Ping_Pong/720p.mp4";
const int THREAD_MAX=100;

Mat getFirstFrame(String videoPath);


int main()
{
    Mat frame, frame_threshold_red,frame_threshold_black,canny;
    frame=imread(VIDEO_PATH);
    VideoCapture cap(VIDEO_PATH);

    namedWindow("Video Capture", WINDOW_NORMAL);
    namedWindow("Object Detection", WINDOW_NORMAL);
    //-- Trackbars to set thresholds for RGB values
    createTrackbar("Low R","Object Detection", &low_r, 255, on_low_r_thresh_trackbar);
    createTrackbar("High R","Object Detection", &high_r, 255, on_high_r_thresh_trackbar);
    createTrackbar("Low G","Object Detection", &low_g, 255, on_low_g_thresh_trackbar);
    createTrackbar("High G","Object Detection", &high_g, 255, on_high_g_thresh_trackbar);
    createTrackbar("Low B","Object Detection", &low_b, 255, on_low_b_thresh_trackbar);
    createTrackbar("High B","Object Detection", &high_b, 255, on_high_b_thresh_trackbar);
    while(char(waitKey(1))!='q'){
        if(!cap.read(frame))
            cout<<"Error";

        //-- Detect the object based on RGB Range Values
        inRange(frame,Scalar(0,0,0), Scalar(50,50,255),frame_threshold_red);
        Canny(frame,canny,50,100);
        inRange(frame,Scalar(low_b,low_g,low_r), Scalar(high_b,high_g,high_r),frame_threshold_black);
        addWeighted(frame_threshold_black,1,canny,1,0.,frame_threshold_black);
        //-- Show the frames
        imshow("Video Capture",frame);
        imshow("Object Detection",frame_threshold_black);
        waitKey(0);
    }
    return 0;
}
void on_low_r_thresh_trackbar(int, void *)
{
    low_r = min(high_r-1, low_r);
    setTrackbarPos("Low R","Object Detection", low_r);
}
void on_high_r_thresh_trackbar(int, void *)
{
    high_r = max(high_r, low_r+1);
    setTrackbarPos("High R", "Object Detection", high_r);
}
void on_low_g_thresh_trackbar(int, void *)
{
    low_g = min(high_g-1, low_g);
    setTrackbarPos("Low G","Object Detection", low_g);
}
void on_high_g_thresh_trackbar(int, void *)
{
    high_g = max(high_g, low_g+1);
    setTrackbarPos("High G", "Object Detection", high_g);
}
void on_low_b_thresh_trackbar(int, void *)
{
    low_b= min(high_b-1, low_b);
    setTrackbarPos("Low B","Object Detection", low_b);
}
void on_high_b_thresh_trackbar(int, void *)
{
    high_b = max(high_b, low_b+1);
    setTrackbarPos("High B", "Object Detection", high_b);
}

Mat getFirstFrame(String filePath) {
    VideoCapture cap(filePath);
    Mat img;
    if (!cap.read(img)) {
        cout << "No such Video. Check path.";
        exit;
    }
    return img;
}


/*Version of RGB
int main()
{
    Mat frame, frame_threshold;
    frame=imread(VIDEO_PATH);
    namedWindow("Video Capture", WINDOW_NORMAL);
    namedWindow("Object Detection", WINDOW_NORMAL);
    //-- Trackbars to set thresholds for RGB values
    createTrackbar("Low R","Object Detection", &low_r, 255, on_low_r_thresh_trackbar);
    createTrackbar("High R","Object Detection", &high_r, 255, on_high_r_thresh_trackbar);
    createTrackbar("Low G","Object Detection", &low_g, 255, on_low_g_thresh_trackbar);
    createTrackbar("High G","Object Detection", &high_g, 255, on_high_g_thresh_trackbar);
    createTrackbar("Low B","Object Detection", &low_b, 255, on_low_b_thresh_trackbar);
    createTrackbar("High B","Object Detection", &high_b, 255, on_high_b_thresh_trackbar);
    while(char(waitKey(1))!='q'){

        if(frame.empty())
            break;
        //-- Detect the object based on RGB Range Values
        inRange(frame,Scalar(low_b,low_g,low_r), Scalar(high_b,high_g,high_r),frame_threshold);
        //-- Show the frames
        imshow("Video Capture",frame);
        imshow("Object Detection",frame_threshold);
    }
    return 0;
}
void on_low_r_thresh_trackbar(int, void *)
{
    low_r = min(high_r-1, low_r);
    setTrackbarPos("Low R","Object Detection", low_r);
}
void on_high_r_thresh_trackbar(int, void *)
{
    high_r = max(high_r, low_r+1);
    setTrackbarPos("High R", "Object Detection", high_r);
}
void on_low_g_thresh_trackbar(int, void *)
{
    low_g = min(high_g-1, low_g);
    setTrackbarPos("Low G","Object Detection", low_g);
}
void on_high_g_thresh_trackbar(int, void *)
{
    high_g = max(high_g, low_g+1);
    setTrackbarPos("High G", "Object Detection", high_g);
}
void on_low_b_thresh_trackbar(int, void *)
{
    low_b= min(high_b-1, low_b);
    setTrackbarPos("Low B","Object Detection", low_b);
}
void on_high_b_thresh_trackbar(int, void *)
{
    high_b = max(high_b, low_b+1);
    setTrackbarPos("High B", "Object Detection", high_b);
}

Mat getFirstFrame(String filePath) {
    VideoCapture cap(filePath);
    Mat img;
    if (!cap.read(img)) {
        cout << "No such Video. Check path.";
        exit;
    }
    return img;
}
 */
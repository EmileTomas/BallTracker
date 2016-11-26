cmake_minimum_required(VERSION 3.6)
project(ThreadTest)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

include_directories("/usr/local/include/opencv")
include_directories("/usr/local/include/opencv2")
link_directories("/usr/local/lib")

set(SOURCE_FILES main.cpp)
add_executable(ThreadTest ${SOURCE_FILES})

target_link_libraries(ThreadTest
        opencv_cudabgsegm opencv_cudaobjdetect opencv_cudastereo opencv_shape opencv_stitching opencv_cudafeatures2d
        opencv_superres opencv_cudacodec opencv_videostab opencv_cudaoptflow opencv_cudalegacy opencv_calib3d opencv_features2d
        opencv_objdetect opencv_highgui opencv_videoio opencv_photo opencv_imgcodecs opencv_cudawarping opencv_cudaimgproc
        opencv_cudafilters opencv_video opencv_ml opencv_imgproc opencv_flann opencv_cudaarithm opencv_core opencv_cudev
        )
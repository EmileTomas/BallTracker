### RDS Development Log

## Introduction

This is a log file for the development of **Rotation Detection System(RDS)**. RDS is developed for the Ping-Pong robot and there is one other similar project which aims to predict and rebuild the 3D movement of Ping-Pong ball using machine learning.

Totally speaking, the target of this system is to tracking the high speed rotation of a Ping-Pong ball without adding extra marks to the ball. The output of the system is the rotation axis and the rotation speed in 3D space, which are also important input parameters for the training of neural network. 

There are several important part for RDS works well:

- Ball Detection

  Although the 3D rebuilding of the Ping-Pong ball can provide RDS some information about the location of Ping Pong, we still need to catch the ball when it enters the camera.

  Difficult:

  The need to resize the window to speed up the detection.

- Feature Matching 

  Find out the matching points using SURF algorithm.

  There might be not enough features.




## Personal Notes

Here are something might need to improve in the prototype.

1. The size of cropped picture in the *getDetectArea.m*, more responsible ratio might be found.

2. The system might need to check the validity of the circle found via *ballDetector.m* from more aspects, for example, checking the color of the pixels around the circle center we find.

   **This is important, because if we find wrong center from the image, we might crop the next frame in the wrong place, although the system will  try to find circle in the global frame in the next next frame. Whereas if we can eliminate the wrong center at the beginning, the system will try to find circle in the global frame in the next frame immediately**

   Also there might be one static list which could use average radius to represent the radius we find.(might help)

   We might come up with a specialized system to catch the ball before the ball enter the camera, because searching ball in a frame containing the ball might used some information before like radius range can shrink into a small range.

3. Data Visualization 

   refreshdata 
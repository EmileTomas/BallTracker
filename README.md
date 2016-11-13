# Log

目标处理帧率160X320 400FPS

### Nov 10th 2016

通过matlab的Hough变换圆检测,并通过缩小检测范围可以将帧率从10FPS提高到40FPS左右.

下一步的提升,通过了解Hough变换算法,对其进行改进 以及通过CUDA进行GPU运算进行提升.

### NOV 11th 2016

通过OpenCV平台进行圆形检测,使用`houghCircles()`,帧率达到100 FPS,但是对于参数比较敏感.

下面进行RHT的尝试.



#### NOV 13th 2016

通过采用局部`houghcircles`检测(前端需要动态跟踪制导),可以将fps提高至300FPS.




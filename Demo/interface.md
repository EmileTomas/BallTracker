# Interface Document

为了方便解耦以及将来将该模块换为opencv对应的GPU Version，圆形检测单独写一个函数

输入为  圆心坐标，半径，find_ball_flag

输出为 圆心坐标，半径，find_ball_flag

ballDetector 输出centers，应当根据多帧的结果给出精确的结果, 这样可以容忍乒乓球一定程度上的移动.

BallTracker应当认真写，具备一定的鲁棒性
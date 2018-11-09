t=imgRW('img\');%读取目录下的jpg图像 
max_ransac=1.8;%设置RANSAC的阈值为2SURF_mer=1000;%设置SURF强度阈值为1000
ratio=6;%缩放比例1：6
center=1;%以第一幅读取的图像为中心图像
[new,new_edge]=myImgregist(t,ratio,center,SURF_mer,max_ransac);%图像配准，返回配准图像及其轮廓
Mimg=myImgfuse(new,new_edge);%图像融合
imshow(Mimg);%显示图像

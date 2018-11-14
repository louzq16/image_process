figure(1);
I=imread('lena.jpg');
subplot(2,3,1);imshow(I);title('原图');%显示原图

%直方图均衡
new_img=BrightnessUp(I,'HistogramEqual',0);
subplot(2,3,2);imshow(new_img);title('直方图均衡化');

%线性增强，u=1.5v+50
new_img=BrightnessUp(I,'Linear',[1.5,50]);
subplot(2,3,3);imshow(new_img);title('线性增强');

%伽马矫正 u=c(v+0)^0.35
new_img=BrightnessUp(I,'Gamma',[0,0.35]);
subplot(2,3,4);imshow(new_img);title('伽马矫正');

%对数变换，底数为1.5
new_img=BrightnessUp(I,'Log',1.5);
subplot(2,3,5);imshow(new_img);title('对数变换');

%同态滤波，频域滤波器：高低阈值为1.6和1.08，截止频率为60，比例系数为1
new_img=BrightnessUp(I,'homomorphic',[1.08,1.6,60,1]);
subplot(2,3,6);imshow(new_img);title('同态滤波');
%空间滤波
figure(1);
I=imread('lena.jpg');
subplot(2,3,1);imshow(I);title('未去噪图像');

%原图
load('lena512.mat');
old_I=uint8(lena512);
disp('未去噪图像与原图的PSNR、MSE、SSIM');
[PSNR,MSE,SSIM]=myevaluate(old_I,I)

%低通滤波 平滑滤波
new_I=mylvbo(I,'mean',2);
subplot(2,3,2);imshow(new_I);title('平滑滤波');
disp('均值滤波图像与原图的PSNR、MSE、SSIM');
[PSNR,MSE,SSIM]=myevaluate(old_I,new_I)

%自适应局部降噪滤波
new_I=mylvbo(I,'self_ad',[2 249]);
subplot(2,3,3);imshow(new_I);title('自适应局部降噪滤波');
disp('自适应局部降噪滤波图像与原图的PSNR、MSE、SSIM');
[PSNR,MSE,SSIM]=myevaluate(old_I,new_I)

%低通滤波 高效的中值滤波，直方图实现 
new_I=mylvbo(I,'fmedian',2);
subplot(2,3,4);imshow(new_I);title('直方图快速中值滤波');
disp('中值滤波图像与原图的PSNR、MSE、SSIM');
[PSNR,MSE,SSIM]=myevaluate(old_I,new_I)

%加权滤波 高斯滤波
new_I=mylvbo(I,'guass',[1 2]);%[sigma N]
subplot(2,3,5);imshow(new_I);title('高斯滤波');
disp('高斯滤波图像与原图的PSNR、MSE、SSIM');
[PSNR,MSE,SSIM]=myevaluate(old_I,new_I)

new_I=mylvbo(I,'self_ad',[2 249]);
new_I=mylvbo(new_I,'fmedian',1);
subplot(2,3,6);imshow(new_I);title('自适应局部降噪滤波+中值滤波');
disp('自适应+中值滤波图像与原图的PSNR、MSE、SSIM');
[PSNR,MSE,SSIM]=myevaluate(old_I,new_I)
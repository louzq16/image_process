%边缘检测 
figure(2)
I=imread('lena.jpg');
fil_I=mylvbo(I,'guass',[1.2 2]);%高斯滤波

%sobel
edge_I=edge_detect(fil_I,'sobel',100,0);%阈值100 0代表不进行二值化
subplot(2,2,1);imshow(edge_I);title('sobel 阈值100 非二值化');

%robert
edge_I=edge_detect(fil_I,'robert',25,1);%阈值25 1代表进行二值化
subplot(2,2,2);imshow(edge_I);title('robert 阈值25 二值化');

%laplace
edge_I=edge_detect(fil_I,'laplace',[40,2],1);
%阈值40 2代表选择[-1,-1,-1;-1,8,-1;-1,-1,-1]为模板 1代表进行标定
subplot(2,2,3);imshow(edge_I);title('laplace 阈值40 进行标定');

%canny
edge_I=edge_detect(fil_I,'canny',[80 110],1);%低阈值80 高阈值110 1代表进行标定
subplot(2,2,4);imshow(edge_I);title('canny 双阈值80 110 进行标定');
%�ռ��˲�
figure(1);
I=imread('lena.jpg');
subplot(2,3,1);imshow(I);title('δȥ��ͼ��');

%ԭͼ
load('lena512.mat');
old_I=uint8(lena512);
disp('δȥ��ͼ����ԭͼ��PSNR��MSE��SSIM');
[PSNR,MSE,SSIM]=myevaluate(old_I,I)

%��ͨ�˲� ƽ���˲�
new_I=mylvbo(I,'mean',2);
subplot(2,3,2);imshow(new_I);title('ƽ���˲�');
disp('��ֵ�˲�ͼ����ԭͼ��PSNR��MSE��SSIM');
[PSNR,MSE,SSIM]=myevaluate(old_I,new_I)

%����Ӧ�ֲ������˲�
new_I=mylvbo(I,'self_ad',[2 249]);
subplot(2,3,3);imshow(new_I);title('����Ӧ�ֲ������˲�');
disp('����Ӧ�ֲ������˲�ͼ����ԭͼ��PSNR��MSE��SSIM');
[PSNR,MSE,SSIM]=myevaluate(old_I,new_I)

%��ͨ�˲� ��Ч����ֵ�˲���ֱ��ͼʵ�� 
new_I=mylvbo(I,'fmedian',2);
subplot(2,3,4);imshow(new_I);title('ֱ��ͼ������ֵ�˲�');
disp('��ֵ�˲�ͼ����ԭͼ��PSNR��MSE��SSIM');
[PSNR,MSE,SSIM]=myevaluate(old_I,new_I)

%��Ȩ�˲� ��˹�˲�
new_I=mylvbo(I,'guass',[1 2]);%[sigma N]
subplot(2,3,5);imshow(new_I);title('��˹�˲�');
disp('��˹�˲�ͼ����ԭͼ��PSNR��MSE��SSIM');
[PSNR,MSE,SSIM]=myevaluate(old_I,new_I)

new_I=mylvbo(I,'self_ad',[2 249]);
new_I=mylvbo(new_I,'fmedian',1);
subplot(2,3,6);imshow(new_I);title('����Ӧ�ֲ������˲�+��ֵ�˲�');
disp('����Ӧ+��ֵ�˲�ͼ����ԭͼ��PSNR��MSE��SSIM');
[PSNR,MSE,SSIM]=myevaluate(old_I,new_I)
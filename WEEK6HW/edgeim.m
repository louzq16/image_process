%��Ե��� 
figure(2)
I=imread('lena.jpg');
fil_I=mylvbo(I,'guass',[1.2 2]);%��˹�˲�

%sobel
edge_I=edge_detect(fil_I,'sobel',100,0);%��ֵ100 0�������ж�ֵ��
subplot(2,2,1);imshow(edge_I);title('sobel ��ֵ100 �Ƕ�ֵ��');

%robert
edge_I=edge_detect(fil_I,'robert',25,1);%��ֵ25 1������ж�ֵ��
subplot(2,2,2);imshow(edge_I);title('robert ��ֵ25 ��ֵ��');

%laplace
edge_I=edge_detect(fil_I,'laplace',[40,2],1);
%��ֵ40 2����ѡ��[-1,-1,-1;-1,8,-1;-1,-1,-1]Ϊģ�� 1������б궨
subplot(2,2,3);imshow(edge_I);title('laplace ��ֵ40 ���б궨');

%canny
edge_I=edge_detect(fil_I,'canny',[80 110],1);%����ֵ80 ����ֵ110 1������б궨
subplot(2,2,4);imshow(edge_I);title('canny ˫��ֵ80 110 ���б궨');
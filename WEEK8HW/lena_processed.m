figure(1);
I=imread('lena.jpg');
subplot(2,3,1);imshow(I);title('ԭͼ');%��ʾԭͼ

%ֱ��ͼ����
new_img=BrightnessUp(I,'HistogramEqual',0);
subplot(2,3,2);imshow(new_img);title('ֱ��ͼ���⻯');

%������ǿ��u=1.5v+50
new_img=BrightnessUp(I,'Linear',[1.5,50]);
subplot(2,3,3);imshow(new_img);title('������ǿ');

%٤����� u=c(v+0)^0.35
new_img=BrightnessUp(I,'Gamma',[0,0.35]);
subplot(2,3,4);imshow(new_img);title('٤�����');

%�����任������Ϊ1.5
new_img=BrightnessUp(I,'Log',1.5);
subplot(2,3,5);imshow(new_img);title('�����任');

%̬ͬ�˲���Ƶ���˲������ߵ���ֵΪ1.6��1.08����ֹƵ��Ϊ60������ϵ��Ϊ1
new_img=BrightnessUp(I,'homomorphic',[1.08,1.6,60,1]);
subplot(2,3,6);imshow(new_img);title('̬ͬ�˲�');
t=imgRW('img\');%��ȡĿ¼�µ�jpgͼ�� 
max_ransac=1.8;%����RANSAC����ֵΪ2SURF_mer=1000;%����SURFǿ����ֵΪ1000
ratio=6;%���ű���1��6
center=1;%�Ե�һ����ȡ��ͼ��Ϊ����ͼ��
[new,new_edge]=myImgregist(t,ratio,center,SURF_mer,max_ransac);%ͼ����׼��������׼ͼ��������
Mimg=myImgfuse(new,new_edge);%ͼ���ں�
imshow(Mimg);%��ʾͼ��

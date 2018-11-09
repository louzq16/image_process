function new_imgs = myReinhard( src_imgs,dest_img )
%MYREINHARD ɫ�����
%��������ΪԪ�����飬����ɫ���任���ͼ��
%���룺src_imgs ����ΪԪ�����飬�����ȴ�����ɫ���ͼ�� dest_img �ο���ɫͼ��
dest_lab_img=rgb2lab(uint8(dest_img));
[m,n,~]=size(dest_lab_img);
dest_mean=mean(mean(dest_lab_img));
dest_var=sum(sum((dest_lab_img-dest_mean).^2))/(m*n);
for i=1:length(src_imgs)
   tem_lab=rgb2lab(uint8(src_imgs{i}));
   [tem_m,tem_n,~]=size(tem_lab);
    tem_mean=mean(mean(tem_lab));
    tem_var=sum(sum((tem_lab-tem_mean).^2))/(tem_m*tem_n);
    tem_lab=(tem_lab-tem_mean).*(dest_var./tem_var)+dest_mean;
    src_imgs{i}=lab2rgb(tem_lab,'OutputType','uint8');
end
new_imgs=src_imgs;
end


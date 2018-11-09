function new_imgs = myReinhard( src_imgs,dest_img )
%MYREINHARD 色差调整
%输出：输出为元胞数组，包含色调变换后的图像
%输入：src_imgs 类型为元胞数组，包含等待调整色差的图像 dest_img 参考调色图像
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


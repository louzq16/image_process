function [all_img,img_num]=imgRW(address)
%读取指定目录下的所有jpg文件
%INPUT:address 指定目录
%%%%请务必在输入的目录后加斜杠即 \ 符号
%OUTPUT:all_img 所有图像元胞数组类型 img_num 图像数量
img_dir=dir([address,'*jpg']);
img_num=length(img_dir);
all_img=cell(img_num,1);
for i=1:img_num
    all_img(i)={imread([address,img_dir(i).name])};
end
end



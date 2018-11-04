function [ output_args ] = mySURF( imgs ,G_D)
%MYSURF 此处显示有关此函数的摘要
%   此处显示详细说明
N=3;sigma=(N/3)^2;
Pi=3.1415926;
if class(imgs)=='cell'
    number=length(imgs);
    for k=1:number
        tem_img=double(rgb2gray(imgs{k}));%转为灰色图像？？
        [m,n]=size(tem_img);
        Integ_gram=GetIntegrogram(tem_img,m,n);
        %【使用盒式滤波器来提高运算速度】         
        %获得hessian矩阵  
        
    end
else
end
end


end

function Iimg=GetIntegrogram(img,m,n)
%该函数生成图像的积分图像
Iimg=zeros(m,n);
for i=1:m
    for j=1:n
        Iimg(i,j)=sum(sum(img(1:i,1:j)));
    end
end
end

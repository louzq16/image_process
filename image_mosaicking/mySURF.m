function [ output_args ] = mySURF( imgs ,G_D)
%MYSURF �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
N=3;sigma=(N/3)^2;
Pi=3.1415926;
if class(imgs)=='cell'
    number=length(imgs);
    for k=1:number
        tem_img=double(rgb2gray(imgs{k}));%תΪ��ɫͼ�񣿣�
        [m,n]=size(tem_img);
        Integ_gram=GetIntegrogram(tem_img,m,n);
        %��ʹ�ú�ʽ�˲�������������ٶȡ�         
        %���hessian����  
        
    end
else
end
end


end

function Iimg=GetIntegrogram(img,m,n)
%�ú�������ͼ��Ļ���ͼ��
Iimg=zeros(m,n);
for i=1:m
    for j=1:n
        Iimg(i,j)=sum(sum(img(1:i,1:j)));
    end
end
end

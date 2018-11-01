function [PSNR,MSE,SSIM] = myevaluate(I1,I2)
%MYPNSR 计算两幅图之间的PSNR来判断相似度
%I1与I2是输入的两幅图像
%PNSR 峰值信噪比 MSE 均方误差 SSIM 结构相似度
[m,n]=size(I1);
I1=double(I1);I2=double(I2);
MSE=sum(sum((I1-I2).^2/(m*n)));
PSNR=10*log10(255*255/MSE);
mean1=mean(I1(:));
mean2=mean(I2(:));
sigma1=sum(sum((I1-mean1).^2/(m*n)));
sigma2=sum(sum((I2-mean2).^2/(m*n)));
cov12=sum(sum((I1-mean1).*(I2-mean2)/(m*n)));
c1=(0.01*255)^2;
c2=(0.03*255)^2;
SSIM=(2*mean1*mean2+c1)*(2*cov12+c2)/((mean1^2+mean2^2+c1)*(sigma1+sigma2+c2));
end


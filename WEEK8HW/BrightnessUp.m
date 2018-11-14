function new_img = BrightnessUp(img,type,parameter)
%该函数用来进行图像亮度调整
%img 输入图像
%type 增强图像亮度方法，不同方法的parameter不一样
%type='HistogramEqual'时采用直方图均衡化，parameter无意义
%type='Linear'时采用线性变换，parameter(1)为线性变换斜率，parameter(2)为线性变换截距
%type='Gamma'时采用伽马矫正,u=c(v+k)^γ，parameter(1)为k，parameter(2)为γ，c由最后的规范化自动确定
%type='Log'时为对数变换，parameter为对数变换底数
%type='homomorphic'时采用同态滤波，parameter(1),parameter(2)为频域滤波器低高阈值，parameter(3)为截止频率，parameter(4)为比例系数调整滤波器陡度
img=double(img);
new_img=img;
switch type
    case 'HistogramEqual'
        [m,n]=size(new_img);
        k=max(max(new_img))/(m*n);
        jsum=0;
        for i=0:255
            logic=(new_img==i);
            jsum=jsum+sum(sum(logic));
            new_img(logic)=jsum*k;
        end
    case 'Linear'
        new_img=parameter(1)*new_img+parameter(2);
    case 'Gamma'
        new_img=((new_img+parameter(1)).^parameter(2));
        maxI=max(max(new_img));minI=min(min(new_img));
        new_img=(new_img-minI)*255/(maxI-minI);%规范化
    case 'Log'
        new_img=log(1+new_img)/log(parameter);
        maxI=max(max(new_img));minI=min(min(new_img));
        new_img=(new_img-minI)*255/(maxI-minI);%规范化
    case 'homomorphic'
        new_img=log(1+new_img);
        imgF=fftshift(fft2(new_img));
        gammaL=parameter(1);gammaH=parameter(2);D0=parameter(3);c=parameter(4);
        [m,n]=size(imgF);
        m2=double(m)/2;n2=double(n)/2;
        
        x=1:n;x=x(ones(m,1),:);x=x-n2;
        y=1:m;y=y(ones(n,1),:);y=y';y=y-m2;
        d=x.^2+y.^2;
        H=(gammaH-gammaL)*(1-exp(-c*d/(D0^2)))+gammaL;%生成频域滤波器
        
        new_img=exp(ifft2(ifftshift(H.*imgF)));
        new_img=real(new_img)-1;
    otherwise
        disp('wrong');
end        
new_img=uint8(new_img);       
end


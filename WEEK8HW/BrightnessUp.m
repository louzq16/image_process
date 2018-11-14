function new_img = BrightnessUp(img,type,parameter)
%�ú�����������ͼ�����ȵ���
%img ����ͼ��
%type ��ǿͼ�����ȷ�������ͬ������parameter��һ��
%type='HistogramEqual'ʱ����ֱ��ͼ���⻯��parameter������
%type='Linear'ʱ�������Ա任��parameter(1)Ϊ���Ա任б�ʣ�parameter(2)Ϊ���Ա任�ؾ�
%type='Gamma'ʱ����٤�����,u=c(v+k)^�ã�parameter(1)Ϊk��parameter(2)Ϊ�ã�c�����Ĺ淶���Զ�ȷ��
%type='Log'ʱΪ�����任��parameterΪ�����任����
%type='homomorphic'ʱ����̬ͬ�˲���parameter(1),parameter(2)ΪƵ���˲����͸���ֵ��parameter(3)Ϊ��ֹƵ�ʣ�parameter(4)Ϊ����ϵ�������˲�������
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
        new_img=(new_img-minI)*255/(maxI-minI);%�淶��
    case 'Log'
        new_img=log(1+new_img)/log(parameter);
        maxI=max(max(new_img));minI=min(min(new_img));
        new_img=(new_img-minI)*255/(maxI-minI);%�淶��
    case 'homomorphic'
        new_img=log(1+new_img);
        imgF=fftshift(fft2(new_img));
        gammaL=parameter(1);gammaH=parameter(2);D0=parameter(3);c=parameter(4);
        [m,n]=size(imgF);
        m2=double(m)/2;n2=double(n)/2;
        
        x=1:n;x=x(ones(m,1),:);x=x-n2;
        y=1:m;y=y(ones(n,1),:);y=y';y=y-m2;
        d=x.^2+y.^2;
        H=(gammaH-gammaL)*(1-exp(-c*d/(D0^2)))+gammaL;%����Ƶ���˲���
        
        new_img=exp(ifft2(ifftshift(H.*imgF)));
        new_img=real(new_img)-1;
    otherwise
        disp('wrong');
end        
new_img=uint8(new_img);       
end


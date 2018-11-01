function new_I=mylvbo(I,type,N)
%空间滤波
%type滤波方式
%mean:均值滤波 median中值滤波 fmedian快速中值滤波 %max最大值滤波
%guass：高斯滤波 own：N为你自己的滤波算子 
%N 窗口大小 ##对于guass N需要输入方差否则默认唯一 N=[2.0,1] 方差为2
%都不镶边
[m,n]=size(I);
new_I=I;
I=double(I);

switch type
    case 'mean'
        %低通滤波 平滑滤波 time:0.8s
        pm=2*N+1;%n为平滑滤波器大小
        pfilter=ones(pm)/pm^2;%生成平滑滤波器
        for i=1:m-pm+1
            for j=1:n-pm+1
                new_I(i+N,j+N)=sum(sum(I(i:i+pm-1,j:j+pm-1).*pfilter));
            end
        end
    case 'median'
        %低通滤波 中值滤波 不镶边 time:2.7s
        zm=2*N+1;
        for i=1:m-zm+1
            for j=1:n-zm+1
                k=I(i:i+zm-1,j:j+zm-1);
                new_I(i+N,j+N)=median(k(:));
            end
        end
    case 'fmedian'
        %低通滤波 高效的中值滤波，直方图实现 time:1.04s
        kzm=2*N+1;
        th=floor(kzm*kzm/2)+1;
        for row=1:m-kzm+1
            Hist=zeros(256,1);
            tem1=I(row:row+kzm-1,1:kzm);
            for i=1:kzm*kzm
                tem2=tem1(i);
                Hist(tem2+1)=1+Hist(tem2+1);
            end
            num=0;
            flag=0;
            tem=find(Hist~=0);
            for i=1:length(tem)
                num=num+Hist(tem(i));
                if(num>=th)
                    flag=tem(i)-1;
                    break;
                end
            end
            new_I(row+N,1+N)=flag;
            for col=2:n-kzm+1
                tem1=I(row:row+kzm-1,col-1);
                tem2=I(row:row+kzm-1,col+kzm-1);
                for j=1:kzm
                    Hist(tem1(j)+1)=Hist(tem1(j)+1)-1;
                    num=num-(tem1(j)<=flag);
                    Hist(tem2(j)+1)=Hist(tem2(j)+1)+1;
                    num=num+(tem2(j)<=flag);
                end
                while(num>=th)
                    num=num-Hist(flag+1);
                    flag=flag-1;
                end
                while(num<th)
                    num=num+Hist(flag+2);
                    flag=flag+1;
                end
                new_I(row+N,col+N)=flag;
            end
        end
    case 'guass'
        if length(N)==1
            gm=2*N+1;
            sigma=2.0;
        else
            gm=2*N(2)+1;
            sigma=2*N(1);
            N=N(2);
        end
%        %直接读取guass算子矩阵，但是在guass算子阶数不高的情况下，
%        %硬盘操作会减慢速度
%         load guass.mat; 
%         guass=guass(21-N:21+N,21-N:21+N);
        x=-N:N;x=x(ones(gm,1),:);y=x';
        guass=exp(-(x.^2+y.^2)/sigma);
        guass=guass/sum(sum(guass));
        for i=1:m-gm+1
            for j=1:n-gm+1
                new_I(i+N,j+N)=sum(sum(I(i:i+gm-1,j:j+gm-1).*guass));
            end
        end
    case 'max'
         zm=2*N+1;
        for i=1:m-zm+1
            for j=1:n-zm+1
                k=I(i:i+zm-1,j:j+zm-1);
                new_I(i+N,j+N)=max(k(:));
            end
        end
    case 'own'
        [om,on]=size(N);
        oN=(om-1)/2;
        for i=1:m-om+1
            for j=1:n-om+1
                new_I(i+oN,j+oN)=sum(sum(I(i:i+om-1,j:j+om-1).*N));
            end
        end
    otherwise
        disp('完善中。。。');
end
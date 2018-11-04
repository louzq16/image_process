function new_I=mylvbo(I,type,N)
%空间滤波
%type滤波方式 以下为type的解释
%mean:均值滤波  median中值滤波  fmedian快速中值滤波 max最大值滤波;
%对于以上 N代表模板大小(2N+1)*(2N+1)
%self_ad :自适应降噪滤波器 N[2 1] 2表示滤波算子5*5 1表示噪声方差当做1
%self_me:自适应中值滤波器 N[1 3] 1表示起始算子3*3 3表示最大接受算子7*7 N为标量则默认起始算子3*3
%guass：高斯滤波 N=[2.0,1] 方差为2 模板大小为3*3 N为标量则默认方差为1
%都不镶边 对于图片边缘像素不处理
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
        %低通滤波 高效的中值滤波，基于直方图实现 time:1.04s
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
    case 'guass'%高斯滤波
        if length(N)==1
            gm=2*N+1;
            sigma=2.0;
        else
            gm=2*N(2)+1;
            sigma=2*N(1);
            N=N(2);
        end
        x=-N:N;x=x(ones(gm,1),:);y=x';
        guass=exp(-(x.^2+y.^2)/sigma);
        guass=guass/sum(sum(guass));%生成guass滤波模板
        for i=1:m-gm+1
            for j=1:n-gm+1
                new_I(i+N,j+N)=sum(sum(I(i:i+gm-1,j:j+gm-1).*guass));
            end
        end
    case 'self_ad'%自适应局部降噪滤波
        sigmaz=N(2);
        N=N(1);
        zm=2*N+1;
        for i=1:m-zm+1
            for j=1:n-zm+1
                temp=double(I(i:i+zm-1,j:j+zm-1));
                meanI=mean(temp(:));
                sigmaI=sum(sum((temp-meanI).^2/(zm*zm)));%计算局部方差与均值
                new_I(i+N,j+N)=I(i+N,j+N)-sigmaz*(I(i+N,j+N)-meanI)/sigmaI;
            end
        end
    case 'self_me'%自适应中值滤波器 效果较差
        if length(N)==2
            b=N(1);N=N(2);
        else
            b=1;
        end
        zm=2*N+1;
        for i=1:m-zm+1
            for j=1:n-zm+1
                begin=b;
                k=I(i+N-begin:i+N+begin,j+N-begin:j+N+begin);
                sort_k=sort(k(:));
                while (begin<N)&&((sort_k((begin+1)^2+1)==sort_k(1))||(sort_k((begin+1)^2+1)==sort_k(end)))
                   begin=begin+1;
                   k=I(i+N-begin:i+N+begin,j+N-begin:j+N+begin);
                   sort_k=sort(k(:));
                end
                if sort_k((begin+1)^2+1)==sort_k(1)||sort_k((begin+1)^2+1)==sort_k(end)
                    new_I(i+N,j+N)=sort_k((begin+1)^2+1);
                else
                    flag=(I(i+N,j+N)-sort_k(1))*(sort_k(end)-I(i+N,j+N));
                    new_I(i+N,j+N)=(flag<0)*I(i+N,j+N)+(flag>=0)*sort_k((begin+1)^2+1);
                end
            end
        end
    otherwise
        disp('完善中。。。');
end
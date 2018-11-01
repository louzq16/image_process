function new_I=mylvbo(I,type,N)
%�ռ��˲�
%type�˲���ʽ
%mean:��ֵ�˲� median��ֵ�˲� fmedian������ֵ�˲� %max���ֵ�˲�
%guass����˹�˲� own��NΪ���Լ����˲����� 
%N ���ڴ�С ##����guass N��Ҫ���뷽�����Ĭ��Ψһ N=[2.0,1] ����Ϊ2
%�������
[m,n]=size(I);
new_I=I;
I=double(I);

switch type
    case 'mean'
        %��ͨ�˲� ƽ���˲� time:0.8s
        pm=2*N+1;%nΪƽ���˲�����С
        pfilter=ones(pm)/pm^2;%����ƽ���˲���
        for i=1:m-pm+1
            for j=1:n-pm+1
                new_I(i+N,j+N)=sum(sum(I(i:i+pm-1,j:j+pm-1).*pfilter));
            end
        end
    case 'median'
        %��ͨ�˲� ��ֵ�˲� ����� time:2.7s
        zm=2*N+1;
        for i=1:m-zm+1
            for j=1:n-zm+1
                k=I(i:i+zm-1,j:j+zm-1);
                new_I(i+N,j+N)=median(k(:));
            end
        end
    case 'fmedian'
        %��ͨ�˲� ��Ч����ֵ�˲���ֱ��ͼʵ�� time:1.04s
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
%        %ֱ�Ӷ�ȡguass���Ӿ��󣬵�����guass���ӽ������ߵ�����£�
%        %Ӳ�̲���������ٶ�
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
        disp('�����С�����');
end
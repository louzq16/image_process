function new_I=zlvbo(I)
kzn=1;
kzm=2*kzn+1;
[m,n]=size(I);
new_I=uint8(I);
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
    new_I(row+kzn,1+kzn)=flag;
    
    for col=2:n-kzm+1
        tem1=I(row:row+kzm-1,col-1);
        tem2=I(row:row+kzm-1,col+kzm-1);
        for j=1:kzm
            Hist(tem1(j)+1)=Hist(tem1(j)+1)-1;
            num=num-(tem1(j)<=flag);
            Hist(tem2(j)+1)=Hist(tem2(j)+1)+1;
            num=num+(tem2(j)<=flag);
        end
        %此处可以选择，但是对速率提高不大
        while(num>=th)
            num=num-Hist(flag+1);
            flag=flag-1;
        end
        while(num<th)
            num=num+Hist(flag+2);
            flag=flag+1;
        end
        new_I(row+kzn,col+kzn)=flag;        
    end
end
end

function new_I= myhistogram(I,type)
%myFun - Description
%直方图处理 直方图均衡化（type 1) 规范化（2） 局部增强（3）
% Syntax: new_I= histogram(I,type)
%
% Long description
[m,n]=size(I);
new_I=I;
k=double(max(max(I)))/(m*n);
if type==1
    jsum=0;
    for i=0:255
        logic=(I==i);
        jsum=jsum+sum(sum(logic));
        new_I(logic)=jsum*k;
    end
else
    new_I=1;
end

end
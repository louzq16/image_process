function new_I= myhistogram(I)
%myFun - Description
%ֱ��ͼ���� ֱ��ͼ���⻯��type 1) �淶����2�� �ֲ���ǿ��3��
% Syntax: new_I= histogram(I,type)
%
% Long description
[m,n]=size(I);
new_I=I;
k=double(max(max(I)))/(m*n);
jsum=0;
for i=0:255
    logic=(I==i);
    jsum=jsum+sum(sum(logic));
    new_I(logic)=jsum*k;
end
end
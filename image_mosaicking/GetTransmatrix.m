function T_matirx=GetTransmatrix(Mpoints1,Mpoints2,type)
%根据多点拟合出变换矩阵
%输出T_matrix 变换矩阵
%输入：Mpoints1、Mpoints2输出的点对，type选择变换方式：affine仿射变换  toushe 透视变换

switch type
    case 'affine'
        [n,~]=size(Mpoints1);
        M2=[Mpoints2';ones(1,n)];
        M1=[Mpoints1';ones(1,n)];
        T_matirx=(M2'\M1')';
        T_matirx(3,:)=[0,0,1];
    case 'toushe'
        M1=Mpoints1';OUT_M=M1(:);
        [n,~]=size(Mpoints2);
        %构建求取透视矩阵的超定方程
        INPUT_M=zeros(2*n,8);
        INPUT_M(1:2:2*n-1,1:3)=[Mpoints2,ones(n,1)];
        INPUT_M(2:2:2*n,4:6)=[Mpoints2,ones(n,1)];
        INPUT_M(1:2:2*n-1,7:8)=-Mpoints2;
        INPUT_M(2:2:2*n,7:8)=-Mpoints2;
        INPUT_M(:,7:8)=INPUT_M(:,7:8).*[OUT_M,OUT_M];
        %求解超定方程
        T_matirx=pinv(INPUT_M)*OUT_M;   
    otherwise
        disp('没有这个选项');
end
function T_matirx=GetTransmatrix(Mpoints1,Mpoints2,type)
%生成图像变换矩阵
%利用最小二乘法生成最近似的变换矩阵
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
        INPUT_M=zeros(2*n,8);
        INPUT_M(1:2:2*n-1,1:3)=[Mpoints2,ones(n,1)];
        INPUT_M(2:2:2*n,4:6)=[Mpoints2,ones(n,1)];
        INPUT_M(1:2:2*n-1,7:8)=-Mpoints2;
        INPUT_M(2:2:2*n,7:8)=-Mpoints2;
        INPUT_M(:,7:8)=INPUT_M(:,7:8).*[OUT_M,OUT_M];
        %disp(INPUT_M);disp(OUT_M);
        T_matirx=pinv(INPUT_M)*OUT_M;   
end
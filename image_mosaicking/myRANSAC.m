function good_points= myRANSAC(M1,M2,max_d)
%MYRANSAC RANSAC算法筛选good_points
%输出：good_points,找到的好点在原来点集中的位置
%输入：M1，M2 配对点   max_d阈值
[m,~]=size(M1);
M1T=double([M1,ones(m,1)]);M2T=double([M2,ones(m,1)]);
M1=double(M1);M2=double(M2);
confidecnce=0.995;
I_best=1;
best_number=1;
i=1;iter=100;%初始化迭代次数为100
while i<iter
    %随机选取4个点求取透视变换矩阵
    randdata=randperm(m,4);
    tem_M1=M1(randdata,:);tem_M2=M2(randdata,:);
    tem_H=GetTransmatrix(tem_M1,tem_M2,'toushe');
    %计算透视矩阵计算坐标与实际坐标之间的差
    Model_M1=M1T;
    Model_M1(:,1:1)=(M2T*tem_H(1:3))./(M2T*[tem_H(7:8);1]);
    Model_M1(:,2:2)=(M2T*tem_H(4:6))./(M2T*[tem_H(7:8);1]);
    tem_deviation=sum((Model_M1-M1T).^2,2);
    %差小于阈值的认为是好点，存入tem_I
    tem_I=(tem_deviation<=max_d);
    if sum(tem_I)>best_number%如果这次好点比之前的好点个数多，就进行更新
        I_best=tem_I;best_number=sum(tem_I);%更新好点
        w=best_number/double(m);
        iter=abs(round(log(1-confidecnce)/log(1-w^4)));%更新迭代次数
    end
    i=i+1;
end
good_points=I_best;
end

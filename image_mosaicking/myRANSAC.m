function good_points= myRANSAC(M1,M2,max_d)
%MYRANSAC RANSAC�㷨ɸѡgood_points
%�����good_points,�ҵ��ĺõ���ԭ���㼯�е�λ��
%���룺M1��M2 ��Ե�   max_d��ֵ
[m,~]=size(M1);
M1T=double([M1,ones(m,1)]);M2T=double([M2,ones(m,1)]);
M1=double(M1);M2=double(M2);
confidecnce=0.995;
I_best=1;
best_number=1;
i=1;iter=100;%��ʼ����������Ϊ100
while i<iter
    %���ѡȡ4������ȡ͸�ӱ任����
    randdata=randperm(m,4);
    tem_M1=M1(randdata,:);tem_M2=M2(randdata,:);
    tem_H=GetTransmatrix(tem_M1,tem_M2,'toushe');
    %����͸�Ӿ������������ʵ������֮��Ĳ�
    Model_M1=M1T;
    Model_M1(:,1:1)=(M2T*tem_H(1:3))./(M2T*[tem_H(7:8);1]);
    Model_M1(:,2:2)=(M2T*tem_H(4:6))./(M2T*[tem_H(7:8);1]);
    tem_deviation=sum((Model_M1-M1T).^2,2);
    %��С����ֵ����Ϊ�Ǻõ㣬����tem_I
    tem_I=(tem_deviation<=max_d);
    if sum(tem_I)>best_number%�����κõ��֮ǰ�ĺõ�����࣬�ͽ��и���
        I_best=tem_I;best_number=sum(tem_I);%���ºõ�
        w=best_number/double(m);
        iter=abs(round(log(1-confidecnce)/log(1-w^4)));%���µ�������
    end
    i=i+1;
end
good_points=I_best;
end

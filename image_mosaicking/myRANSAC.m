function good_points= myRANSAC(M1,M2)
%MYRANSAC 此处显示有关此函数的摘要
%   此处显示详细说明
[m,~]=size(M1);
max_d=3;
M1T=double([M1,ones(m,1)]);M2T=double([M2,ones(m,1)]);
M1=double(M1);M2=double(M2);
confidecnce=0.995;
I_best=1;
best_number=1;
i=1;iter=100;
while i<iter
    randdata=randperm(m,4);
    tem_M1=M1(randdata,:);tem_M2=M2(randdata,:);
    tem_H=GetTransmatrix(tem_M1,tem_M2,'toushe');
    %disp(tem_H);
    Model_M1=M1T;
    Model_M1(:,1:1)=(M2T*tem_H(1:3))./(M2T*[tem_H(7:8);1]);
    Model_M1(:,2:2)=(M2T*tem_H(4:6))./(M2T*[tem_H(7:8);1]);
    tem_deviation=sum((Model_M1-M1T).^2,2);
    tem_I=(tem_deviation<=max_d);
    if sum(tem_I)>best_number
        I_best=tem_I;best_number=sum(tem_I);
        w=best_number/double(m);
        iter=abs(round(log(1-confidecnce)/log(1-w^4)));
        %disp(iter);
    end
    i=i+1;
end
good_points=I_best;
% maybad_points=good_points~=1;
% maybad_M1=M1(maybad_points,:);maybad_M2=M2(maybad_points,:);
% [maybadm,~]=size(maybad_M1);
% maybad_M1T=double([maybad_M1';ones(1,maybadm)]);maybad_M2T=double([maybad_M2';ones(1,maybadm)]);
% i=1;iter=100;
% max_d=20;
% confidecnce=0.99;
% I_best=1;
% best_number=1;
% while i<iter
%     randdata=randperm(maybadm,3);
%     tem_M1=maybad_M1(randdata,:);tem_M2=maybad_M2(randdata,:);
%     tem_H=GetTransmatrix(tem_M1,tem_M2);
%     Model_M1=tem_H*maybad_M2T;
%     tem_deviation=sum((Model_M1-maybad_M1T).^2);
%     tem_I=(tem_deviation<=max_d);
%     if sum(tem_I)>best_number
%         I_best=tem_I;best_number=sum(tem_I);
%         w=best_number/double(maybadm);
%         iter=abs(round(log(1-confidecnce)/log(1-w^3)));
%         disp(iter);
%     end
%     i=i+1;
% end
% good_points2=good_points;
% good_points2(good_points~=0)=0;
% good_points2(good_points~=1)=I_best;
% good_points=find(good_points);
% good_M1=M1(good_points,:);
% %特征点密度一致化
% ymax=max(good_M1(:,2:2));
% ymin=min(good_M1(:,2:2));yedge=(ymax+ymin)/2;
% xmax=max(good_M1(:,1:1));
% xmin=min(good_M1(:,1:1));xedge=(xmax+xmin)/2;
% [k,~]=size(good_M1);
% GOOD=zeros(k,4);
% GOOD(:,1:1)=(good_M1(:,1:1)<xedge).*(good_M1(:,2:2)<yedge);
% GOOD(:,2:2)=(good_M1(:,1:1)<xedge).*(good_M1(:,2:2)>=yedge);
% GOOD(:,3:3)=(good_M1(:,1:1)>=xedge).*(good_M1(:,2:2)<yedge);
% GOOD(:,4:4)=(good_M1(:,1:1)>=xedge).*(good_M1(:,2:2)>=yedge);
% number=sum(GOOD);
% numbersort=sort(number);
% disp(number);
% disp(max(sum(GOOD,2)));
% final_number=(numbersort(2)+numbersort(1))/2;
% label=find(number>final_number);
% for i=1:length(label)
%     flag=label(i);
%     temflag=GOOD(:,flag:flag);
%     temlabel=find(temflag);
%     temlabel=temlabel(1:number(flag)-final_number);
%     GOOD(temlabel,flag:flag)=0;
% end
% disp(sum(GOOD));
% good_points=good_points(sum(GOOD,2)==1);
end

% for i=1:length(imgs)
% subplot(3,3,i)
% imshow(imgs{i})
% end
processsize=506;
imgs=imgRW('img\');
[km,kn,~]=size(imgs{1});
img1=imgs{1}(1:km/processsize:km,1:kn/processsize:kn,:);
im1=rgb2gray(img1);
img1=double(img1);
im1=myhistogram(im1);
points1=detectSURFFeatures(im1,'MetricThreshold',1000.0);
[feature1,vpoints1]=extractFeatures(im1,points1);
[km,kn,~]=size(imgs{3});
img2=imgs{3}(1:km/processsize:km,1:kn/processsize:kn,:);
im2=rgb2gray(img2);
img2=double(img2);
im2=myhistogram(im2);
points2=detectSURFFeatures(im2,'MetricThreshold',1000.0);
[feature2,vpoints2]=extractFeatures(im2,points2);
indexs=matchFeatures(feature1,feature2);
matchedPoints1 = vpoints1(indexs(:,1),:);
matchedPoints2 = vpoints2(indexs(:,2),:);
disp('�����޳���ƥ���');
good_points=myRANSAC(matchedPoints1.Location,matchedPoints2.Location);
disp('�޳����');
onePoints2 =matchedPoints2(good_points,:);
onePoints1 =matchedPoints1(good_points,:);
figure(1);
%showMatchedFeatures(im1,im2,onePoints1,onePoints2,'montage');
TM=GetTransmatrix(onePoints1.Location,onePoints2.Location,'toushe');
newI=zeros(processsize*3,processsize*3,3);
newIT=newI;
[T_img,zp]=myImgtrans(img2,TM,'toushe');
[m,n,~]=size(T_img);
newIT(round(processsize)+zp(1):round(processsize)+zp(1)+m-1,round(processsize)+zp(2):round(processsize)+zp(2)+n-1,:)=T_img; 
newI(newIT~=0)=T_img(T_img~=0);
figure(2);
imshow(uint8(T_img));
% for i=1:processsize
%     for j=1:processsize
%         new_j=([j,i,1]*TM(1:3))/([j,i,1]*[TM(7:8);1]);
%         new_i=([j,i,1]*TM(4:6))/([j,i,1]*[TM(7:8);1]);
%         newI(round(processsize/2+new_i),round(processsize/2+new_j),:)=img2(i,j,:);
%     end
% end
figure(3);
newI(round(processsize)+1:round(processsize)+processsize,round(processsize)+1:round(processsize)+processsize,:)=img1;
imshow(uint8(newI));
% % 
% function [ output_args ] = mySURF( imgs ,G_D)
% %MYSURF �˴���ʾ�йش˺�����ժҪ
% %   �˴���ʾ��ϸ˵��
% N=3;sigma=(N/3)^2;
% Pi=3.1415926;
% if class(imgs)=='cell'
%     number=length(imgs);
%     for k=1:number
%         real_img=double(rgb2gray(imgs{k}));%תΪ��ɫͼ�񣿣�
%         [m,n]=size(real_img);
%         tem_img=zeros(m+2*N,n+2*N);
%         tem_img(1+N:m+N,1+N:n+N)=double(real_img);
%         %���
%         if G_D=='guass'
%             %���и�˹�˲� ����hessian����
%             %�ø�˹�����Ķ��׵�����ͼ����о����Hessian����
%             y=-N:N;y=y(ones(2*N+1,1),:);
%             x=y';
%             Guass_xx=(x.^2/sigma-1).*exp(-(x.^2+y.^2)/(2*sigma))/(2*Pi*sigma^2);
%             Guass_yy=(y.^2/sigma-1).*exp(-(x.^2+y.^2)/(2*sigma))/(2*Pi*sigma^2);
%             Guass_xy=x.*y.*exp(-(x.^2+y.^2)/(2*sigma))/(2*Pi*sigma^3);
%             %%%���ɸ�˹����ƫ��ģ��
%             tem_imgxx=zeros(m,n);tem_imgyy=tem_imgxx;tem_imgxy=tem_imgyy;
%             for i=1+N:m+N
%                 for j=1+N:n+N
%                     tem_imgxx(i-N,j-N)=sum(sum(Guass_xx.*tem_img(i-N:i+N,j-N:j+N)));
%                     tem_imgxy(i-N,j-N)=sum(sum(Guass_xy.*tem_img(i-N:i+N,j-N:j+N)));
%                     tem_imgyy(i-N,j-N)=sum(sum(Guass_yy.*tem_img(i-N:i+N,j-N:j+N)));
%                 end
%             end
%             HESSIAN=tem_imgxx.*tem_imgyy-tem_imgxy.^2;
%         else
%            disp('��д');    %��ʹ�ú�ʽ�˲�������������ٶȡ�         
%         end
%         %���hessian����  
%         
%     end
% else
% end
% end
% 
% 
% end
% 
% function 

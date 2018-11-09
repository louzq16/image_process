function [new_imgs,new_edge_imgs] = myImgregist(imgs,ratio,center,number,max_ransac)
%该函数实现图像配准
%输出：new_imgs 配准后变换的图像 new_edge_imgs 图像轮廓 图像融合时用
%输入：imgs 元胞数组，包含待拼接图像  ratio 图像缩放比例 center 指定中心图像 number SURF特征点阈值
%输入：max_ransac RANSAC算法的阈值


%读取除了选定中心图像的其他图像
imgs_number=length(imgs);
a=ones(imgs_number,1);a(center)=0;
otherimgs_position=find(a~=0);%其他图像的位置
otherimgs=cell(imgs_number-1,1);%储存其他图像
for i=1:imgs_number-1
    k=otherimgs_position(i);
    [m,n,~]=size(imgs{k});
    otherimgs{i}=imgs{k}(1:ratio:m,1:ratio:n,:);%图片按比例缩小
end
%读取中心图像
[m,n,~]=size(imgs{center});
center_img=imgs{center}(1:ratio:m,1:ratio:n,:);

%对其他图像色差调整，使其色调与中心图像一致
%采用Reinhard算法
otherimgs=myReinhard(otherimgs,center_img);

%提取其他图像特征
othergrayimgs=cell(imgs_number-1,1);
other_feature_vpoints=cell(imgs_number-1,2);
for i=1:imgs_number-1
    othergrayimgs{i}=rgb2gray(otherimgs{i});
    points=detectSURFFeatures(othergrayimgs{i},'MetricThreshold',number);
    [feature,vpoints]=extractFeatures(othergrayimgs{i},points);
    other_feature_vpoints(i,:)={feature,vpoints};
end
%提取中心图像特征
centergrayimg=rgb2gray(center_img);
points=detectSURFFeatures(centergrayimg,'MetricThreshold',number);
[center_feature,center_vpoints]=extractFeatures(centergrayimg,points);
%循环拼接时所用
model_feature_vpoints_posi=cell(1,3);
model_feature_vpoints_posi(1,1:2)={center_feature,center_vpoints};
model_feature_vpoints_posi{1,3}=0;
%储存还为变换坐标系的图像的标号
isProcess=ones(imgs_number-1,1);
%匹配好的特征点的index
otherimg_indexs=cell(imgs_number-1,1);
matchnumber=zeros(imgs_number-1,1);
other_toushi_imgs=cell(imgs_number-1,1);
edge_imgs=cell(imgs_number-1,1);
global other_TMs;
other_TMs=zeros(9,imgs_number-1);
edge_points=zeros(imgs_number,4);
begin=0;
static_otherimgs_matchposi=zeros(imgs_number-1,1);
while imgs_number>1
    fprintf('一轮图像配准开始   ');
    matchnumber(:)=0;
    %特征点匹配
    otherimgs_flag=find(isProcess~=0);
    [centerimgs_number,~]=size(model_feature_vpoints_posi);
    static_otherimgs_matchposi(:)=0;
    for i=1:imgs_number-1
        j=otherimgs_flag(i);
        maxp=0;
        for k=1:centerimgs_number
            tem_indexs=matchFeatures(model_feature_vpoints_posi{k,1},other_feature_vpoints{j,1});
            [tem_m,~]=size(tem_indexs);
            if tem_m>maxp
                maxp=tem_m;
                otherimg_indexs{j}=tem_indexs;
                static_otherimgs_matchposi(j)=k;
            end
        end
        matchnumber(j)=maxp;
    end
    %寻找认为有可拼接区域的图片 算法有待完善
    real_match=find(matchnumber>0.33*max(matchnumber));
    otherimgs_matchposi=static_otherimgs_matchposi(real_match);
    real_match_number=length(real_match);
    isProcess(real_match)=0;
    imgs_number=imgs_number-real_match_number;
    
    %透视变换
    for i=1:real_match_number
        j=real_match(i);
        tem_indexs=otherimg_indexs{j};
        pre_TM_flag=model_feature_vpoints_posi{otherimgs_matchposi(i),3};
        MP1=model_feature_vpoints_posi{otherimgs_matchposi(i),2}(tem_indexs(:,1),:);
        MP2=other_feature_vpoints{j,2}(tem_indexs(:,2),:);
        P1L=MP1.Location;
        P2L=MP2.Location;
        goodp=myRANSAC(P1L,P2L,max_ransac);
        now_TM=GetTransmatrix(P1L(goodp,:),P2L(goodp,:),'toushe');%求取到所匹配图像的变换矩阵
        real_TM=myRealTM(now_TM,pre_TM_flag);%求取到center_img变换矩阵
        other_TMs(:,j)=[real_TM;1];
        [other_toushi_imgs{begin+i},edge_imgs{begin+i},edge_points(begin+i,:)]=myImgtrans(otherimgs{j},real_TM,'toushe');
    end
    begin=begin+real_match_number;
    model_feature_vpoints_posi=cell(real_match_number,3);
    %更新model_feature_vpoints_posi
    for i=1:real_match_number
        j=real_match(i);
        model_feature_vpoints_posi(i,:)={other_feature_vpoints{j,1},other_feature_vpoints{j,2},j};
    end
    fprintf('已经完成，还有%d张图像未配准\n',imgs_number-1);
end

%平移各图像，将各图像放在大图内，方便融合
img_number=length(imgs);
new_imgs=cell(img_number,1);
[m,n,~]=size(center_img);
new_edge_imgs=cell(img_number,1);
edge_points(img_number,:)=[1,1,m,n];
%确定拼接大图的大小:i_size j_size
ij_min=min(edge_points(:,1:2));
ij_max=max(edge_points(:,3:4));
i_size=ij_max(1)-ij_min(1)+1;
j_size=ij_max(2)-ij_min(2)+1;
tem_new_img=ones(i_size,j_size,3);
tem_new_img=-tem_new_img;
for i=1:img_number-1
    %图像平移
    tem_ep=edge_points(i,:);
    tem_img=other_toushi_imgs{i};
    tem_edge_img=edge_imgs{i};
    tem_new_img(tem_ep(1)-ij_min(1)+1:tem_ep(3)-ij_min(1)+1,tem_ep(2)-ij_min(2)+1:tem_ep(4)-ij_min(2)+1,:)=tem_img;
    new_imgs{i+1}=tem_new_img;
    tem_new_img(tem_ep(1)-ij_min(1)+1:tem_ep(3)-ij_min(1)+1,tem_ep(2)-ij_min(2)+1:tem_ep(4)-ij_min(2)+1,:)=tem_edge_img;
    new_edge_imgs{i+1}=tem_new_img;
    tem_new_img(:,:,:)=-1;
end
%图像平移
[m,n,~]=size(center_img);
tem_new_img(1-ij_min(1)+1:m-ij_min(1)+1,1-ij_min(2)+1:n-ij_min(2)+1,:)=center_img;
new_imgs{1}=tem_new_img;
center_img=double(center_img);
center_img(2:m-1,2:n-1,:)=-1;
tem_new_img(1-ij_min(1)+1:m-ij_min(1)+1,1-ij_min(2)+1:n-ij_min(2)+1,:)=center_img;
new_edge_imgs{1}=tem_new_img;
disp('图像配准完成');
end

function new_TM=myRealTM(TM,TM_flag)
%利用两个透视变换矩阵生成一个直接到center_img的透视矩阵
global other_TMs
if TM_flag==0
    new_TM=TM;
else
    pre_TM=other_TMs(:,TM_flag);
    pre_TM=pre_TM';
    pre_TM=[pre_TM(1:3);pre_TM(4:6);pre_TM(7:9)];
    TM=TM';
    TM=[TM(1:3);TM(4:6);[TM(7:8),1]];
    new_TM=pre_TM*TM;
    new_TM=new_TM/new_TM(9);
    new_TM=new_TM';
    new_TM=new_TM(:);
    new_TM=new_TM(1:8);
end
end

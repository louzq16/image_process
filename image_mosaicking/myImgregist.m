function [new_imgs,new_edge_imgs] = myImgregist(imgs,ratio,center,number,max_ransac)
%�ú���ʵ��ͼ����׼
%�����new_imgs ��׼��任��ͼ�� new_edge_imgs ͼ������ ͼ���ں�ʱ��
%���룺imgs Ԫ�����飬������ƴ��ͼ��  ratio ͼ�����ű��� center ָ������ͼ�� number SURF��������ֵ
%���룺max_ransac RANSAC�㷨����ֵ


%��ȡ����ѡ������ͼ�������ͼ��
imgs_number=length(imgs);
a=ones(imgs_number,1);a(center)=0;
otherimgs_position=find(a~=0);%����ͼ���λ��
otherimgs=cell(imgs_number-1,1);%��������ͼ��
for i=1:imgs_number-1
    k=otherimgs_position(i);
    [m,n,~]=size(imgs{k});
    otherimgs{i}=imgs{k}(1:ratio:m,1:ratio:n,:);%ͼƬ��������С
end
%��ȡ����ͼ��
[m,n,~]=size(imgs{center});
center_img=imgs{center}(1:ratio:m,1:ratio:n,:);

%������ͼ��ɫ�������ʹ��ɫ��������ͼ��һ��
%����Reinhard�㷨
otherimgs=myReinhard(otherimgs,center_img);

%��ȡ����ͼ������
othergrayimgs=cell(imgs_number-1,1);
other_feature_vpoints=cell(imgs_number-1,2);
for i=1:imgs_number-1
    othergrayimgs{i}=rgb2gray(otherimgs{i});
    points=detectSURFFeatures(othergrayimgs{i},'MetricThreshold',number);
    [feature,vpoints]=extractFeatures(othergrayimgs{i},points);
    other_feature_vpoints(i,:)={feature,vpoints};
end
%��ȡ����ͼ������
centergrayimg=rgb2gray(center_img);
points=detectSURFFeatures(centergrayimg,'MetricThreshold',number);
[center_feature,center_vpoints]=extractFeatures(centergrayimg,points);
%ѭ��ƴ��ʱ����
model_feature_vpoints_posi=cell(1,3);
model_feature_vpoints_posi(1,1:2)={center_feature,center_vpoints};
model_feature_vpoints_posi{1,3}=0;
%���滹Ϊ�任����ϵ��ͼ��ı��
isProcess=ones(imgs_number-1,1);
%ƥ��õ��������index
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
    fprintf('һ��ͼ����׼��ʼ   ');
    matchnumber(:)=0;
    %������ƥ��
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
    %Ѱ����Ϊ�п�ƴ�������ͼƬ �㷨�д�����
    real_match=find(matchnumber>0.33*max(matchnumber));
    otherimgs_matchposi=static_otherimgs_matchposi(real_match);
    real_match_number=length(real_match);
    isProcess(real_match)=0;
    imgs_number=imgs_number-real_match_number;
    
    %͸�ӱ任
    for i=1:real_match_number
        j=real_match(i);
        tem_indexs=otherimg_indexs{j};
        pre_TM_flag=model_feature_vpoints_posi{otherimgs_matchposi(i),3};
        MP1=model_feature_vpoints_posi{otherimgs_matchposi(i),2}(tem_indexs(:,1),:);
        MP2=other_feature_vpoints{j,2}(tem_indexs(:,2),:);
        P1L=MP1.Location;
        P2L=MP2.Location;
        goodp=myRANSAC(P1L,P2L,max_ransac);
        now_TM=GetTransmatrix(P1L(goodp,:),P2L(goodp,:),'toushe');%��ȡ����ƥ��ͼ��ı任����
        real_TM=myRealTM(now_TM,pre_TM_flag);%��ȡ��center_img�任����
        other_TMs(:,j)=[real_TM;1];
        [other_toushi_imgs{begin+i},edge_imgs{begin+i},edge_points(begin+i,:)]=myImgtrans(otherimgs{j},real_TM,'toushe');
    end
    begin=begin+real_match_number;
    model_feature_vpoints_posi=cell(real_match_number,3);
    %����model_feature_vpoints_posi
    for i=1:real_match_number
        j=real_match(i);
        model_feature_vpoints_posi(i,:)={other_feature_vpoints{j,1},other_feature_vpoints{j,2},j};
    end
    fprintf('�Ѿ���ɣ�����%d��ͼ��δ��׼\n',imgs_number-1);
end

%ƽ�Ƹ�ͼ�񣬽���ͼ����ڴ�ͼ�ڣ������ں�
img_number=length(imgs);
new_imgs=cell(img_number,1);
[m,n,~]=size(center_img);
new_edge_imgs=cell(img_number,1);
edge_points(img_number,:)=[1,1,m,n];
%ȷ��ƴ�Ӵ�ͼ�Ĵ�С:i_size j_size
ij_min=min(edge_points(:,1:2));
ij_max=max(edge_points(:,3:4));
i_size=ij_max(1)-ij_min(1)+1;
j_size=ij_max(2)-ij_min(2)+1;
tem_new_img=ones(i_size,j_size,3);
tem_new_img=-tem_new_img;
for i=1:img_number-1
    %ͼ��ƽ��
    tem_ep=edge_points(i,:);
    tem_img=other_toushi_imgs{i};
    tem_edge_img=edge_imgs{i};
    tem_new_img(tem_ep(1)-ij_min(1)+1:tem_ep(3)-ij_min(1)+1,tem_ep(2)-ij_min(2)+1:tem_ep(4)-ij_min(2)+1,:)=tem_img;
    new_imgs{i+1}=tem_new_img;
    tem_new_img(tem_ep(1)-ij_min(1)+1:tem_ep(3)-ij_min(1)+1,tem_ep(2)-ij_min(2)+1:tem_ep(4)-ij_min(2)+1,:)=tem_edge_img;
    new_edge_imgs{i+1}=tem_new_img;
    tem_new_img(:,:,:)=-1;
end
%ͼ��ƽ��
[m,n,~]=size(center_img);
tem_new_img(1-ij_min(1)+1:m-ij_min(1)+1,1-ij_min(2)+1:n-ij_min(2)+1,:)=center_img;
new_imgs{1}=tem_new_img;
center_img=double(center_img);
center_img(2:m-1,2:n-1,:)=-1;
tem_new_img(1-ij_min(1)+1:m-ij_min(1)+1,1-ij_min(2)+1:n-ij_min(2)+1,:)=center_img;
new_edge_imgs{1}=tem_new_img;
disp('ͼ����׼���');
end

function new_TM=myRealTM(TM,TM_flag)
%��������͸�ӱ任��������һ��ֱ�ӵ�center_img��͸�Ӿ���
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

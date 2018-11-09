function Mosaicked_img=myImgfuse(timgs,edge_imgs)
%实现不规则重合区域的键入渐出融合
%输出：Mosaicked_img拼接好的图
%输出：timgs 待融合图像 edge_imgs各图像轮廓
center_img=timgs{1};
center_img_edge=edge_imgs{1};

img_number=length(timgs);
fprintf('总共需要%d次图像融合\n',img_number-1);
for i=2:img_number
    fprintf('第%d次图像融合开始   ',i-1);
    
    %求取两图像重合区域
    tem_center=center_img~=-1;
    tem_2=timgs{i}~=-1;
    both_have=tem_center.*tem_2;
    
    %求取重合区域轮廓 并且对来自不同图像的轮廓分别标记1和0
    tem2_edge=edge_imgs{i};
    both_edge=tem2_edge;
    use_center_edge=center_img_edge;
    use_center_edge(use_center_edge~=-1)=1;%对center_img的轮廓标为1
    tem_1=use_center_edge==1;
    both_edge(tem2_edge~=-1)=0;%对此轮廓标为0
    both_edge(tem_1)=use_center_edge(tem_1);%两图像轮廓相加
    center_img_edge=both_edge;
    center_img_edge(both_have~=0)=-1;%除去重叠区域轮廓，作为新拼接图像的轮廓
    both_edge(both_have==0)=-1;%留下重叠区域轮廓

    %求取标记为1的边缘点与标记为0的边缘点位置
    both_edge=both_edge(:,:,1);
    k=find(both_edge~=-1);
    zhi=both_edge(k);
    [row,col]=ind2sub(size(both_edge),k);
    row1=row(zhi==1);row0=row(zhi==0);
    col1=col(zhi==1);col0=col(zhi==0);

    %求取重合区域内的点的位置
    both_have=both_have(:,:,1);
    b=find(both_have~=0);
    [rowb,colb]=ind2sub(size(both_have),b);

    trowb=rowb';tcolb=colb';
    %计算到各点到标记为1的边缘的最小距离
    r1=size(row1);
    one_min=(trowb-row1(1)).^2+(tcolb-col1(1)).^2;
    for k=2:r1(1)
         tem_distance=(trowb-row1(k)).^2+(tcolb-col1(k)).^2;
         one_min=min([one_min;tem_distance]);
    end
    %计算到各点到标记为0的边缘的最小距离
    r0=size(row0);
    zero_min=(trowb-row0(1)).^2+(tcolb-col0(1)).^2;
    for k=2:r0(1)
         tem_distance=(trowb-row0(k)).^2+(tcolb-col0(k)).^2;
         zero_min=min([zero_min;tem_distance]);
    end
    zero_min=sqrt(zero_min);
    one_min=sqrt(one_min);

    %获得权值矩阵
    weight=zero_min./(zero_min+one_min);
    wi=both_have;
    wi(:,:)=1;
    anti_wi=wi;
    wi(b)=weight;
    anti_wi(b)=1-weight;
    
    %利用权值矩阵融合图像
    k1=center_img.*anti_wi;
    k2=timgs{i}.*wi;
    k1(k1==-1)=-0.01;k2(k2==-1)=-0.01;
    center_img=k1+k2;
    center_img(center_img==-0.02)=-1;
    fprintf('第%d次图像融合结束\n',i-1);
end
disp('图像融合完毕');
center_img=uint8(center_img);
Mosaicked_img=center_img;
end



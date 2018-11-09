function Mosaicked_img=myImgfuse(timgs,edge_imgs)
%ʵ�ֲ������غ�����ļ��뽥���ں�
%�����Mosaicked_imgƴ�Ӻõ�ͼ
%�����timgs ���ں�ͼ�� edge_imgs��ͼ������
center_img=timgs{1};
center_img_edge=edge_imgs{1};

img_number=length(timgs);
fprintf('�ܹ���Ҫ%d��ͼ���ں�\n',img_number-1);
for i=2:img_number
    fprintf('��%d��ͼ���ںϿ�ʼ   ',i-1);
    
    %��ȡ��ͼ���غ�����
    tem_center=center_img~=-1;
    tem_2=timgs{i}~=-1;
    both_have=tem_center.*tem_2;
    
    %��ȡ�غ��������� ���Ҷ����Բ�ͬͼ��������ֱ���1��0
    tem2_edge=edge_imgs{i};
    both_edge=tem2_edge;
    use_center_edge=center_img_edge;
    use_center_edge(use_center_edge~=-1)=1;%��center_img��������Ϊ1
    tem_1=use_center_edge==1;
    both_edge(tem2_edge~=-1)=0;%�Դ�������Ϊ0
    both_edge(tem_1)=use_center_edge(tem_1);%��ͼ���������
    center_img_edge=both_edge;
    center_img_edge(both_have~=0)=-1;%��ȥ�ص�������������Ϊ��ƴ��ͼ�������
    both_edge(both_have==0)=-1;%�����ص���������

    %��ȡ���Ϊ1�ı�Ե������Ϊ0�ı�Ե��λ��
    both_edge=both_edge(:,:,1);
    k=find(both_edge~=-1);
    zhi=both_edge(k);
    [row,col]=ind2sub(size(both_edge),k);
    row1=row(zhi==1);row0=row(zhi==0);
    col1=col(zhi==1);col0=col(zhi==0);

    %��ȡ�غ������ڵĵ��λ��
    both_have=both_have(:,:,1);
    b=find(both_have~=0);
    [rowb,colb]=ind2sub(size(both_have),b);

    trowb=rowb';tcolb=colb';
    %���㵽���㵽���Ϊ1�ı�Ե����С����
    r1=size(row1);
    one_min=(trowb-row1(1)).^2+(tcolb-col1(1)).^2;
    for k=2:r1(1)
         tem_distance=(trowb-row1(k)).^2+(tcolb-col1(k)).^2;
         one_min=min([one_min;tem_distance]);
    end
    %���㵽���㵽���Ϊ0�ı�Ե����С����
    r0=size(row0);
    zero_min=(trowb-row0(1)).^2+(tcolb-col0(1)).^2;
    for k=2:r0(1)
         tem_distance=(trowb-row0(k)).^2+(tcolb-col0(k)).^2;
         zero_min=min([zero_min;tem_distance]);
    end
    zero_min=sqrt(zero_min);
    one_min=sqrt(one_min);

    %���Ȩֵ����
    weight=zero_min./(zero_min+one_min);
    wi=both_have;
    wi(:,:)=1;
    anti_wi=wi;
    wi(b)=weight;
    anti_wi(b)=1-weight;
    
    %����Ȩֵ�����ں�ͼ��
    k1=center_img.*anti_wi;
    k2=timgs{i}.*wi;
    k1(k1==-1)=-0.01;k2(k2==-1)=-0.01;
    center_img=k1+k2;
    center_img(center_img==-0.02)=-1;
    fprintf('��%d��ͼ���ںϽ���\n',i-1);
end
disp('ͼ���ں����');
center_img=uint8(center_img);
Mosaicked_img=center_img;
end



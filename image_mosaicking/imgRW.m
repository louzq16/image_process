function [all_img,img_num]=imgRW(address)
%��ȡָ��Ŀ¼�µ�����jpg�ļ�
%INPUT:address ָ��Ŀ¼
%%%%������������Ŀ¼���б�ܼ� \ ����
%OUTPUT:all_img ����ͼ�� 4ά���� img_num ͼ������
img_dir=dir([address,'*jpg']);
img_num=length(img_dir);
all_img=cell(9,1);
for i=1:img_num
    all_img(i)={imread([address,img_dir(i).name])};
end
end



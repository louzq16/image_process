function [all_img,img_num]=imgRW(address)
%��ȡָ��Ŀ¼�µ�����jpg�ļ�
%INPUT:address ָ��Ŀ¼
%%%%������������Ŀ¼���б�ܼ� \ ����
%OUTPUT:all_img ����ͼ��Ԫ���������� img_num ͼ������
img_dir=dir([address,'*jpg']);
img_num=length(img_dir);
all_img=cell(img_num,1);
for i=1:img_num
    all_img(i)={imread([address,img_dir(i).name])};
end
end



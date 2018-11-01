function edge_I = edge_detect(I,type,N,binary)
%��Ե��⺯��
%I ����ͼ�� 
%type:robert sobel lalapce canny
%N ��ֵ ����robert sobel ����ֵ ����cannyΪ˫��ֵ 
%N ����laplace N[N1 m] N1Ϊ��ֵ m��1��2��ָ��ģ�� ���������Ĭ��ģ��1
%binary ����robert��sobel ��1����ֵ�� 0������ֵ��
%binary ����laplace��canny��1�����б궨 0�������б궨
global canny_edge canny_flag
[m,n]=size(I);
canny_flag=zeros(m,n);
edge_I=I;
I=double(I);
sobelx=[-1,-2,-1;0,0,0;1,2,1];
sobely=[-1,0,1;-2,0,2;-1,0,1];
switch type
    case 'robert'%robert�˲�
        for i=1:m-1
            for j=1:n-1
                edge_I(i,j)=abs(I(i+1,j+1)-I(i,j))+abs(I(i+1,j)-I(i,j+1));
            end
        end
        if binary
           edge_I(edge_I>=N)=255;
        end
    case 'sobel'%sobel�˲�
        for i=1:m-2
            for j=1:n-2
                edge_I(i+1,j+1)=abs(sum(sum(I(i:i+2,j:j+2).*sobelx)))+abs(sum(sum(I(i:i+2,j:j+2).*sobely)));
            end
        end
        edge_I(edge_I<N)=0;
        if binary
           edge_I(edge_I>=N)=255;
        end
    case 'laplace'%laplace�˲�
        lap=cat(3,[0,-1,0;-1,4,-1;0,-1,0],[-1,-1,-1;-1,8,-1;-1,-1,-1]);
        if length(N)==2
            lap=lap(:,:,N(2));
            N=N(1);
        else
            lap=lap(:,:,1);
        end
        for i=1:m-2
            for j=1:n-2
                edge_I(i+1,j+1)=abs(sum(sum(I(i:i+2,j:j+2).*lap)));
            end
        end
        edge_I(edge_I<N)=0;
        if binary
            edge_I(edge_I<N)=N;
            max_e=double(max(edge_I(:)));
            edge_I=255*(double(edge_I)-N)/(1+max_e);
        end
    case 'canny'%canny�㷨
        edge_Ix=zeros(m,n);edge_Iy=edge_Ix;tedge_I=edge_Iy;
        for i=1:m-2
            for j=1:n-2
                edge_Ix(i+1,j+1)=double(sum(sum(I(i:i+2,j:j+2).*sobelx)));
                edge_Iy(i+1,j+1)=double(sum(sum(I(i:i+2,j:j+2).*sobely)));
                tedge_I(i+1,j+1)=abs(edge_Ix(i+1,j+1))+abs(edge_Iy(i+1,j+1));
            end
        end
        %x�����y�����ݶ���ȡ
        for i=1:m-2
            for j=1:n-2
                absx=abs(edge_Ix(i+1,j+1));
                absy=abs(edge_Iy(i+1,j+1));
                dk=(2*absx<absy)*[tedge_I(i+1,j),tedge_I(i+1,j+2)]+(absx<2*absy)*(2*absx>absy)*(edge_Ix(i+1,j+1)<=0)*[tedge_I(i+2,j),tedge_I(i,j+2)];
                dk=dk+(absx>2*absy)*[tedge_I(i,j+1),tedge_I(i+2,j+1)]+(absx<2*absy)*(2*absx>absy)*(edge_Ix(i+1,j+1)>=0)*[tedge_I(i,j),tedge_I(i+2,j+2)];;
                dk=dk-tedge_I(i+1,j+1);
                edge_I(i+1,j+1)=(dk(1)<=0)*(dk(2)<=0)*tedge_I(i+1,j+1);
            end
        end
        %�Ǽ���ֵ���� ϸ����Ե
        Nmax=N(2);
        Nmin=N(1);
        edge_I(edge_I<Nmin)=0;
        edge_I(1:1,:)=0;edge_I(m:m,:)=0;edge_I(:,1:1)=0;edge_I(:,n:n)=0;
        canny_edge=edge_I;
        edge_I(edge_I<Nmax)=0;
        for i=2:m-1
            for j=2:n-1
                if edge_I(i,j)~=0&&canny_flag(i,j)==0
                   DFS(i,j);
                end
            end
        end
        %˫��ֵ����
        edge_I=canny_edge;
        edge_I(canny_flag==0)=0;
        if binary
             max_e=double(max(edge_I(:)));
             edge_I=255*double(edge_I-Nmin)/(1+max_e);
        end
    otherwise
        disp('�����С�����');
end
end


function DFS(x,y)
global canny_edge canny_flag
canny_flag(x,y)=1;
   for i=-1:1
        for j=-1:1
           if canny_edge(x+i,y+j)~=0&&canny_flag(x+i,y+j)==0
              DFS(x+i,y+j);
           end
        end
    end
end



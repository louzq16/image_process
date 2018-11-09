function [T_img,T_edge_img,zero_point]= myImgtrans(img,TransMatrix,type)
%MYIMGTRANS ���ñ任�������ͼ��任
%�����T_img �任���ͼ�� T_edge_img ͼ������ zero_point T_img�����꼫ֵ
%���룺img ���任ͼ�� TranMatrix �任����
%���룺type �任���ͣ�Ŀǰ��֧��͸�ӱ任�� toushe
switch type
    case 'toushe'   
        TT=TransMatrix';
        anti_TM=inv([TT(1:3);TT(4:6);[TT(7:8),1]]);
        anti_TM=anti_TM';anti_TM=anti_TM(:);%��ȡ��͸�ӱ任����
        [m,n,~]=size(img);
        edge_img=double(img);
        
        edge_img(2:m-1,2:n-1,:)=-1;%ԭͼ������ͼ
        
        vertex=[1,1;1,m;n,1;n,m];
        vertex=[vertex,ones(4,1)];
        new_ji=[(vertex*TransMatrix(1:3))./(vertex*[TransMatrix(7:8);1]),(vertex*TransMatrix(4:6))./(vertex*[TransMatrix(7:8);1])];
        j_min=round(min(new_ji(:,1:1)));j_max=round(max(new_ji(:,1:1)));
        i_min=round(min(new_ji(:,2:2)));i_max=round(max(new_ji(:,2:2)));
        i_size=i_max-i_min+1;j_size=j_max-j_min+1;%ȷ���任���ͼ���С
        zero_point=[i_min,j_min,i_max,j_max];%���ر任��ͼ������꼫ֵ
        offset=[j_min-1,i_min-1];offset=offset(ones(j_size,1),:);%center_img ��T_img������ƫ��
        T_img=ones(i_size,j_size,3);T_img=-T_img;
        
        T_edge_img=T_img;
        
        j_old=1:j_size;
        ji=[j_old',zeros(j_size,1),ones(j_size,1)];
        ji(:,1:1)=ji(:,1:1)+offset(:,1:1);
        for i=1:i_size
            ji(:,2:2)=i*ones(j_size,1)+offset(:,2:2);
            newp_ji=[(ji*anti_TM(1:3))./(ji*anti_TM(7:9)),(ji*anti_TM(4:6))./(ji*anti_TM(7:9))];%��ȡ��Ӧԭͼ������
            newp_ji=round(newp_ji);
            LLis=((newp_ji(:,1:1)>0).*(newp_ji(:,1:1)<=n)).*((newp_ji(:,2:2)>0).*(newp_ji(:,2:2)<=m));%��ȡ��ԭͼ��Χ֮�ڵĵ�
            tem_ji=newp_ji(LLis==1,:);
            [number,~]=size(tem_ji);
            tem_i=[tem_ji(:,2:2),tem_ji(:,2:2),tem_ji(:,2:2)];
            tem_j=[tem_ji(:,1:1),tem_ji(:,1:1),tem_ji(:,1:1)];
            yeshu=[ones(number,1),2*ones(number,1),3*ones(number,1)];
            T_img(i:i,LLis==1,:)=img(sub2ind([m,n,3],tem_i,tem_j,yeshu)); 
            T_edge_img(i:i,LLis==1,:)=edge_img(sub2ind([m,n,3],tem_i,tem_j,yeshu));%��ֵ 
        end
    otherwise
        disp('wrong');
end           
end


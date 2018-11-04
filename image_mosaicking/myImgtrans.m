function [T_img,zero_point]= myImgtrans(img,TransMatrix,type)
%MYIMGTRANS 此处显示有关此函数的摘要
%   此处显示详细说明
new_vertex=0;
switch type
    case 'toushe'
        TT=TransMatrix';
        anti_TM=inv([TT(1:3);TT(4:6);[TT(7:8),1]]);
        anti_TM=anti_TM';anti_TM=anti_TM(:);
        [m,n,~]=size(img);
        vertex=[1,1;1,m;n,1;n,m];
        vertex=[vertex,ones(4,1)];
        new_ji=[(vertex*TransMatrix(1:3))./(vertex*[TransMatrix(7:8);1]),(vertex*TransMatrix(4:6))./(vertex*[TransMatrix(7:8);1])];
        new_vertex=new_ji;
        j_min=round(min(new_ji(:,1:1)));j_max=round(max(new_ji(:,1:1)));
        i_min=round(min(new_ji(:,2:2)));i_max=round(max(new_ji(:,2:2)));
        i_size=i_max-i_min+1;j_size=j_max-j_min+1;
        zero_point=[i_min,j_min];
        offset=[j_min-1,i_min-1];offset=offset(ones(j_size,1),:);
        T_img=zeros(i_size,j_size,3);
        j_old=1:j_size;
        ji=[j_old',zeros(j_size,1),ones(j_size,1)];
        ji(:,1:1)=ji(:,1:1)+offset(:,1:1);
        for i=1:i_size
            ji(:,2:2)=i*ones(j_size,1)+offset(:,2:2);
            newp_ji=[(ji*anti_TM(1:3))./(ji*anti_TM(7:9)),(ji*anti_TM(4:6))./(ji*anti_TM(7:9))];
            newp_ji=round(newp_ji);
            LLis=((newp_ji(:,1:1)>0).*(newp_ji(:,1:1)<=n)).*((newp_ji(:,2:2)>0).*(newp_ji(:,2:2)<=m));
            tem_ji=newp_ji(LLis==1,:);
            [number,~]=size(tem_ji);
            %real_img=zeros(1,number,3);
            tem_i=[tem_ji(:,2:2);tem_ji(:,2:2);tem_ji(:,2:2)];
            tem_j=[tem_ji(:,1:1);tem_ji(:,1:1);tem_ji(:,1:1)];
            yeshu=[ones(number,1);2*ones(number,1);3*ones(number,1)];
            real_img=zeros(1,number,3);
            sind=img(sub2ind([m,n,3],tem_i,tem_j,yeshu));
            real_img(1:1,:,1:1)=sind(1:number);
            real_img(1:1,:,2:2)=sind(number+1:2*number);
            real_img(1:1,:,3:3)=sind(2*number+1:3*number);
            T_img(i:i,LLis==1,:)=real_img;        
        end
%         for i=1:m
%             ji(:,2:2)=i*ones(n,1);
%             newp_ji=[(ji*TransMatrix(1:3))./(ji*[TransMatrix(7:8);1]),(ji*TransMatrix(4:6))./(ji*[TransMatrix(7:8);1])];
%             newp_ji=round(newp_ji)-offset;
%             tem_result=[img(i:i,:,1:1),img(i:i,:,2:2),img(i:i,:,3:3)];
%             newp_i=[newp_ji(:,2:2);newp_ji(:,2:2);newp_ji(:,2:2)];
%             newp_j=[newp_ji(:,1:1);newp_ji(:,1:1);newp_ji(:,1:1)];
%             yeshu=[ones(n,1);2*ones(n,1);3*ones(n,1)];
%             T_img(sub2ind([i_size,j_size,3],newp_i,newp_j,yeshu))=tem_result;
%         end
    otherwise
        disp('wrong');
end           
end


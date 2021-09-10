function [T_new]=refine(T_old,refine_flag,N)
% inputs:
% T_old is a structure of data containing the following infomation:
% -nodes(co-ordinates of each node)
% -n(node indices for each element)
% -e(edge indices for each element)
% -t(indices for each triangle)
% -En(the endpoint node indices for each edge)
% -types(type for each element)
% -info1(intersecting vertices)
% -info2(intersecting edges)
% -num_nodes(number of nodes)
% -num_tri(number of triangles)
% -num_edges(number of edges)
% -refined(an array containing refining information for each node)
% if refine_flag==1, use dash lines(type 2 and 7)
% if refine_flag==0, don't use dash lines
% -N (if N is even, then refine type 3 and 8)

% outputs:
% T_new is a structure of data containing the following infomation:
% -nodes(co-ordinates of each node)
% -n(node indices for each element)
% -e(edge indices for each element)
% -t(indices for each triangle)
% -En(the endpoint node indices for each edge)
% -types(type for each element)
% -info1(intersecting vertices)
% -info2(intersecting edges)
% -num_nodes(number of nodes)
% -num_tir(number of triangles)
% -num_edges(number of edges)
% -refined(an array containing refining information for each node)


T_new.nodes=[];%co-ordinates
T_new.n=[];% node index
T_new.En=[];
T_new.types=[];
T_new.e=[];

num_nodes=T_old.num_nodes;
num_tri=0;
num_edges=0;

T_new.nodes(:,1:num_nodes)=T_old.nodes;

for i=1:T_old.num_tri
    
    %% type 1 triangle
    if T_old.types(i)==1 
        % A,B,C denote three indices of three nodes in this triangle i.
        A=T_old.n(1,i);
        B=T_old.n(2,i);
        C=T_old.n(3,i);
        
        % refinement on AB edge
        [Lia,Locb] = ismember([A,B],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([B,A],T_old.En','rows');
            result_1=Locb; %result_1 denotes the location of AB edge in T_old.En
        else
            result_1=Locb;
        end
        
        AB_refined=T_old.refined(:,result_1); % to determine whether there exist(s) nodes/node on AB edge.
        if AB_refined(1)==0 && AB_refined(2)==0  % no node(s) on AB, then add new nodes.
            num_nodes=num_nodes+1;  
            D=num_nodes;
            T_new.nodes(:,D)=[(2*T_old.nodes(1,A)+T_old.nodes(1,B))/3;(2*T_old.nodes(2,A)+T_old.nodes(2,B))/3];
            
            num_nodes=num_nodes+1;
            E=num_nodes;
            T_new.nodes(:,E)=[(T_old.nodes(1,A)+2*T_old.nodes(1,B))/3;(T_old.nodes(2,A)+2*T_old.nodes(2,B))/3];
            
            else
            D=AB_refined(2); % there are two nodes existing on AB, then D,E will replace these old nodes.
            E=AB_refined(1);
        end
        
            num_edges=num_edges+1;
            AD_index=num_edges;
            T_new.En(:,AD_index)=[A;D];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,AD_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            DE_index=num_edges;
            T_new.En(:,DE_index)=[D;E];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,DE_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            EB_index=num_edges;
            T_new.En(:,EB_index)=[E;B];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,EB_index)=[0;0;0;0;0;0;0];
             
        %refinement on BC edge
        [Lia,Locb] = ismember([B,C],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([C,B],T_old.En','rows');
            result_2=Locb; %result_2 denotes the location of AB edge in T_old.En
        else
            result_2=Locb;
        end
        
        BC_refined=T_old.refined(:,result_2);
        if BC_refined(1)==0 && BC_refined(2)==0
            num_nodes=num_nodes+1;
            F=num_nodes;
            T_new.nodes(:,F)=[(2*T_old.nodes(1,B)+T_old.nodes(1,C))/3;(2*T_old.nodes(2,B)+T_old.nodes(2,C))/3];
            
            num_nodes=num_nodes+1;
            G=num_nodes;
            T_new.nodes(:,G)=[(T_old.nodes(1,B)+2*T_old.nodes(1,C))/3;(T_old.nodes(2,B)+2*T_old.nodes(2,C))/3];
            
        else
            F=BC_refined(2);
            G=BC_refined(1);
        end
        
            num_edges=num_edges+1;
            BF_index=num_edges;
            T_new.En(:,BF_index)=[B;F];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,BF_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            FG_index=num_edges;
            T_new.En(:,FG_index)=[F;G];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,FG_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            GC_index=num_edges;
            T_new.En(:,GC_index)=[G;C];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,GC_index)=[0;0;0;0;0;0;0];
            
        %refinement on CA edge
        [Lia,Locb] = ismember([C,A],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([A,C],T_old.En','rows');
            result_3=Locb; %result_3 denotes the location of AB edge in T_old.En
        else
            result_3=Locb;
        end
        
        CA_refined=T_old.refined(:,result_3);
        if CA_refined(1)==0 && CA_refined(2)==0
            num_nodes=num_nodes+1;
            H=num_nodes;
            T_new.nodes(:,H)=[(T_old.nodes(1,A)+2*T_old.nodes(1,C))/3;(T_old.nodes(2,A)+2*T_old.nodes(2,C))/3];
            
            num_nodes=num_nodes+1;
            I=num_nodes;
            T_new.nodes(:,I)=[(2*T_old.nodes(1,A)+T_old.nodes(1,C))/3;(2*T_old.nodes(2,A)+T_old.nodes(2,C))/3];
            
            else
            H=CA_refined(1);
            I=CA_refined(2);
        end
        
            num_edges=num_edges+1;
            CH_index=num_edges;
            T_new.En(:,CH_index)=[C;H];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,CH_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            HI_index=num_edges;
            T_new.En(:,HI_index)=[H;I];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,HI_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            IA_index=num_edges;
            T_new.En(:,IA_index)=[I;A];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,IA_index)=[0;0;0;0;0;0;0];
        
        num_nodes=num_nodes+1;
        J=num_nodes;
        T_new.nodes(:,J)=[(T_new.nodes(1,E)+T_new.nodes(1,H))/2;(T_new.nodes(2,E)+T_new.nodes(2,H))/2];
        
        %Now we need to add new edges
                
        num_edges=num_edges+1;
        DI_index=num_edges;
        T_new.En(:,DI_index)=[D;I];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,DI_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        DJ_index=num_edges;
        T_new.En(:,DJ_index)=[D;J];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,DJ_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        JI_index=num_edges;
        T_new.En(:,JI_index)=[J;I];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,JI_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        EJ_index=num_edges;
        T_new.En(:,EJ_index)=[E;J];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,EJ_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        JH_index=num_edges;
        T_new.En(:,JH_index)=[J;H];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,JH_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        EF_index=num_edges;
        T_new.En(:,EF_index)=[E;F];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,EF_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        FJ_index=num_edges;
        T_new.En(:,FJ_index)=[F;J];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,FJ_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        JG_index=num_edges;
        T_new.En(:,JG_index)=[J;G];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,JG_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        GH_index=num_edges;
        T_new.En(:,GH_index)=[G;H];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,GH_index)=[0;0;0;0;0;0;0];
        
        % Now we need to add 9 new triangles, and update types of these triangles
        num_tri=num_tri+1;
        ADI_index=num_tri;
        T_new.n(:,ADI_index)=[A;D;I];
        T_new.types(:,ADI_index)=3;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        JDE_index=num_tri;
        T_new.n(:,JDE_index)=[J;D;E];
        T_new.types(:,JDE_index)=2;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        JID_index=num_tri;
        T_new.n(:,JID_index)=[J;I;D];
        T_new.types(:,JID_index)=2;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        JHI_index=num_tri;
        T_new.n(:,JHI_index)=[J;H;I];
        T_new.types(:,JHI_index)=2;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        EBF_index=num_tri;
        T_new.n(:,EBF_index)=[E;B;F];
        T_new.types(:,EBF_index)=1;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        EFJ_index=num_tri;
        T_new.n(:,EFJ_index)=[E;F;J];
        T_new.types(:,EFJ_index)=1;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        JFG_index=num_tri;
        T_new.n(:,JFG_index)=[J;F;G];
        T_new.types(:,JFG_index)=4;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        HJG_index=num_tri;
        T_new.n(:,HJG_index)=[H;J;G];
        T_new.types(:,HJG_index)=1;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        HGC_index=num_tri;
        T_new.n(:,HGC_index)=[H;G;C];
        T_new.types(:,HGC_index)=1;
        T_new.t(:,num_tri)=num_tri;
        
        
        %update T_new.num_nodes, T_new.num_edges and T_new.num_tri
        T_new.num_nodes=num_nodes;
        T_new.num_edges=num_edges;
        T_new.num_tri=num_tri;
        
        plot([T_new.nodes(1,A),T_new.nodes(1,B),T_new.nodes(1,C),T_new.nodes(1,A)],[T_new.nodes(2,A),T_new.nodes(2,B),T_new.nodes(2,C),T_new.nodes(2,A)],'b')
        hold on
        plot([T_new.nodes(1,D),T_new.nodes(1,J),T_new.nodes(1,I),T_new.nodes(1,D)],[T_new.nodes(2,D),T_new.nodes(2,J),T_new.nodes(2,I),T_new.nodes(2,D)],'b')
        hold on
        plot([T_new.nodes(1,E),T_new.nodes(1,F),T_new.nodes(1,J),T_new.nodes(1,E)],[T_new.nodes(2,E),T_new.nodes(2,F),T_new.nodes(2,J),T_new.nodes(2,E)],'b')
        hold on
        plot([T_new.nodes(1,J),T_new.nodes(1,G),T_new.nodes(1,H),T_new.nodes(1,J)],[T_new.nodes(2,J),T_new.nodes(2,G),T_new.nodes(2,H),T_new.nodes(2,J)],'b')
        hold all
        
        text((T_new.nodes(1,A)+T_new.nodes(1,D)+T_new.nodes(1,I))/3,(T_new.nodes(2,A)+T_new.nodes(2,D)+T_new.nodes(2,I))/3,int2str(3))
        text((T_new.nodes(1,D)+T_new.nodes(1,E)+T_new.nodes(1,J))/3,(T_new.nodes(2,D)+T_new.nodes(2,E)+T_new.nodes(2,J))/3,int2str(2))
        text((T_new.nodes(1,D)+T_new.nodes(1,J)+T_new.nodes(1,I))/3,(T_new.nodes(2,D)+T_new.nodes(2,J)+T_new.nodes(2,I))/3,int2str(2))
        text((T_new.nodes(1,I)+T_new.nodes(1,J)+T_new.nodes(1,H))/3,(T_new.nodes(2,I)+T_new.nodes(2,J)+T_new.nodes(2,H))/3,int2str(2))
        text((T_new.nodes(1,E)+T_new.nodes(1,B)+T_new.nodes(1,F))/3,(T_new.nodes(2,E)+T_new.nodes(2,B)+T_new.nodes(2,F))/3,int2str(1))
        text((T_new.nodes(1,E)+T_new.nodes(1,F)+T_new.nodes(1,J))/3,(T_new.nodes(2,E)+T_new.nodes(2,F)+T_new.nodes(2,J))/3,int2str(1))
        text((T_new.nodes(1,J)+T_new.nodes(1,F)+T_new.nodes(1,G))/3,(T_new.nodes(2,J)+T_new.nodes(2,F)+T_new.nodes(2,G))/3,int2str(4))
        text((T_new.nodes(1,J)+T_new.nodes(1,G)+T_new.nodes(1,H))/3,(T_new.nodes(2,J)+T_new.nodes(2,G)+T_new.nodes(2,H))/3,int2str(1))
        text((T_new.nodes(1,H)+T_new.nodes(1,G)+T_new.nodes(1,C))/3,(T_new.nodes(2,H)+T_new.nodes(2,G)+T_new.nodes(2,C))/3,int2str(1))
        
        T_new.info1=[];
        T_new.info2=[B,F;F,J;J,G;G,C]';
    end
        
    
    %% type 2 triangle
    if T_old.types(i)==2
        % A,B,C denote three indices of three nodes in this triangle i.
        A=T_old.n(1,i);
        B=T_old.n(2,i);
        C=T_old.n(3,i);
        
        % refinement on AB edge
        [Lia,Locb] = ismember([A,B],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([B,A],T_old.En','rows');
            result_1=Locb; %result_1 denotes the location of AB edge in T_old.En
        else
            result_1=Locb;
        end
        
        AB_refined=T_old.refined(:,result_1);
        if AB_refined(1)==0 && AB_refined(2)==0
            num_nodes=num_nodes+1;
            D=num_nodes;
            T_new.nodes(:,D)=[(2*T_old.nodes(1,A)+T_old.nodes(1,B))/3;(2*T_old.nodes(2,A)+T_old.nodes(2,B))/3];
            
            num_nodes=num_nodes+1;
            E=num_nodes;
            T_new.nodes(:,E)=[(T_old.nodes(1,A)+2*T_old.nodes(1,B))/3;(T_old.nodes(2,A)+2*T_old.nodes(2,B))/3];
            
            else
            D=AB_refined(2);
            E=AB_refined(1);
        end
            num_edges=num_edges+1;
            AD_index=num_edges;
            T_new.En(:,AD_index)=[A;D];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,AD_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            DE_index=num_edges;
            T_new.En(:,DE_index)=[D;E];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,DE_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            EB_index=num_edges;
            T_new.En(:,EB_index)=[E;B];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,EB_index)=[0;0;0;0;0;0;0];
        
        %refinement on CA edge
        [Lia,Locb] = ismember([C,A],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([A,C],T_old.En','rows');
            result_3=Locb; %result_3 denotes the location of AB edge in T_old.En
        else
            result_3=Locb;
        end
        
        CA_refined=T_old.refined(:,result_3);
        if CA_refined(1)==0 && CA_refined(2)==0
            num_nodes=num_nodes+1;
            G=num_nodes;
            T_new.nodes(:,G)=[(T_old.nodes(1,A)+2*T_old.nodes(1,C))/3;(T_old.nodes(2,A)+2*T_old.nodes(2,C))/3];
            
            num_nodes=num_nodes+1;
            H=num_nodes;
            T_new.nodes(:,H)=[(2*T_old.nodes(1,A)+T_old.nodes(1,C))/3;(2*T_old.nodes(2,A)+T_old.nodes(2,C))/3];
            
            else
            G=CA_refined(2);
            H=CA_refined(1);
        end
            
            num_edges=num_edges+1;
            CG_index=num_edges;
            T_new.En(:,CG_index)=[C;G];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,CG_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            GH_index=num_edges;
            T_new.En(:,GH_index)=[G;H];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,GH_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            HA_index=num_edges;
            T_new.En(:,HA_index)=[H;A];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,HA_index)=[0;0;0;0;0;0;0];
        
        num_nodes=num_nodes+1;
        I=num_nodes;
        T_new.nodes(:,I)=[(T_new.nodes(1,E)+T_new.nodes(1,G))/2;(T_new.nodes(2,E)+T_new.nodes(2,G))/2];
        
        %Now add new edges
        
        num_edges=num_edges+1;
        DI_index=num_edges;
        T_new.En(:,DI_index)=[D;I];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,DI_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        IH_index=num_edges;
        T_new.En(:,IH_index)=[I;H];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,IH_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        HD_index=num_edges;
        T_new.En(:,HD_index)=[H;D];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,HD_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        EI_index=num_edges;
        T_new.En(:,EI_index)=[E;I];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,EI_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        IG_index=num_edges;
        T_new.En(:,IG_index)=[I;G];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,IG_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        IB_index=num_edges;
        T_new.En(:,IB_index)=[I;B];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,IB_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        IC_index=num_edges;
        T_new.En(:,IC_index)=[I;C];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,IC_index)=[0;0;0;0;0;0;0];
        
        % Now we need to add 7/8 new triangles, and update types of these triangles
        num_tri=num_tri+1;
        ADH_index=num_tri;
        T_new.n(:,ADH_index)=[A;D;H];
        T_new.types(:,ADH_index)=2;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        DEI_index=num_tri;
        T_new.n(:,DEI_index)=[D;E;I];
        T_new.types(:,DEI_index)=3;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        DIH_index=num_tri;
        T_new.n(:,DIH_index)=[D;I;H];
        T_new.types(:,DIH_index)=3;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        HIG_index=num_tri;
        T_new.n(:,HIG_index)=[H;I;G];
        T_new.types(:,HIG_index)=3;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        EBI_index=num_tri;
        T_new.n(:,EBI_index)=[E;B;I];
        T_new.types(:,EBI_index)=3;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        ICG_index=num_tri;
        T_new.n(:,ICG_index)=[I;C;G];
        T_new.types(:,ICG_index)=3;
        T_new.t(:,num_tri)=num_tri;
        
        %refinement on BC edge
        [Lia,Locb] = ismember([B,C],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([C,B],T_old.En','rows');
            result_2=Locb; %result_2 denotes the location of AB edge in T_old.En
        else
            result_2=Locb;
        end
        
        BC_refined=T_old.refined(:,result_2);
        if BC_refined(1)==0 && BC_refined(2)==0
            num_nodes=num_nodes+1;
            F=num_nodes;
            T_new.nodes(:,F)=[(T_old.nodes(1,B)+T_old.nodes(1,C))/2;(T_old.nodes(2,B)+T_old.nodes(2,C))/2];
            
            else
                F=BC_refined(1);
        end
        
        if refine_flag==1
            num_edges=num_edges+1;
            BF_index=num_edges;
            T_new.En(:,BF_index)=[B;F];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,BF_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            FC_index=num_edges;
            T_new.En(:,FC_index)=[F;C];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,FC_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            IF_index=num_edges;
            T_new.En(:,IF_index)=[I;F];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,IF_index)=[0;0;0;0;0;0;0];
            
            num_tri=num_tri+1;
            IBF_index=num_tri;
            T_new.n(:,IBF_index)=[I;B;F];
            T_new.types(:,IBF_index)=3;
            T_new.t(:,num_tri)=num_tri;
            
            num_tri=num_tri+1;
            IFC_index=num_tri;
            T_new.n(:,IFC_index)=[I;F;C];
            T_new.types(:,IFC_index)=3;
            T_new.t(:,num_tri)=num_tri;
            
        elseif refine_flag==0
            num_edges=num_edges+1;
            BC_index=num_edges;
            T_new.En(:,BC_index)=[B;C];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,BC_index)=[0;0;0;0;0;0;0];
            
            num_tri=num_tri+1;
            IBC_index=num_tri;
            T_new.n(:,IBC_index)=[I;B;C];
            T_new.types(:,IBC_index)=3;
            T_new.t(:,num_tri)=num_tri;
            
        end
        
        %update T_new.num_nodes, T_new.num_edges and T_new.num_tri
        T_new.num_nodes=num_nodes;
        T_new.num_edges=num_edges;
        T_new.num_tri=num_tri;
        
        if refine_flag==1
            
            plot([T_new.nodes(1,A),T_new.nodes(1,B),T_new.nodes(1,C),T_new.nodes(1,A)],[T_new.nodes(2,A),T_new.nodes(2,B),T_new.nodes(2,C),T_new.nodes(2,A)],'b')
            hold on
            plot([T_new.nodes(1,D),T_new.nodes(1,I),T_new.nodes(1,H),T_new.nodes(1,D)],[T_new.nodes(2,D),T_new.nodes(2,I),T_new.nodes(2,H),T_new.nodes(2,D)],'b')
            hold on
            plot([T_new.nodes(1,E),T_new.nodes(1,I),T_new.nodes(1,B),T_new.nodes(1,E)],[T_new.nodes(2,E),T_new.nodes(2,I),T_new.nodes(2,B),T_new.nodes(2,E)],'b')
            hold on
            plot([T_new.nodes(1,I),T_new.nodes(1,C),T_new.nodes(1,G),T_new.nodes(1,I)],[T_new.nodes(2,I),T_new.nodes(2,C),T_new.nodes(2,G),T_new.nodes(2,I)],'b')
            hold on
            plot([T_new.nodes(1,I),T_new.nodes(1,B),T_new.nodes(1,F),T_new.nodes(1,I)],[T_new.nodes(2,I),T_new.nodes(2,B),T_new.nodes(2,F),T_new.nodes(2,I)],'b')
            hold on
            plot([T_new.nodes(1,I),T_new.nodes(1,F),T_new.nodes(1,C),T_new.nodes(1,I)],[T_new.nodes(2,I),T_new.nodes(2,F),T_new.nodes(2,C),T_new.nodes(2,I)],'b')
            hold all
            
            text((T_new.nodes(1,A)+T_new.nodes(1,D)+T_new.nodes(1,H))/3,(T_new.nodes(2,A)+T_new.nodes(2,D)+T_new.nodes(2,H))/3,int2str(2))
            text((T_new.nodes(1,D)+T_new.nodes(1,E)+T_new.nodes(1,I))/3,(T_new.nodes(2,D)+T_new.nodes(2,E)+T_new.nodes(2,I))/3,int2str(3))
            text((T_new.nodes(1,D)+T_new.nodes(1,I)+T_new.nodes(1,H))/3,(T_new.nodes(2,D)+T_new.nodes(2,I)+T_new.nodes(2,H))/3,int2str(3))
            text((T_new.nodes(1,H)+T_new.nodes(1,I)+T_new.nodes(1,G))/3,(T_new.nodes(2,H)+T_new.nodes(2,I)+T_new.nodes(2,G))/3,int2str(3))
            text((T_new.nodes(1,E)+T_new.nodes(1,B)+T_new.nodes(1,I))/3,(T_new.nodes(2,E)+T_new.nodes(2,B)+T_new.nodes(2,I))/3,int2str(3))
            text((T_new.nodes(1,I)+T_new.nodes(1,B)+T_new.nodes(1,F))/3,(T_new.nodes(2,I)+T_new.nodes(2,B)+T_new.nodes(2,F))/3,int2str(3))
            text((T_new.nodes(1,I)+T_new.nodes(1,F)+T_new.nodes(1,C))/3,(T_new.nodes(2,I)+T_new.nodes(2,F)+T_new.nodes(2,C))/3,int2str(3))
            text((T_new.nodes(1,I)+T_new.nodes(1,C)+T_new.nodes(1,G))/3,(T_new.nodes(2,I)+T_new.nodes(2,C)+T_new.nodes(2,G))/3,int2str(3))
            
        elseif refine_flag==0
            
            plot([T_new.nodes(1,A),T_new.nodes(1,B),T_new.nodes(1,C),T_new.nodes(1,A)],[T_new.nodes(2,A),T_new.nodes(2,B),T_new.nodes(2,C),T_new.nodes(2,A)],'b')
            hold on
            plot([T_new.nodes(1,D),T_new.nodes(1,I),T_new.nodes(1,H),T_new.nodes(1,D)],[T_new.nodes(2,D),T_new.nodes(2,I),T_new.nodes(2,H),T_new.nodes(2,D)],'b')
            hold on
            plot([T_new.nodes(1,E),T_new.nodes(1,I),T_new.nodes(1,B),T_new.nodes(1,E)],[T_new.nodes(2,E),T_new.nodes(2,I),T_new.nodes(2,B),T_new.nodes(2,E)],'b')
            hold on
            plot([T_new.nodes(1,I),T_new.nodes(1,C),T_new.nodes(1,G),T_new.nodes(1,I)],[T_new.nodes(2,I),T_new.nodes(2,C),T_new.nodes(2,G),T_new.nodes(2,I)],'b')
            hold all
            
            text((T_new.nodes(1,A)+T_new.nodes(1,D)+T_new.nodes(1,H))/3,(T_new.nodes(2,A)+T_new.nodes(2,D)+T_new.nodes(2,H))/3,int2str(2))
            text((T_new.nodes(1,D)+T_new.nodes(1,E)+T_new.nodes(1,I))/3,(T_new.nodes(2,D)+T_new.nodes(2,E)+T_new.nodes(2,I))/3,int2str(3))
            text((T_new.nodes(1,D)+T_new.nodes(1,I)+T_new.nodes(1,H))/3,(T_new.nodes(2,D)+T_new.nodes(2,I)+T_new.nodes(2,H))/3,int2str(3))
            text((T_new.nodes(1,H)+T_new.nodes(1,I)+T_new.nodes(1,G))/3,(T_new.nodes(2,H)+T_new.nodes(2,I)+T_new.nodes(2,G))/3,int2str(3))
            text((T_new.nodes(1,E)+T_new.nodes(1,B)+T_new.nodes(1,I))/3,(T_new.nodes(2,E)+T_new.nodes(2,B)+T_new.nodes(2,I))/3,int2str(3))
            text((T_new.nodes(1,I)+T_new.nodes(1,B)+T_new.nodes(1,C))/3,(T_new.nodes(2,I)+T_new.nodes(2,B)+T_new.nodes(2,C))/3,int2str(3))
            text((T_new.nodes(1,I)+T_new.nodes(1,C)+T_new.nodes(1,G))/3,(T_new.nodes(2,I)+T_new.nodes(2,C)+T_new.nodes(2,G))/3,int2str(3))
        
        end
            T_new.info1=[A];
            T_new.info2=[];
                
    end
        
     %% type 3
     if T_old.types(i)==3 && rem(N,2)==0
        % A,B,C denote three indices of three nodes in this triangle i.
        A=T_old.n(1,i);
        B=T_old.n(2,i);
        C=T_old.n(3,i);
      
            
        [Lia,Locb] = ismember([A,B],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([B,A],T_old.En','rows');
            result_1=Locb; %result_1 denotes the location of AB edge in T_old.En
        else
            result_1=Locb;
        end
        
        AB_refined=T_old.refined(:,result_1);
        if AB_refined(1)==0 && AB_refined(3)==0
            num_nodes=num_nodes+1;
            D=num_nodes;
            T_new.nodes(:,D)=[(T_old.nodes(1,A)+T_old.nodes(1,B))/2;(T_old.nodes(2,A)+T_old.nodes(2,B))/2];%coordinates for new nodes
            
        else
            D=AB_refined(1);
        end
            num_edges=num_edges+1;
            AD_index=num_edges;
            T_new.En(:,AD_index)=[A;D];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,AD_index)=[0;0;0;0;0;0;0];
        
            num_edges=num_edges+1;
            DB_index=num_edges;
            T_new.En(:,DB_index)=[D;B];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,DB_index)=[0;0;0;0;0;0;0];
        
        [Lia,Locb] = ismember([B,C],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([C,B],T_old.En','rows');
            result_2=Locb; %result_2 denotes the location of BC edge in T_old.En
        else
            result_2=Locb;
        end
        
        BC_refined=T_old.refined(:,result_2);
        if BC_refined(1)==0 && BC_refined(3)==0
            num_nodes=num_nodes+1;
            E=num_nodes;
            T_new.nodes(:,E)=[(T_old.nodes(1,B)+T_old.nodes(1,C))/2;(T_old.nodes(2,B)+T_old.nodes(2,C))/2];%coordinates for new nodes
            
        else
            E=BC_refined(1);
        end
        
            num_edges=num_edges+1;
            BE_index=num_edges;
            T_new.En(:,BE_index)=[B;E];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,BE_index)=[0;0;0;0;0;0;0];
        
            num_edges=num_edges+1;
            EC_index=num_edges;
            T_new.En(:,EC_index)=[E;C];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,EC_index)=[0;0;0;0;0;0;0];
           
        
        [Lia,Locb] = ismember([C,A],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([A,C],T_old.En','rows');
            result_3=Locb; %result_3 denotes the location of AC edge in T_old.En
        else
            result_3=Locb;
        end
        
        CA_refined=T_old.refined(:,result_3);
        if CA_refined(1)==0 && CA_refined(3)==0
            num_nodes=num_nodes+1;
            F=num_nodes;
            T_new.nodes(:,F)=[(T_old.nodes(1,C)+T_old.nodes(1,A))/2;(T_old.nodes(2,C)+T_old.nodes(2,A))/2];%coordinates for new nodes
              
        else
            F=CA_refined(1);
        end
        
            num_edges=num_edges+1;
            CF_index=num_edges;
            T_new.En(:,CF_index)=[C;F];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,CF_index)=[0;0;0;0;0;0;0];
        
            num_edges=num_edges+1;
            FA_index=num_edges;
            T_new.En(:,FA_index)=[F;A]; 
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,FA_index)=[0;0;0;0;0;0;0];
            
        % Now we need to add 4 new triangles, and update types of these triangles
        num_tri=num_tri+1;
        ADF_index=num_tri;
        T_new.n(:,ADF_index)=[A;D;F];
        T_new.types(:,ADF_index)=3;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        DBE_index=num_tri;
        T_new.n(:,DBE_index)=[D;B;E];
        T_new.types(:,DBE_index)=3;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        DEF_index=num_tri;
        T_new.n(:,DEF_index)=[D;E;F];
        T_new.types(:,DEF_index)=3;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        FEC_index=num_tri;
        T_new.n(:,FEC_index)=[F;E;C];
        T_new.types(:,FEC_index)=3;
        T_new.t(:,num_tri)=num_tri;
        
        %Now we need to add new edges
                
        num_edges=num_edges+1;
        DE_index=num_edges;
        T_new.En(:,DE_index)=[D;E];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,DE_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        EF_index=num_edges;
        T_new.En(:,EF_index)=[E;F];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,EF_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        FD_index=num_edges;
        T_new.En(:,FD_index)=[F;D];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,FD_index)=[0;0;0;0;0;0;0];
        
        
        %update T_new.num_nodes, T_new.num_edges and T_new.num_tri
        T_new.num_nodes=num_nodes;
        T_new.num_edges=num_edges;
        T_new.num_tri=num_tri;
       
        plot([T_new.nodes(1,A),T_new.nodes(1,B),T_new.nodes(1,C),T_new.nodes(1,A)],[T_new.nodes(2,A),T_new.nodes(2,B),T_new.nodes(2,C),T_new.nodes(2,A)],'b')
        hold on
        plot([T_new.nodes(1,D),T_new.nodes(1,E),T_new.nodes(1,F),T_new.nodes(1,D)],[T_new.nodes(2,D),T_new.nodes(2,E),T_new.nodes(2,F),T_new.nodes(2,D)],'b')
        hold all
        
        text((T_new.nodes(1,A)+T_new.nodes(1,D)+T_new.nodes(1,F))/3,(T_new.nodes(2,A)+T_new.nodes(2,D)+T_new.nodes(2,F))/3,int2str(3))
        text((T_new.nodes(1,D)+T_new.nodes(1,E)+T_new.nodes(1,F))/3,(T_new.nodes(2,D)+T_new.nodes(2,E)+T_new.nodes(2,F))/3,int2str(3))
        text((T_new.nodes(1,D)+T_new.nodes(1,B)+T_new.nodes(1,E))/3,(T_new.nodes(2,D)+T_new.nodes(2,B)+T_new.nodes(2,E))/3,int2str(3))
        text((T_new.nodes(1,F)+T_new.nodes(1,E)+T_new.nodes(1,C))/3,(T_new.nodes(2,F)+T_new.nodes(2,E)+T_new.nodes(2,C))/3,int2str(3))
        
        T_new.info1=[];
        T_new.info2=[];
        
     elseif T_old.types(i)==3 && rem(N,2)~=0
         A=T_old.n(1,i);
         B=T_old.n(2,i);
         C=T_old.n(3,i);
         
         if isempty(T_new.En)==1
            T_new.En=[0;0];
         end
        
         [Lia,Locb] = ismember([A,B],T_old.En','rows');
         [Lia1,Locb1] = ismember([A,B],T_new.En','rows');
        if Locb~=0 && Locb1==0
            num_edges=num_edges+1;
            AB_index=num_edges;
            T_new.En(:,AB_index)=[A;B];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,AB_index)=[0;0;0;0;0;0;0];
        else
            [Lia,Locb] = ismember([B,A],T_old.En','rows');
            [Lia1,Locb1] = ismember([B,A],T_new.En','rows');
            if Locb~=0 && Locb1==0
                num_edges=num_edges+1;
                AB_index=num_edges;
                T_new.En(:,AB_index)=[A;B];
                T_new.e(:,num_edges)=num_edges;
                T_new.refined(:,AB_index)=[0;0;0;0;0;0;0];
            end
        end
            
            
        [Lia,Locb] = ismember([B,C],T_old.En','rows');
        [Lia1,Locb1] = ismember([B,C],T_new.En','rows');
        if Locb~=0 && Locb1==0
            num_edges=num_edges+1;
            BC_index=num_edges;
            T_new.En(:,BC_index)=[B;C];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,BC_index)=[0;0;0;0;0;0;0];
        else
            [Lia,Locb] = ismember([C,B],T_old.En','rows');
            [Lia1,Locb1] = ismember([C,B],T_new.En','rows');
            if Locb~=0 7& Locb1==0
                num_edges=num_edges+1;
                BC_index=num_edges;
                T_new.En(:,BC_index)=[B;C];
                T_new.e(:,num_edges)=num_edges;
                T_new.refined(:,BC_index)=[0;0;0;0;0;0;0];
            end
        end
        
        [Lia,Locb] = ismember([A,C],T_old.En','rows');
        [Lia1,Locb1] = ismember([A,C],T_new.En','rows');
        if Locb~=0 && Locb1==0
            num_edges=num_edges+1;
            CA_index=num_edges;
            T_new.En(:,CA_index)=[C;A];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,CA_index)=[0;0;0;0;0;0;0];
        else
            [Lia,Locb] = ismember([C,A],T_old.En','rows');
            [Lia1,Locb1] = ismember([C,A],T_new.En','rows');
            if Locb~=0 && Locb1==0
                num_edges=num_edges+1;
                CA_index=num_edges;
                T_new.En(:,CA_index)=[C;A];
                T_new.e(:,num_edges)=num_edges;
                T_new.refined(:,CA_index)=[0;0;0;0;0;0;0];
            end
        end
         
          %add a triangle
         num_tri=num_tri+1;
         ABC_index=num_tri;
         T_new.n(:,ABC_index)=[A;B;C];
         T_new.types(:,ABC_index)=3;
         T_new.t(:,num_tri)=num_tri;
         
         T_new.num_edges=num_edges;
         T_new.num_tri=num_tri;
         num_nodes=num_nodes;
         T_new.num_nodes=num_nodes;
         T_new.info1=[];
         T_new.info2=[];
         T_new.e(:,num_edges)=num_edges;
         T_new.t(:,num_tri)=num_tri;
         
         plot([T_old.nodes(1,A),T_old.nodes(1,B),T_old.nodes(1,C),T_old.nodes(1,A)],[T_old.nodes(2,A),T_old.nodes(2,B),T_old.nodes(2,C),T_old.nodes(2,A)],'b')
         hold all
         text((T_old.nodes(1,A)+T_old.nodes(1,B)+T_old.nodes(1,C))/3,(T_old.nodes(2,A)+T_old.nodes(2,B)+T_old.nodes(2,C))/3,int2str(3))
                
     end
    
     %% type 4
     if T_old.types(i)==4
        % A,B,C denote three indices of three nodes in this triangle i.
        A=T_old.n(1,i);
        B=T_old.n(2,i);
        C=T_old.n(3,i);
        
        % refinement on AB edge
        [Lia,Locb] = ismember([A,B],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([B,A],T_old.En','rows');
            result_1=Locb; %result_1 denotes the location of AB edge in T_old.En
        else
            result_1=Locb;
        end
        
        AB_refined=T_old.refined(:,result_1);
        if AB_refined(1)==0 && AB_refined(2)==0
            num_nodes=num_nodes+1;
            D=num_nodes;
            T_new.nodes(:,D)=[(2*T_old.nodes(1,A)+T_old.nodes(1,B))/3;(2*T_old.nodes(2,A)+T_old.nodes(2,B))/3];
            
            num_nodes=num_nodes+1;
            E=num_nodes;
            T_new.nodes(:,E)=[(T_old.nodes(1,A)+2*T_old.nodes(1,B))/3;(T_old.nodes(2,A)+2*T_old.nodes(2,B))/3];
            
        else
            D=AB_refined(2);
            E=AB_refined(1);
        end
        
            num_edges=num_edges+1;
            AD_index=num_edges;
            T_new.En(:,AD_index)=[A;D];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,AD_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            DE_index=num_edges;
            T_new.En(:,DE_index)=[D;E];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,DE_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            EB_index=num_edges;
            T_new.En(:,EB_index)=[E;B];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,EB_index)=[0;0;0;0;0;0;0];
           
        
        %refinement on BC edge
        [Lia,Locb] = ismember([B,C],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([C,B],T_old.En','rows');
            result_2=Locb; %result_2 denotes the location of AB edge in T_old.En
        else
            result_2=Locb;
        end
        
        BC_refined=T_old.refined(:,result_2);
        if BC_refined(1)==0 && BC_refined(2)==0
            num_nodes=num_nodes+1;
            F=num_nodes;
            T_new.nodes(:,F)=[(2*T_old.nodes(1,B)+T_old.nodes(1,C))/3;(2*T_old.nodes(2,B)+T_old.nodes(2,C))/3];
            
            num_nodes=num_nodes+1;
            G=num_nodes;
            T_new.nodes(:,G)=[(T_old.nodes(1,B)+2*T_old.nodes(1,C))/3;(T_old.nodes(2,B)+2*T_old.nodes(2,C))/3];
            
        else
            F=AB_refined(2);
            G=AB_refined(1);
        end
        
            num_edges=num_edges+1;
            BF_index=num_edges;
            T_new.En(:,BF_index)=[B;F];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,BF_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            FG_index=num_edges;
            T_new.En(:,FG_index)=[F;G];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,FG_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            GC_index=num_edges;
            T_new.En(:,GC_index)=[G;C];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,GC_index)=[0;0;0;0;0;0;0];
          
        
        %refinement on CA edge
        [Lia,Locb] = ismember([C,A],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([A,C],T_old.En','rows');
            result_3=Locb; %result_3 denotes the location of AB edge in T_old.En
        else
            result_3=Locb;
        end
        
        CA_refined=T_old.refined(:,result_3);
        if CA_refined(1)==0 && CA_refined(2)==0
            num_nodes=num_nodes+1;
            H=num_nodes;
            T_new.nodes(:,H)=[(T_old.nodes(1,A)+2*T_old.nodes(1,C))/3;(T_old.nodes(2,A)+2*T_old.nodes(2,C))/3];
                
            num_nodes=num_nodes+1;
            I=num_nodes;
            T_new.nodes(:,I)=[(2*T_old.nodes(1,A)+T_old.nodes(1,C))/3;(2*T_old.nodes(2,A)+T_old.nodes(2,C))/3];
            
        else
            H=AB_refined(2);
            I=AB_refined(1);
        end
            num_edges=num_edges+1;
            CH_index=num_edges;
            T_new.En(:,CH_index)=[C;H];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,CH_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            HI_index=num_edges;
            T_new.En(:,HI_index)=[H;I];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,HI_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            IA_index=num_edges;
            T_new.En(:,IA_index)=[I;A];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,IA_index)=[0;0;0;0;0;0;0];
        
        num_nodes=num_nodes+1;
        J=num_nodes;
        T_new.nodes(:,J)=[(T_new.nodes(1,E)+T_new.nodes(1,H))/2;(T_new.nodes(2,E)+T_new.nodes(2,H))/2];
        
        %Now we need to add new edges
                
        num_edges=num_edges+1;
        DI_index=num_edges;
        T_new.En(:,DI_index)=[D;I];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,DI_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        DJ_index=num_edges;
        T_new.En(:,DJ_index)=[D;J];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,DJ_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        JI_index=num_edges;
        T_new.En(:,JI_index)=[J;I];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,JI_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        EJ_index=num_edges;
        T_new.En(:,EJ_index)=[E;J];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,EJ_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        JH_index=num_edges;
        T_new.En(:,JH_index)=[J;H];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,JH_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        EF_index=num_edges;
        T_new.En(:,EF_index)=[E;F];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,EF_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        FJ_index=num_edges;
        T_new.En(:,FJ_index)=[F;J];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,FJ_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        JG_index=num_edges;
        T_new.En(:,JG_index)=[J;G];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,JG_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        GH_index=num_edges;
        T_new.En(:,GH_index)=[G;H];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,GH_index)=[0;0;0;0;0;0;0];
        
        % Now we need to add 9 new triangles, and update types of these triangles
        num_tri=num_tri+1;
        ADI_index=num_tri;
        T_new.n(:,ADI_index)=[A;D;I];
        T_new.types(:,ADI_index)=4;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        JDE_index=num_tri;
        T_new.n(:,JDE_index)=[J;D;E];
        T_new.types(:,JDE_index)=6;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        JID_index=num_tri;
        T_new.n(:,JID_index)=[J;I;D];
        T_new.types(:,JID_index)=6;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        JHI_index=num_tri;
        T_new.n(:,JHI_index)=[J;H;I];
        T_new.types(:,JHI_index)=6;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        FEB_index=num_tri;
        T_new.n(:,FEB_index)=[F;E;B];
        T_new.types(:,FEB_index)=5;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        EFJ_index=num_tri;
        T_new.n(:,EFJ_index)=[E;F;J];
        T_new.types(:,EFJ_index)=7;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        JFG_index=num_tri;
        T_new.n(:,JFG_index)=[J;F;G];
        T_new.types(:,JFG_index)=8;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        HJG_index=num_tri;
        T_new.n(:,HJG_index)=[H;J;G];
        T_new.types(:,HJG_index)=7;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        GCH_index=num_tri;
        T_new.n(:,GCH_index)=[G;C;H];
        T_new.types(:,GCH_index)=5;
        T_new.t(:,num_tri)=num_tri;
        
        %update T_new.num_nodes, T_new.num_edges and T_new.num_tri
        T_new.num_nodes=num_nodes;
        T_new.num_edges=num_edges;
        T_new.num_tri=num_tri;
        
        plot([T_new.nodes(1,A),T_new.nodes(1,B),T_new.nodes(1,C),T_new.nodes(1,A)],[T_new.nodes(2,A),T_new.nodes(2,B),T_new.nodes(2,C),T_new.nodes(2,A)],'b')
        hold on
        plot([T_new.nodes(1,D),T_new.nodes(1,J),T_new.nodes(1,I),T_new.nodes(1,D)],[T_new.nodes(2,D),T_new.nodes(2,J),T_new.nodes(2,I),T_new.nodes(2,D)],'b')
        hold on
        plot([T_new.nodes(1,E),T_new.nodes(1,F),T_new.nodes(1,J),T_new.nodes(1,E)],[T_new.nodes(2,E),T_new.nodes(2,F),T_new.nodes(2,J),T_new.nodes(2,E)],'b')
        hold on
        plot([T_new.nodes(1,J),T_new.nodes(1,G),T_new.nodes(1,H),T_new.nodes(1,J)],[T_new.nodes(2,J),T_new.nodes(2,G),T_new.nodes(2,H),T_new.nodes(2,J)],'b')
        hold all
        
        text((T_new.nodes(1,A)+T_new.nodes(1,D)+T_new.nodes(1,I))/3,(T_new.nodes(2,A)+T_new.nodes(2,D)+T_new.nodes(2,I))/3,int2str(4))
        text((T_new.nodes(1,D)+T_new.nodes(1,E)+T_new.nodes(1,J))/3,(T_new.nodes(2,D)+T_new.nodes(2,E)+T_new.nodes(2,J))/3,int2str(6))
        text((T_new.nodes(1,D)+T_new.nodes(1,J)+T_new.nodes(1,I))/3,(T_new.nodes(2,D)+T_new.nodes(2,J)+T_new.nodes(2,I))/3,int2str(6))
        text((T_new.nodes(1,I)+T_new.nodes(1,J)+T_new.nodes(1,H))/3,(T_new.nodes(2,I)+T_new.nodes(2,J)+T_new.nodes(2,H))/3,int2str(6))
        text((T_new.nodes(1,E)+T_new.nodes(1,B)+T_new.nodes(1,F))/3,(T_new.nodes(2,E)+T_new.nodes(2,B)+T_new.nodes(2,F))/3,int2str(5))
        text((T_new.nodes(1,E)+T_new.nodes(1,F)+T_new.nodes(1,J))/3,(T_new.nodes(2,E)+T_new.nodes(2,F)+T_new.nodes(2,J))/3,int2str(7))
        text((T_new.nodes(1,J)+T_new.nodes(1,F)+T_new.nodes(1,G))/3,(T_new.nodes(2,J)+T_new.nodes(2,F)+T_new.nodes(2,G))/3,int2str(8))
        text((T_new.nodes(1,J)+T_new.nodes(1,G)+T_new.nodes(1,H))/3,(T_new.nodes(2,J)+T_new.nodes(2,G)+T_new.nodes(2,H))/3,int2str(7))
        text((T_new.nodes(1,H)+T_new.nodes(1,G)+T_new.nodes(1,C))/3,(T_new.nodes(2,H)+T_new.nodes(2,G)+T_new.nodes(2,C))/3,int2str(5))
              
        T_new.info1=[D;E;H;I];
        T_new.info2=[A,D;E,B;C,H;I,A]';
     end
     
     %% type 5
     if T_old.types(i)==5
        % A,B,C denote three indices of three nodes in this triangle i.
        A=T_old.n(1,i);
        B=T_old.n(2,i);
        C=T_old.n(3,i);
        
        % refinement on AB edge
        [Lia,Locb] = ismember([A,B],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([B,A],T_old.En','rows');
            result_1=Locb; %result_1 denotes the location of AB edge in T_old.En
        else
            result_1=Locb;
        end
        
        AB_refined=T_old.refined(:,result_1);
        if AB_refined(1)==0 && AB_refined(3)==0
            num_nodes=num_nodes+1;
            D=num_nodes;
            T_new.nodes(:,D)=[(T_old.nodes(1,A)+2*T_old.nodes(1,B))/3;(T_old.nodes(2,A)+2*T_old.nodes(2,B))/3];
            
        else
            D=AB_refined(1);
        end
        
            num_edges=num_edges+1;
            AD_index=num_edges;
            T_new.En(:,AD_index)=[A;D];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,AD_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            DB_index=num_edges;
            T_new.En(:,DB_index)=[D;B];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,DB_index)=[0;0;0;0;0;0;0];
            
        %refinement on BC edge
        [Lia,Locb] = ismember([B,C],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([C,B],T_old.En','rows');
            result_2=Locb; %result_2 denotes the location of AB edge in T_old.En
        else
            result_2=Locb;
        end
        
        BC_refined=T_old.refined(:,result_2);
        if BC_refined(1)==0 && BC_refined(2)==0
            num_nodes=num_nodes+1;
            E=num_nodes;
            T_new.nodes(:,E)=[(2*T_old.nodes(1,B)+T_old.nodes(1,C))/3;(2*T_old.nodes(2,B)+T_old.nodes(2,C))/3];
                
            num_nodes=num_nodes+1;
            F=num_nodes;
            T_new.nodes(:,F)=[(T_old.nodes(1,B)+2*T_old.nodes(1,C))/3;(T_old.nodes(2,B)+2*T_old.nodes(2,C))/3];
            
        else
            E=BC_refined(2);
            F=BC_refined(1);
        end
            num_edges=num_edges+1;
            BE_index=num_edges;
            T_new.En(:,BE_index)=[B;E];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,BE_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            EF_index=num_edges;
            T_new.En(:,EF_index)=[E;F];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,EF_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            FC_index=num_edges;
            T_new.En(:,FC_index)=[F;C];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,FC_index)=[0;0;0;0;0;0;0];
        
        %refinement on CA edge
        [Lia,Locb] = ismember([C,A],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([A,C],T_old.En','rows');
            result_3=Locb; %result_3 denotes the location of AB edge in T_old.En
        else
            result_3=Locb;
        end
        
        CA_refined=T_old.refined(:,result_3);
        if CA_refined(1)==0 && CA_refined(2)==0
            num_nodes=num_nodes+1;
            G=num_nodes;
            T_new.nodes(:,G)=[(T_old.nodes(1,A)+2*T_old.nodes(1,C))/3;(T_old.nodes(2,A)+2*T_old.nodes(2,C))/3];
            
        else
            G=CA_refined(1);
        end
        
            num_edges=num_edges+1;
            CG_index=num_edges;
            T_new.En(:,CG_index)=[C;G];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,CG_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            GA_index=num_edges;
            T_new.En(:,GA_index)=[G;A];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,GA_index)=[0;0;0;0;0;0;0];
        
        num_nodes=num_nodes+1;
        H=num_nodes;
        T_new.nodes(:,H)=[(T_new.nodes(1,G)+T_new.nodes(1,D))/2;(T_new.nodes(2,G)+T_new.nodes(2,D))/2];
        
        num_edges=num_edges+1;
        DE_index=num_edges;
        T_new.En(:,DE_index)=[D;E];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,DE_index)=[0;0;0;0;0;0;0];
            
        num_edges=num_edges+1;
        EH_index=num_edges;
        T_new.En(:,EH_index)=[E;H];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,EH_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        HD_index=num_edges;
        T_new.En(:,HD_index)=[H;D];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,HD_index)=[0;0;0;0;0;0;0];
            
        num_edges=num_edges+1;
        HF_index=num_edges;
        T_new.En(:,HF_index)=[H;F];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,HF_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        FG_index=num_edges;
        T_new.En(:,FG_index)=[F;G];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,FG_index)=[0;0;0;0;0;0;0];
            
        num_edges=num_edges+1;
        GH_index=num_edges;
        T_new.En(:,GH_index)=[G;H];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,GH_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        HA_index=num_edges;
        T_new.En(:,HA_index)=[H;A];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,HA_index)=[0;0;0;0;0;0;0];
            
        % Now we need to add 7 new triangles, and update types of these triangles
        num_tri=num_tri+1;
        ADH_index=num_tri;
        T_new.n(:,ADH_index)=[A;D;H];
        T_new.types(:,ADH_index)=8;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        AHG_index=num_tri;
        T_new.n(:,AHG_index)=[A;H;G];
        T_new.types(:,AHG_index)=8;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        DBE_index=num_tri;
        T_new.n(:,DBE_index)=[D;B;E];
        T_new.types(:,DBE_index)=5;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        EHD_index=num_tri;
        T_new.n(:,EHD_index)=[E;H;D];
        T_new.types(:,EHD_index)=7;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        HEF_index=num_tri;
        T_new.n(:,HEF_index)=[H;E;F];
        T_new.types(:,HEF_index)=6;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        FGH_index=num_tri;
        T_new.n(:,FGH_index)=[F;G;H];
        T_new.types(:,FGH_index)=7;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        GFC_index=num_tri;
        T_new.n(:,GFC_index)=[G;F;C];
        T_new.types(:,GFC_index)=5;
        T_new.t(:,num_tri)=num_tri;
        
        %update T_new.num_nodes, T_new.num_edges and T_new.num_tri
        T_new.num_nodes=num_nodes;
        T_new.num_edges=num_edges;
        T_new.num_tri=num_tri;
        
        plot([T_new.nodes(1,A),T_new.nodes(1,B),T_new.nodes(1,C),T_new.nodes(1,A)],[T_new.nodes(2,A),T_new.nodes(2,B),T_new.nodes(2,C),T_new.nodes(2,A)],'b')
        hold on
        plot([T_new.nodes(1,D),T_new.nodes(1,H),T_new.nodes(1,A),T_new.nodes(1,D)],[T_new.nodes(2,D),T_new.nodes(2,H),T_new.nodes(2,A),T_new.nodes(2,D)],'b')
        hold on
        plot([T_new.nodes(1,E),T_new.nodes(1,H),T_new.nodes(1,D),T_new.nodes(1,E)],[T_new.nodes(2,E),T_new.nodes(2,H),T_new.nodes(2,D),T_new.nodes(2,E)],'b')
        hold on
        plot([T_new.nodes(1,F),T_new.nodes(1,G),T_new.nodes(1,H),T_new.nodes(1,F)],[T_new.nodes(2,F),T_new.nodes(2,G),T_new.nodes(2,H),T_new.nodes(2,F)],'b')
        hold on
        plot([T_new.nodes(1,A),T_new.nodes(1,G),T_new.nodes(1,H),T_new.nodes(1,A)],[T_new.nodes(2,A),T_new.nodes(2,G),T_new.nodes(2,H),T_new.nodes(2,A)],'b')
        hold all
        
        text((T_new.nodes(1,A)+T_new.nodes(1,D)+T_new.nodes(1,H))/3,(T_new.nodes(2,A)+T_new.nodes(2,D)+T_new.nodes(2,H))/3,int2str(8))
        text((T_new.nodes(1,A)+T_new.nodes(1,H)+T_new.nodes(1,G))/3,(T_new.nodes(2,A)+T_new.nodes(2,H)+T_new.nodes(2,G))/3,int2str(8))
        text((T_new.nodes(1,D)+T_new.nodes(1,B)+T_new.nodes(1,E))/3,(T_new.nodes(2,D)+T_new.nodes(2,B)+T_new.nodes(2,E))/3,int2str(5))
        text((T_new.nodes(1,D)+T_new.nodes(1,E)+T_new.nodes(1,H))/3,(T_new.nodes(2,D)+T_new.nodes(2,E)+T_new.nodes(2,H))/3,int2str(7))
        text((T_new.nodes(1,H)+T_new.nodes(1,E)+T_new.nodes(1,F))/3,(T_new.nodes(2,H)+T_new.nodes(2,E)+T_new.nodes(2,F))/3,int2str(6))
        text((T_new.nodes(1,H)+T_new.nodes(1,F)+T_new.nodes(1,G))/3,(T_new.nodes(2,H)+T_new.nodes(2,F)+T_new.nodes(2,G))/3,int2str(7))
        text((T_new.nodes(1,F)+T_new.nodes(1,C)+T_new.nodes(1,G))/3,(T_new.nodes(2,F)+T_new.nodes(2,C)+T_new.nodes(2,G))/3,int2str(5))
              
        T_new.info1=[E;F];
        T_new.info2=[B,E;F,C]';
     end
     
     %% type 6
     if T_old.types(i)==6
        % A,B,C denote three indices of three nodes in this triangle i.
        A=T_old.n(1,i);
        B=T_old.n(2,i);
        C=T_old.n(3,i);
        
        % refinement on AB edge
        [Lia,Locb] = ismember([A,B],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([B,A],T_old.En','rows');
            result_1=Locb; %result_1 denotes the location of AB edge in T_old.En
        else
            result_1=Locb;
        end
        
        AB_refined=T_old.refined(:,result_1);
        if AB_refined(1)==0 && AB_refined(3)==0
            num_nodes=num_nodes+1;
            D=num_nodes;
            T_new.nodes(:,D)=[(T_old.nodes(1,A)+2*T_old.nodes(1,B))/3;(T_old.nodes(2,A)+2*T_old.nodes(2,B))/3];   
        else
            D=AB_refined(1);
        end
            
            num_edges=num_edges+1;
            AD_index=num_edges;
            T_new.En(:,AD_index)=[A;D];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,AD_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            DB_index=num_edges;
            T_new.En(:,DB_index)=[D;B];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,DB_index)=[0;0;0;0;0;0;0];
       
        %refinement on BC edge
        [Lia,Locb] = ismember([B,C],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([C,B],T_old.En','rows');
            result_2=Locb; %result_2 denotes the location of AB edge in T_old.En
        else
            result_2=Locb;
        end
        
        BC_refined=T_old.refined(:,result_2);
        if BC_refined(1)==0 && BC_refined(2)==0
            num_nodes=num_nodes+1;
            E=num_nodes;
            T_new.nodes(:,E)=[(2*T_old.nodes(1,B)+T_old.nodes(1,C))/3;(2*T_old.nodes(2,B)+T_old.nodes(2,C))/3];
                
            num_nodes=num_nodes+1;
            F=num_nodes;
            T_new.nodes(:,F)=[(T_old.nodes(1,B)+2*T_old.nodes(1,C))/3;(T_old.nodes(2,B)+2*T_old.nodes(2,C))/3];
             
        else
            E=BC_refined(2);
            F=BC_refined(1);
        end
        
            num_edges=num_edges+1;
            BE_index=num_edges;
            T_new.En(:,BE_index)=[B;E];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,BE_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            EF_index=num_edges;
            T_new.En(:,EF_index)=[E;F];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,EF_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            FC_index=num_edges;
            T_new.En(:,FC_index)=[F;C];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,FC_index)=[0;0;0;0;0;0;0];
            
        %refinement on CA edge
        [Lia,Locb] = ismember([C,A],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([A,C],T_old.En','rows');
            result_3=Locb; %result_3 denotes the location of AB edge in T_old.En
        else
            result_3=Locb;
        end
        
        CA_refined=T_old.refined(:,result_3);
        if CA_refined(1)==0 && CA_refined(2)==0
            num_nodes=num_nodes+1;
            G=num_nodes;
            T_new.nodes(:,G)=[(T_old.nodes(1,A)+2*T_old.nodes(1,C))/3;(T_old.nodes(2,A)+2*T_old.nodes(2,C))/3];
            
        else
            G=CA_refined(1);
        end
            
            num_edges=num_edges+1;
            CG_index=num_edges;
            T_new.En(:,CG_index)=[C;G];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,CG_index)=[0;0;0;0;0;0;0];
            
            num_edges=num_edges+1;
            GA_index=num_edges;
            T_new.En(:,GA_index)=[G;A];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,GA_index)=[0;0;0;0;0;0;0];
            
        num_nodes=num_nodes+1;
        H=num_nodes;
        T_new.nodes(:,H)=[(T_new.nodes(1,G)+T_new.nodes(1,D))/2;(T_new.nodes(2,G)+T_new.nodes(2,D))/2];
        
        num_edges=num_edges+1;
        DE_index=num_edges;
        T_new.En(:,DE_index)=[D;E];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,DE_index)=[0;0;0;0;0;0;0];
            
        num_edges=num_edges+1;
        EH_index=num_edges;
        T_new.En(:,EH_index)=[E;H];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,EH_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        HD_index=num_edges;
        T_new.En(:,HD_index)=[H;D];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,HD_index)=[0;0;0;0;0;0;0];
            
        num_edges=num_edges+1;
        HF_index=num_edges;
        T_new.En(:,HF_index)=[H;F];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,HF_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        FG_index=num_edges;
        T_new.En(:,FG_index)=[F;G];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,FG_index)=[0;0;0;0;0;0;0];
            
        num_edges=num_edges+1;
        GH_index=num_edges;
        T_new.En(:,GH_index)=[G;H];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,GH_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        HA_index=num_edges;
        T_new.En(:,HA_index)=[H;A];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,HA_index)=[0;0;0;0;0;0;0];
            
        % Now we need to add 7 new triangles, and update types of these triangles
        num_tri=num_tri+1;
        ADH_index=num_tri;
        T_new.n(:,ADH_index)=[A;D;H];
        T_new.types(:,ADH_index)=8;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        AHG_index=num_tri;
        T_new.n(:,AHG_index)=[A;H;G];
        T_new.types(:,AHG_index)=8;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        BED_index=num_tri;
        T_new.n(:,BED_index)=[B;E;D];
        T_new.types(:,BED_index)=7;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        EHD_index=num_tri;
        T_new.n(:,EHD_index)=[E;H;D];
        T_new.types(:,EHD_index)=8;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        HEF_index=num_tri;
        T_new.n(:,HEF_index)=[H;E;F];
        T_new.types(:,HEF_index)=8;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        FGH_index=num_tri;
        T_new.n(:,FGH_index)=[F;G;H];
        T_new.types(:,FGH_index)=8;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        CGF_index=num_tri;
        T_new.n(:,CGF_index)=[C;G;F];
        T_new.types(:,CGF_index)=7;
        T_new.t(:,num_tri)=num_tri;
        
        %update T_new.num_nodes, T_new.num_edges and T_new.num_tri
        T_new.num_nodes=num_nodes;
        T_new.num_edges=num_edges;
        T_new.num_tri=num_tri;
        
        plot([T_new.nodes(1,A),T_new.nodes(1,B),T_new.nodes(1,C),T_new.nodes(1,A)],[T_new.nodes(2,A),T_new.nodes(2,B),T_new.nodes(2,C),T_new.nodes(2,A)],'b')
        hold on
        plot([T_new.nodes(1,D),T_new.nodes(1,H),T_new.nodes(1,A),T_new.nodes(1,D)],[T_new.nodes(2,D),T_new.nodes(2,H),T_new.nodes(2,A),T_new.nodes(2,D)],'b')
        hold on
        plot([T_new.nodes(1,E),T_new.nodes(1,H),T_new.nodes(1,D),T_new.nodes(1,E)],[T_new.nodes(2,E),T_new.nodes(2,H),T_new.nodes(2,D),T_new.nodes(2,E)],'b')
        hold on
        plot([T_new.nodes(1,F),T_new.nodes(1,G),T_new.nodes(1,H),T_new.nodes(1,F)],[T_new.nodes(2,F),T_new.nodes(2,G),T_new.nodes(2,H),T_new.nodes(2,F)],'b')
        hold on
        plot([T_new.nodes(1,A),T_new.nodes(1,G),T_new.nodes(1,H),T_new.nodes(1,A)],[T_new.nodes(2,A),T_new.nodes(2,G),T_new.nodes(2,H),T_new.nodes(2,A)],'b')
        hold all
        
        text((T_new.nodes(1,A)+T_new.nodes(1,D)+T_new.nodes(1,H))/3,(T_new.nodes(2,A)+T_new.nodes(2,D)+T_new.nodes(2,H))/3,int2str(8))
        text((T_new.nodes(1,A)+T_new.nodes(1,H)+T_new.nodes(1,G))/3,(T_new.nodes(2,A)+T_new.nodes(2,H)+T_new.nodes(2,G))/3,int2str(8))
        text((T_new.nodes(1,D)+T_new.nodes(1,B)+T_new.nodes(1,E))/3,(T_new.nodes(2,D)+T_new.nodes(2,B)+T_new.nodes(2,E))/3,int2str(7))
        text((T_new.nodes(1,D)+T_new.nodes(1,E)+T_new.nodes(1,H))/3,(T_new.nodes(2,D)+T_new.nodes(2,E)+T_new.nodes(2,H))/3,int2str(8))
        text((T_new.nodes(1,H)+T_new.nodes(1,E)+T_new.nodes(1,F))/3,(T_new.nodes(2,H)+T_new.nodes(2,E)+T_new.nodes(2,F))/3,int2str(8))
        text((T_new.nodes(1,H)+T_new.nodes(1,F)+T_new.nodes(1,G))/3,(T_new.nodes(2,H)+T_new.nodes(2,F)+T_new.nodes(2,G))/3,int2str(8))
        text((T_new.nodes(1,F)+T_new.nodes(1,C)+T_new.nodes(1,G))/3,(T_new.nodes(2,F)+T_new.nodes(2,C)+T_new.nodes(2,G))/3,int2str(7))
                  
        T_new.info1=[B;C];
        T_new.info2=[];
     end
     
     %% type 7
     if T_old.types(i)==7
        % A,B,C denote three indices of three nodes in this triangle i.
        A=T_old.n(1,i);
        B=T_old.n(2,i);
        C=T_old.n(3,i);
        
        [Lia,Locb] = ismember([A,B],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([B,A],T_old.En','rows');
            result_1=Locb; %result_1 denotes the location of AB edge in T_old.En
        else
            result_1=Locb;
        end
        
        AB_refined=T_old.refined(:,result_1);
        if AB_refined(1)==0 && AB_refined(3)==0
            num_nodes=num_nodes+1;
            D=num_nodes;
            T_new.nodes(:,D)=[(2*T_old.nodes(1,A)+T_old.nodes(1,B))/3;(2*T_old.nodes(2,A)+T_old.nodes(2,B))/3];
             
        else
            D=AB_refined(1);
        end
        
            num_edges=num_edges+1;
            AD_index=num_edges;
            T_new.En(:,AD_index)=[A;D];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,AD_index)=[0;0;0;0;0;0;0];
        
            num_edges=num_edges+1;
            DB_index=num_edges;
            T_new.En(:,DB_index)=[D;B];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,DB_index)=[0;0;0;0;0;0;0];
            
        %refinement on CA edge
        [Lia,Locb] = ismember([C,A],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([A,C],T_old.En','rows');
            result_3=Locb; %result_3 denotes the location of AB edge in T_old.En
        else
            result_3=Locb;
        end
        
        CA_refined=T_old.refined(:,result_3);
        if CA_refined(1)==0 && CA_refined(2)==0
            num_nodes=num_nodes+1;
            F=num_nodes;
            T_new.nodes(:,F)=[(2*T_old.nodes(1,A)+T_old.nodes(1,C))/3;(2*T_old.nodes(2,A)+T_old.nodes(2,C))/3];
            
        else
            F=CA_refined(1);
        end
            num_edges=num_edges+1;
            CF_index=num_edges;
            T_new.En(:,CF_index)=[C;F];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,CF_index)=[0;0;0;0;0;0;0];
        
            num_edges=num_edges+1;
            FA_index=num_edges;
            T_new.En(:,FA_index)=[F;A];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,FA_index)=[0;0;0;0;0;0;0];
        
        %refinement on BC edge
        [Lia,Locb] = ismember([B,C],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([C,B],T_old.En','rows');
            result_2=Locb; %result_2 denotes the location of AB edge in T_old.En
        else
            result_2=Locb;
        end
        
        BC_refined=T_old.refined(:,result_2);
        if BC_refined(1)==0 && BC_refined(3)==0
            num_nodes=num_nodes+1;
            E=num_nodes;
            T_new.nodes(:,E)=[(T_old.nodes(1,B)+T_old.nodes(1,C))/2;(T_old.nodes(2,B)+T_old.nodes(2,C))/2];
        else
            E=BC_refined(1);
        end
        
            num_nodes=num_nodes+1;
            G=num_nodes;
            T_new.nodes(:,G)=[T_old.nodes(1,A)-(T_old.nodes(1,A)-T_new.nodes(1,E))*2/3;T_old.nodes(2,A)-(T_old.nodes(2,A)-T_new.nodes(2,E))*2/3];
            
            num_edges=num_edges+1;
            BE_index=num_edges;
            T_new.En(:,BE_index)=[B;E];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,BE_index)=[0;0;0;0;0;0;0];
        
            num_edges=num_edges+1;
            EC_index=num_edges;
            T_new.En(:,EC_index)=[E;C];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,EC_index)=[0;0;0;0;0;0;0];
                       
            if refine_flag==1
                num_edges=num_edges+1;
                GE_index=num_edges;
                T_new.En(:,GE_index)=[G;E];
                T_new.e(:,num_edges)=num_edges;
                T_new.refined(:,GE_index)=[0;0;0;0;0;0;0];
   
            
                num_tri=num_tri+1;
                BEG_index=num_tri;
                T_new.n(:,BEG_index)=[B;E;G];
                T_new.types(:,BEG_index)=8;
                T_new.t(:,num_tri)=num_tri;
                
                num_tri=num_tri+1;
                GEC_index=num_tri;
                T_new.n(:,GEC_index)=[G;E;C];
                T_new.types(:,GEC_index)=8;
                T_new.t(:,num_tri)=num_tri;
                                
            elseif refine_flag==0
                num_tri=num_tri+1;
                GBC_index=num_tri;
                T_new.n(:,GBC_index)=[G;B;C];
                T_new.types(:,GBC_index)=8;
                T_new.t(:,num_tri)=num_tri;
            end
        
        % Now add new edges
        num_edges=num_edges+1;
        DG_index=num_edges;
        T_new.En(:,DG_index)=[D;G];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,DG_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        GF_index=num_edges;
        T_new.En(:,GF_index)=[G;F];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,GF_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        FD_index=num_edges;
        T_new.En(:,FD_index)=[F;D];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,FD_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        BG_index=num_edges;
        T_new.En(:,BG_index)=[B;G];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,BG_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        GC_index=num_edges;
        T_new.En(:,GC_index)=[G;C];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,GC_index)=[0;0;0;0;0;0;0];
        
        % Add new triangles
        num_tri=num_tri+1;
        ADF_index=num_tri;
        T_new.n(:,ADF_index)=[A;D;F];
        T_new.types(:,ADF_index)=7;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        DGF_index=num_tri;
        T_new.n(:,DGF_index)=[D;G;F];
        T_new.types(:,DGF_index)=8;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        DBG_index=num_tri;
        T_new.n(:,DBG_index)=[D;B;G];
        T_new.types(:,DBG_index)=8;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        GCF_index=num_tri;
        T_new.n(:,GCF_index)=[G;C;F];
        T_new.types(:,GCF_index)=8;
        T_new.t(:,num_tri)=num_tri;
        
        %update T_new.num_nodes, T_new.num_edges and T_new.num_tri
        T_new.num_nodes=num_nodes;
        T_new.num_edges=num_edges;
        T_new.num_tri=num_tri;
        
        if BC_refined(1)==0 && BC_refined(2)==0 && refine_flag==1
           
            plot([T_new.nodes(1,A),T_new.nodes(1,B),T_new.nodes(1,C),T_new.nodes(1,A)],[T_new.nodes(2,A),T_new.nodes(2,B),T_new.nodes(2,C),T_new.nodes(2,A)],'b')
            hold on
            plot([T_new.nodes(1,D),T_new.nodes(1,G),T_new.nodes(1,F),T_new.nodes(1,D)],[T_new.nodes(2,D),T_new.nodes(2,G),T_new.nodes(2,F),T_new.nodes(2,D)],'b')
            hold on
            plot([T_new.nodes(1,B),T_new.nodes(1,E),T_new.nodes(1,G),T_new.nodes(1,B)],[T_new.nodes(2,B),T_new.nodes(2,E),T_new.nodes(2,G),T_new.nodes(2,B)],'b')
            hold on
            plot([T_new.nodes(1,G),T_new.nodes(1,E),T_new.nodes(1,C),T_new.nodes(1,G)],[T_new.nodes(2,G),T_new.nodes(2,E),T_new.nodes(2,C),T_new.nodes(2,G)],'b')
            hold all
            
            text((T_new.nodes(1,A)+T_new.nodes(1,D)+T_new.nodes(1,F))/3,(T_new.nodes(2,A)+T_new.nodes(2,D)+T_new.nodes(2,F))/3,int2str(7))
            text((T_new.nodes(1,D)+T_new.nodes(1,G)+T_new.nodes(1,F))/3,(T_new.nodes(2,D)+T_new.nodes(2,G)+T_new.nodes(2,F))/3,int2str(8))
            text((T_new.nodes(1,D)+T_new.nodes(1,B)+T_new.nodes(1,G))/3,(T_new.nodes(2,D)+T_new.nodes(2,B)+T_new.nodes(2,G))/3,int2str(8))
            text((T_new.nodes(1,G)+T_new.nodes(1,B)+T_new.nodes(1,E))/3,(T_new.nodes(2,G)+T_new.nodes(2,B)+T_new.nodes(2,E))/3,int2str(8))
            text((T_new.nodes(1,G)+T_new.nodes(1,E)+T_new.nodes(1,C))/3,(T_new.nodes(2,G)+T_new.nodes(2,E)+T_new.nodes(2,C))/3,int2str(8))
            text((T_new.nodes(1,F)+T_new.nodes(1,G)+T_new.nodes(1,C))/3,(T_new.nodes(2,F)+T_new.nodes(2,G)+T_new.nodes(2,C))/3,int2str(8))
            
        elseif BC_refined(1)==0 && BC_refined(2)==0 && refine_flag==0
            
            plot([T_new.nodes(1,A),T_new.nodes(1,B),T_new.nodes(1,C),T_new.nodes(1,A)],[T_new.nodes(2,A),T_new.nodes(2,B),T_new.nodes(2,C),T_new.nodes(2,A)],'b')
            hold on
            plot([T_new.nodes(1,D),T_new.nodes(1,G),T_new.nodes(1,F),T_new.nodes(1,D)],[T_new.nodes(2,D),T_new.nodes(2,G),T_new.nodes(2,F),T_new.nodes(2,D)],'b')
            hold on
            plot([T_new.nodes(1,G),T_new.nodes(1,B),T_new.nodes(1,C),T_new.nodes(1,G)],[T_new.nodes(2,G),T_new.nodes(2,B),T_new.nodes(2,C),T_new.nodes(2,G)],'b')
            hold all
            
            text((T_new.nodes(1,A)+T_new.nodes(1,D)+T_new.nodes(1,F))/3,(T_new.nodes(2,A)+T_new.nodes(2,D)+T_new.nodes(2,F))/3,int2str(7))
            text((T_new.nodes(1,D)+T_new.nodes(1,G)+T_new.nodes(1,F))/3,(T_new.nodes(2,D)+T_new.nodes(2,G)+T_new.nodes(2,F))/3,int2str(8))
            text((T_new.nodes(1,D)+T_new.nodes(1,B)+T_new.nodes(1,G))/3,(T_new.nodes(2,D)+T_new.nodes(2,B)+T_new.nodes(2,G))/3,int2str(8))
            text((T_new.nodes(1,G)+T_new.nodes(1,B)+T_new.nodes(1,C))/3,(T_new.nodes(2,G)+T_new.nodes(2,B)+T_new.nodes(2,C))/3,int2str(8))
            text((T_new.nodes(1,F)+T_new.nodes(1,G)+T_new.nodes(1,C))/3,(T_new.nodes(2,F)+T_new.nodes(2,G)+T_new.nodes(2,C))/3,int2str(8))
            
        end
            T_new.info1=[A];
            T_new.info2=[];
                
    end
            
     %% type 8
     if T_old.types(i)==8 && rem(N,2)==0
        % A,B,C denote three indices of three nodes in this triangle i.
        A=T_old.n(1,i);
        B=T_old.n(2,i);
        C=T_old.n(3,i);
        
        [Lia,Locb] = ismember([A,B],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([B,A],T_old.En','rows');
            result_1=Locb; %result_1 denotes the location of AB edge in T_old.En
        else
            result_1=Locb;
        end
        
        AB_refined=T_old.refined(:,result_1);
        if AB_refined(1)==0 && AB_refined(3)==0
            num_nodes=num_nodes+1;
            D=num_nodes;
            T_new.nodes(:,D)=[(T_old.nodes(1,A)+T_old.nodes(1,B))/2;(T_old.nodes(2,A)+T_old.nodes(2,B))/2];%coordinates for new nodes
            
        else
            D=AB_refined(1);
        end
            num_edges=num_edges+1;
            AD_index=num_edges;
            T_new.En(:,AD_index)=[A;D];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,AD_index)=[0;0;0;0;0;0;0];
        
            num_edges=num_edges+1;
            DB_index=num_edges;
            T_new.En(:,DB_index)=[D;B];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,DB_index)=[0;0;0;0;0;0;0];
        
        [Lia,Locb] = ismember([B,C],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([C,B],T_old.En','rows');
            result_2=Locb; %result_2 denotes the location of BC edge in T_old.En
        else
            result_2=Locb;
        end
        
        BC_refined=T_old.refined(:,result_2);
        if BC_refined(1)==0 && BC_refined(3)==0
            num_nodes=num_nodes+1;
            E=num_nodes;
            T_new.nodes(:,E)=[(T_old.nodes(1,B)+T_old.nodes(1,C))/2;(T_old.nodes(2,B)+T_old.nodes(2,C))/2];%coordinates for new nodes
            
        else
            E=BC_refined(1);
        end
        
            num_edges=num_edges+1;
            BE_index=num_edges;
            T_new.En(:,BE_index)=[B;E];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,BE_index)=[0;0;0;0;0;0;0];
        
            num_edges=num_edges+1;
            EC_index=num_edges;
            T_new.En(:,EC_index)=[E;C];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,EC_index)=[0;0;0;0;0;0;0];
           
        
        [Lia,Locb] = ismember([C,A],T_old.En','rows');
        if Locb==0
            [Lia,Locb] = ismember([A,C],T_old.En','rows');
            result_3=Locb; %result_3 denotes the location of AC edge in T_old.En
        else
            result_3=Locb;
        end
        
        CA_refined=T_old.refined(:,result_3);
        if CA_refined(1)==0 && CA_refined(3)==0
            num_nodes=num_nodes+1;
            F=num_nodes;
            T_new.nodes(:,F)=[(T_old.nodes(1,C)+T_old.nodes(1,A))/2;(T_old.nodes(2,C)+T_old.nodes(2,A))/2];%coordinates for new nodes
              
        else
            F=CA_refined(1);
        end
        
            num_edges=num_edges+1;
            CF_index=num_edges;
            T_new.En(:,CF_index)=[C;F];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,CF_index)=[0;0;0;0;0;0;0];
        
            num_edges=num_edges+1;
            FA_index=num_edges;
            T_new.En(:,FA_index)=[F;A]; 
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,FA_index)=[0;0;0;0;0;0;0];
            
        % Now we need to add 4 new triangles, and update types of these triangles
        num_tri=num_tri+1;
        ADF_index=num_tri;
        T_new.n(:,ADF_index)=[A;D;F];
        T_new.types(:,ADF_index)=8;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        DBE_index=num_tri;
        T_new.n(:,DBE_index)=[D;B;E];
        T_new.types(:,DBE_index)=8;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        DEF_index=num_tri;
        T_new.n(:,DEF_index)=[D;E;F];
        T_new.types(:,DEF_index)=8;
        T_new.t(:,num_tri)=num_tri;
        
        num_tri=num_tri+1;
        FEC_index=num_tri;
        T_new.n(:,FEC_index)=[F;E;C];
        T_new.types(:,FEC_index)=8;
        T_new.t(:,num_tri)=num_tri;
        
        %Now we need to add new edges
                
        num_edges=num_edges+1;
        DE_index=num_edges;
        T_new.En(:,DE_index)=[D;E];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,DE_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        EF_index=num_edges;
        T_new.En(:,EF_index)=[E;F];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,EF_index)=[0;0;0;0;0;0;0];
        
        num_edges=num_edges+1;
        FD_index=num_edges;
        T_new.En(:,FD_index)=[F;D];
        T_new.e(:,num_edges)=num_edges;
        T_new.refined(:,FD_index)=[0;0;0;0;0;0;0];
        
        
        %update T_new.num_nodes, T_new.num_edges and T_new.num_tri
        T_new.num_nodes=num_nodes;
        T_new.num_edges=num_edges;
        T_new.num_tri=num_tri;
       
        plot([T_new.nodes(1,A),T_new.nodes(1,B),T_new.nodes(1,C),T_new.nodes(1,A)],[T_new.nodes(2,A),T_new.nodes(2,B),T_new.nodes(2,C),T_new.nodes(2,A)],'b')
        hold on
        plot([T_new.nodes(1,D),T_new.nodes(1,E),T_new.nodes(1,F),T_new.nodes(1,D)],[T_new.nodes(2,D),T_new.nodes(2,E),T_new.nodes(2,F),T_new.nodes(2,D)],'b')
        hold all
        
        text((T_new.nodes(1,A)+T_new.nodes(1,D)+T_new.nodes(1,F))/3,(T_new.nodes(2,A)+T_new.nodes(2,D)+T_new.nodes(2,F))/3,int2str(8))
        text((T_new.nodes(1,D)+T_new.nodes(1,E)+T_new.nodes(1,F))/3,(T_new.nodes(2,D)+T_new.nodes(2,E)+T_new.nodes(2,F))/3,int2str(8))
        text((T_new.nodes(1,D)+T_new.nodes(1,B)+T_new.nodes(1,E))/3,(T_new.nodes(2,D)+T_new.nodes(2,B)+T_new.nodes(2,E))/3,int2str(8))
        text((T_new.nodes(1,F)+T_new.nodes(1,E)+T_new.nodes(1,C))/3,(T_new.nodes(2,F)+T_new.nodes(2,E)+T_new.nodes(2,C))/3,int2str(8))
        
        T_new.info1=[];
        T_new.info2=[];
        
     elseif T_old.types(i)==8 && rem(N,2)~=0
         A=T_old.n(1,i);
         B=T_old.n(2,i);
         C=T_old.n(3,i);
         
         if isempty(T_new.En)==1
            T_new.En=[0;0];
         end
        
         [Lia,Locb] = ismember([A,B],T_old.En','rows');
         [Lia1,Locb1] = ismember([A,B],T_new.En','rows');
        if Locb~=0 && Locb1==0
            num_edges=num_edges+1;
            AB_index=num_edges;
            T_new.En(:,AB_index)=[A;B];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,AB_index)=[0;0;0;0;0;0;0];
        else
            [Lia,Locb] = ismember([B,A],T_old.En','rows');
            [Lia1,Locb1] = ismember([B,A],T_new.En','rows');
            if Locb~=0 && Locb1==0
                num_edges=num_edges+1;
                AB_index=num_edges;
                T_new.En(:,AB_index)=[A;B];
                T_new.e(:,num_edges)=num_edges;
                T_new.refined(:,AB_index)=[0;0;0;0;0;0;0];
            end
        end
            
            
        [Lia,Locb] = ismember([B,C],T_old.En','rows');
        [Lia1,Locb1] = ismember([B,C],T_new.En','rows');
        if Locb~=0 && Locb1==0
            num_edges=num_edges+1;
            BC_index=num_edges;
            T_new.En(:,BC_index)=[B;C];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,BC_index)=[0;0;0;0;0;0;0];
        else
            [Lia,Locb] = ismember([C,B],T_old.En','rows');
            [Lia1,Locb1] = ismember([C,B],T_new.En','rows');
            if Locb~=0 7& Locb1==0
                num_edges=num_edges+1;
                BC_index=num_edges;
                T_new.En(:,BC_index)=[B;C];
                T_new.e(:,num_edges)=num_edges;
                T_new.refined(:,BC_index)=[0;0;0;0;0;0;0];
            end
        end
        
        [Lia,Locb] = ismember([A,C],T_old.En','rows');
        [Lia1,Locb1] = ismember([A,C],T_new.En','rows');
        if Locb~=0 && Locb1==0
            num_edges=num_edges+1;
            CA_index=num_edges;
            T_new.En(:,CA_index)=[C;A];
            T_new.e(:,num_edges)=num_edges;
            T_new.refined(:,CA_index)=[0;0;0;0;0;0;0];
        else
            [Lia,Locb] = ismember([C,A],T_old.En','rows');
            [Lia1,Locb1] = ismember([C,A],T_new.En','rows');
            if Locb~=0 && Locb1==0
                num_edges=num_edges+1;
                CA_index=num_edges;
                T_new.En(:,CA_index)=[C;A];
                T_new.e(:,num_edges)=num_edges;
                T_new.refined(:,CA_index)=[0;0;0;0;0;0;0];
            end
        end
         
          %add a triangle
         num_tri=num_tri+1;
         ABC_index=num_tri;
         T_new.n(:,ABC_index)=[A;B;C];
         T_new.types(:,ABC_index)=3;
         T_new.t(:,num_tri)=num_tri;
         
         T_new.num_edges=num_edges;
         T_new.num_tri=num_tri;
         num_nodes=num_nodes;
         T_new.info1=[];
         T_new.info2=[];
         T_new.e(:,num_edges)=num_edges;
         T_new.t(:,num_tri)=num_tri;
         
         plot([T_new.nodes(1,A),T_new.nodes(1,B),T_new.nodes(1,C),T_new.nodes(1,A)],[T_new.nodes(2,A),T_new.nodes(2,B),T_new.nodes(2,C),T_new.nodes(2,A)],'b')
         hold all
         text((T_new.nodes(1,A)+T_new.nodes(1,B)+T_new.nodes(1,C))/3,(T_new.nodes(2,A)+T_new.nodes(2,B)+T_new.nodes(2,C))/3,int2str(8))
                
     end
end

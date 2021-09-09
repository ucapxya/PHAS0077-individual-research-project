T_old.nodes=[1,4;0,0;2,0]';
T_old.n=[1,2,3]';
T_old.e=[1;2;3];
T_old.t=[1];
T_old.En=[1,2;2,3;3,1]';
T_old.types=[2];
T_old.info=[];

T_old.num_nodes=3;
T_old.num_tri=1;
T_old.num_edges=3;
T_old.refined=zeros(7,T_old.num_edges);

[T_new]=refine(T_old,0,2);
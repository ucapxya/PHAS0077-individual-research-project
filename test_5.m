%co-ordinates of each node
T_old.nodes=[0,3*sqrt(3);-1,2*sqrt(3);1,2*sqrt(3);-2,sqrt(3);0,sqrt(3);2,sqrt(3);-3,0;-1,0;1,0;3,0;-2,-sqrt(3);0,-sqrt(3);2,-sqrt(3);-1,-2*sqrt(3);1,-2*sqrt(3);0,-3*sqrt(3)]';
%each column denotes the indices for nodes in each element
T_old.n=[1,2,3;5,2,4;5,3,2;5,6,3;4,7,8;4,8,5;5,8,9;6,5,9;6,9,10;11,8,7;8,11,12;12,9,8;9,12,13;13,10,9;14,12,11;12,14,15;15,13,12;16,15,14]';
% edge indices
T_old.e=[1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25;26;27;28;29;30;31;32;33];
% triangle indices
T_old.t=[1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18];
% each column denotes the node indices for edge end points
T_old.En=[1,2;2,3;3,1;2,4;4,5;5,2;5,3;5,6;6,3;4,7;7,8;8,4;5,8;8,9;9,5;6,9;9,10;10,6;7,11;11,8;11,12;12,8;12,9;12,13;13,9;13,10;11,14;14,12;14,15;15,12;15,13;14,16;16,15]';
%types for each element
T_old.types=[3;2;2;2;1;1;4;1;1;5;7;6;7;5;8;8;8;8];

T_old.info1=[];
T_old.info2=[];
T_old.num_nodes=16;
T_old.num_tri=18;
T_old.num_edges=33;
T_old.refined=zeros(7,T_old.num_edges);

[T_new]=refine(T_old,1,2);

# PHAS0077-individual-research-project
This repository contains some files about the project: Mesh Generation for Domains Fractal Boundary.
The Matlab code of the main project is stored in refine.m. The other 5 files are all for testing.

The programming language that I use is Matlab, and the Matlab file name is . The function input contains three elements:
λ	: a structure of data set;
a)	: a matrix, each column denotes a co-ordinate for each node
b)	: a matrix, each column contains three node indices for each    element in an anticlockwise order
c)	: a vector containing edge indices for each edge
d)	: a vector containing indices for each triangle
e)	: a matrix, each column denotes the end-point node indices for each edge
f)	: a vector containing types for each element
g)	: a vector containing the intersecting vertices
h)	: a matrix, each column denotes the end points of an intersecting edge
i)	: number of nodes
j)	: number of edges
k)	: number of triangles
λ	: a real number belongs to the set ;
a)	If , do not use dash line on type  and type 
b)	If , use dash line on type  and type 
λ	: If  is even, then refine type  and type ; if  is odd, do not refine type  and type .

The function output contains one element:
λ	: a structure of data set;
a)	: a matrix, each column denotes a co-ordinate for each node
b)	: a matrix, each column contains three node indices for each    element in an anticlockwise order
c)	: a vector containing edge indices for each edge
d)	: a vector containing indices for each triangle
e)	: a matrix, each column denotes the end-point node indices for each edge
f)	: a vector containing types for each element
g)	: a vector containing the intersecting vertices
h)	: a matrix, each column denotes the end points of an intersecting edge
i)	: number of nodes
j)	: number of edges
k)	: number of triangles
In the main routine, a for-loop is used to loop though all elements given in the input , then the function will check the type for each element and then run it into its corresponding subroutine, finally a refined mesh is attained.

In each subroutine, similar procedures are applied. First, according to the respective features of different types, three letters such as ,  and  are used to anticlockwise and temporarily denote the nodes of a triangle, which is easy and efficient for the expression of edges and triangles in later work
Next, each edge in the element should be checked that whether there already exist/ exists nodes/ a node on it. If not, new node/ nodes should be added on that edge based on the feature of that type. If there already exist/ exists nodes/ a node on that edge, new nodes should not be added any more, and the existing node/ nodes should be regarded as new node/nodes for further work. 

After all new nodes are added, new edges need to be added and replace the old edges from , because when a new node is added on an edge, this old edge will be divided into two new edges then it should be updated. Similarly, when new edges are added, old triangles are divided into smaller new triangles then should be updated too.
All updated information should be stored in the  structure. Finally, a refined mesh is created and shown on the graph. 

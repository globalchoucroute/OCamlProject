# OCamlProject
An OCaml project - the goal is to implement the ford-fulkerson algorithm

This repository contains the minimal project (the Ford-Fulkerson algorithm) and the medium project. 
The medium project reads a file containing school names, their capacities, and students with their school choices. The algorithm will then connect the students with one of the school they wished for. 

# **************RUN THE MINIMAL PROJECT************** #
To run the minimal project, you first have to decomment the section dedicated to the minimal project in the 'ftest.ml' file, and comment the section dedicated to the medium project.
Then, run the following commands on a terminal at the root of the project file :

make

./ftest.native graphs/infile source sink graphs/outfile

Where infile is the source graph for the algorithm, and outfile will be the graph exported in dot format.

# **************RUN THE MEDIUM PROJECT************** #
To run the medium project, it's the exact opposite: decomment the medium project section, and comment the minimal project section in the 'ftest.ml' file. 
Then, run the following commands on a terminal at the root of the project file :

make

./ftest.native data/data 0 1 graphs/outfile

Where data is the data file containing the school and students info, and outfile will be the graph exported in dot format.
Beware that, for the medium project, the source and the sink MUST be set at 0 and 1.




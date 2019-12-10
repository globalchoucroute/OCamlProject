open Graph

(*Maps all arcs of gr by function f.*)
val gmap: 'a graph -> ('a -> 'b) -> 'b graph
(*Returns a new graph having the same nodes than gr, but no arc.*)
val clone_nodes: 'a graph -> 'b graph
(*Adds n to the value of the arc between id1 and id2. If the arc does not exist, it is created.*)
val add_arc: int graph -> id -> id -> int -> int graph

val to_int: int list -> int option list -> int list
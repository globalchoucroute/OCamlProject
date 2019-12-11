open Graph
open Tools

type path = id list

(*Remplace une list option par une liste*)
val desome: 'a list option -> 'a list

(*Affichage simple des différents noeuds du chemin*)
val display_path: int list option -> unit

(*Récupération de la valeur maximale d'incrémentation*)
val get_lowest_weight: int Graph.graph -> Graph.id list -> int

(*Incrémentation de toutes les valeurs du chemin obtenu*)
val incr: int Graph.graph -> Graph.id list -> int -> int Graph.graph

(*Deuxieme version peut-être mieux écrite de incr*)
val incr2: int Graph.graph -> Graph.id list -> int -> int Graph.graph

val find_path2: int Graph.graph -> id -> id -> path option
(*Fonction auxiliaire d'inversion d'une option list*)
val reverse: 'a list option -> 'a list option

(*Algorithme principal*)
val fordFulkerson: int Graph.graph -> Graph.id -> Graph.id -> int Graph.graph

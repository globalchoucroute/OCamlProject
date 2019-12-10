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

(*Fonction auxiliaire d'inversion d'une option list*)
val reverse: 'a list option -> 'a list option

(*Première version du find_path : renvoie le chemin inverse*)
val find_path: int graph -> id list -> id -> id -> path option

(*Seconde version du find_path*)
val find_path2: int Graph.graph -> 'a -> Graph.id -> Graph.id -> Graph.id list option

(*Algorithme principal*)
val fordFulkerson: int Graph.graph -> Graph.id -> Graph.id -> int Graph.graph
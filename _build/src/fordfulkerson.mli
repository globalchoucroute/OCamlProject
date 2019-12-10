open Graph
open Tools

type path = id list
type flowGraph = (int*int) Graph.graph
type residualGraph = int Graph.graph

(*Remplace une list option par une liste*)
val desome: 'a list option -> 'a list
val createDotFile: flowGraph -> string ->  unit
(*Initialisation du graphe de flux pour l'affichage*)
val flowGraphInit: residualGraph -> flowGraph

(*Passage d'un graphe de flux à un graphe résiduel*)
val getResidualGraph: flowGraph -> residualGraph

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
val find_path2: residualGraph -> 'a -> Graph.id -> Graph.id -> Graph.id list option

(*Algorithme principal*)
val fordFulkerson: int Graph.graph -> Graph.id -> Graph.id -> int Graph.graph
val run_algorithm: residualGraph -> int -> int -> flowGraph



(*Au secours*)
val update_path: flowGraph -> path -> int -> flowGraph
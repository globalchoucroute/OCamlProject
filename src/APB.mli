open Printf
open Graph

(*Renvoie une liste associant les noms des noeuds à leur id*)
val namesToId: string -> string list

(* Récupère tous les noeuds des données au format biparti
Sera utilisé dans la fonction qui créé le fichier du graphe*)
val getNodes: in_channel -> out_channel -> unit

(*Renvoie l'index d'un élément dans une liste donnée*)
val indexOf: 'a -> 'a list -> int

(*Sépare une chaîne de caractère entre chaque espace*)
val splitChoices: string -> string list

(*Récupère les infos sur l'école de la ligne donnée,
les inscrit dans le fichier et retourne le nom de l'école*)
val getSchoolInfo: string -> out_channel -> int -> string

(*Récupère les infos sur l'étudiant de la ligne donnée, les inscrit dans le fichier.*)
val getStudentInfo: string -> out_channel -> string list -> int -> unit

(*Lit un fichier de données au format biparti et créé un fichier graphe associé*)
val readFile: string -> string -> unit

(*Affiche les associations entre les noms et les id des noeuds *)
val displayConnections: string list -> unit
open Graph
open Tools
open Gfile

type path = id list

(*Remplace les valeurs d'arcs du graphe pour un affichage propre*)
let makeFlowGraph startingGraph fordgraph =
  let aux finalGraph id1 id2 lbl = match (find_arc fordgraph id2 id1) with
    | None -> new_arc finalGraph id1 id2 ("0/"^(string_of_int (lbl)))
    | Some label -> new_arc finalGraph id1 id2 ((string_of_int label)^"/"^(string_of_int (lbl)))
    in e_fold startingGraph aux (clone_nodes startingGraph)
  

(*Remplace une list option par une liste*)
let desome = function
  | None -> [] 
  | Some l -> l;;

(*Affichage simple des différents noeuds du chemin*)
let display_path path = Printf.printf "Path :";
  List.iter (fun i -> Printf.printf " %d%!" i) (desome path); Printf.printf"\n";;

(*Récupération de la valeur maximale d'incrémentation*)
let get_lowest_weight gr path =
  let rec loop g min = function 
    | [_]|[] -> min 
    | x::y::tail -> match find_arc gr x y with
      | Some label -> if label < min then loop g label (y::tail) else loop g min (y::tail)
      | None -> failwith "Path is not valid"
  in loop gr max_int path;;

(*Incrémentation de toutes les valeurs du chemin obtenu*)
let rec incr gr path value = match path with
  | [_]|[] -> gr
  | x::y::tail -> match find_arc gr x y with 
    | Some label -> incr (add_arc (add_arc gr y x value) x y (-value)) (y::tail) value
    | None -> match find_arc gr y x with
      | None -> failwith "Invalid path"
      | Some label -> incr (add_arc (add_arc gr y x value) x y (-value)) (y::tail) value;;

(*Deuxieme version peut-être mieux écrite de incr*)
let rec incr2 gr path value = match path with
  | [_]|[] -> gr
  | x::y::tail -> incr (add_arc (add_arc gr y x value) x y (-value)) (y::tail) value;;

(*Fonction auxiliaire d'inversion d'une option list*)
let reverse = function
  | None -> None
  | Some l -> Some (List.rev l);;

(*Première version du find_path : renvoie le chemin inverse*)
let rec find_path gr forbidden id1 id2 = if id1 = id2 then Some [id1] else 
    reverse (let rec loop outerarcs path forbidden currentNode = match outerarcs with
        | [] -> None
        | (x,label)::tail -> if x = id2 && label <> 0 then Some (x::path) else
          if List.mem x forbidden || label = 0 then loop tail path (currentNode::forbidden) currentNode else 
            match find_path gr forbidden x id2 with
            | None -> loop tail path (currentNode::forbidden) currentNode
            | Some y -> Some (List.concat [y;path]) 
       in loop (out_arcs gr id1) [id1] forbidden id1);;

(*Seconde version du find_path*)
let find_path2 gr id1 id2 = 
    let rec loop gr id2 currentNode outerarcs path forbidden = match outerarcs with
      | [] -> None
      | (id, label)::tail -> if id = id2 && label<>0 then Some (id::path) else
        if List.mem id forbidden || label = 0 then loop gr id2 currentNode tail path (currentNode::forbidden) else
        let mainpath = loop gr id2 id (out_arcs gr id) (id::path) (currentNode::forbidden) in
        if mainpath = None then loop gr id2 currentNode tail path forbidden else mainpath
        in reverse(loop gr id2 id1 (out_arcs gr id1) [id1] []);;


(*Algorithme principal, sans prise en compte du graphe de flux*)
let rec fordFulkerson gr id1 id2 = match find_path2 gr id1 id2 with
  | None -> gr
  | Some l -> display_path (Some l);
  Printf.printf "Valeur incrémentée : %d %!" (get_lowest_weight gr l);
  fordFulkerson (incr2 gr l (get_lowest_weight gr l)) id1 id2;  

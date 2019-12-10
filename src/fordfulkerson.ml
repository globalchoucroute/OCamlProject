open Graph
open Tools
open Gfile
type path = id list

(*Remplace une list option par une liste*)
let desome = function
  | None -> [] 
  | Some l -> l;;

(*Affichage simple des différents noeuds du chemin*)
let display_path path = Printf.printf "Path :";
  List.iter (fun i -> Printf.printf " %d%!" i) (desome path); Printf.printf"\n";;

(*Récupération de la valeur maximale d'incrémentation*)
let get_lowest_weight gr path =
  let rec loop min = function 
    | [_]|[] -> min 
    | x::y::tail -> match find_arc gr x y with
      | None -> failwith "Path is not valid"
      | Some label -> if label < min then loop label (y::tail) else loop min (y::tail)
  in loop max_int path;;

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
        | (x,label)::tail -> if x = id2 then Some (x::path) else
          if List.mem x forbidden || label = 0 then loop tail path (currentNode::forbidden) currentNode else 
            match find_path gr forbidden x id2 with
            | None -> loop tail path (currentNode::forbidden) currentNode
            | Some y -> Some (List.concat [y;path]) 
       in loop (out_arcs gr id1) [id1] forbidden id1);;

(*Seconde version du find_path*)
let rec find_path2 gr forbidden id1 id2 = if id1 = id2 then Some [id1] else 
    let rec loop outerarcs forbidden acu currentNode graphend = match outerarcs with
      | [] -> None
      | (id,rest)::tail -> if id = graphend then Some (id :: acu) else 
        if List.mem id forbidden || rest = 0 then loop tail (currentNode::forbidden) acu currentNode graphend else
          let path = loop (out_arcs gr id) (currentNode::forbidden) (id::acu) currentNode graphend 
          in if path = None then loop tail forbidden acu currentNode graphend else 
            path 
    in reverse(loop (out_arcs gr id1) [] [id1] id1 id2);;

(*Algorithme principal*)
let rec fordFulkerson gr id1 id2 = match find_path2 gr [] id1 id2 with
  | None -> gr
  | Some l -> fordFulkerson (incr gr l (get_lowest_weight gr l)) id1 id2;; 
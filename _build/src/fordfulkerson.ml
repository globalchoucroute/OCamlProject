open Graph
open Tools
open Gfile

type path = id list
type flowGraph = (int*int) Graph.graph
type residualGraph = int Graph.graph

(*Remplace une list option par une liste*)
let desome = function
  | None -> [] 
  | Some l -> l;;

let createDotFile g path = 
  let gstring = gmap g (fun (x,y) -> string_of_int x ^ "/" ^string_of_int y) in
  export path gstring

(*Initialisation du graphe de flux pour l'affichage*)
let flowGraphInit gr = gmap gr (fun capacity -> (0,capacity));;

(*Passage d'un graphe de flux à un graphe résiduel*)
let getResidualGraph g1 =
  let g_res = clone_nodes g1 in
  let g_res = e_fold g1 (fun g id1 id2 (f,c) -> new_arc g id1 id2 (c-f)) g_res in
  e_fold g1 (fun g id1 id2 (f,c) -> new_arc g id2 id1 f) g_res;;

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

(*Incrémentation qui prend en compte le format graphe de flux*)
let update_arc g id1 id2 value =
  match find_arc g id1 id2 with
  | None -> (match find_arc g id2 id1 with
      | None -> raise(Failure "The path is invalid !")
      | Some (x,y) -> new_arc g id2 id1 (x-value,y)) (* arc moins *)
  | Some (x,y) -> new_arc g id1 id2 (x+value,y) (* arc plus *);;

let rec update_path g path value = match path with 
  | [_]|[] -> g
  | id1 :: id2 :: rest -> update_path (update_arc g id1 id2 value) (id2 :: rest) value;;


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

(*Algorithme prenant en compte les graphes de flux*)
(*let run_algorithm gsource source sink=
  let gflow = flowGraphInit gsource in
  let rec loop gf source sink gr = match find_path2 gr source sink with
    | None -> gf
    | Some path -> let gf2 = update_path gf path (get_lowest_weight gr path) in
      loop gf2 source sink (getResidualGraph gf2)
  in loop gflow [] source sink (getResidualGraph gflow);;*)
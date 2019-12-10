open Graph
open Gfile

let clone_nodes gr = n_fold gr new_node empty_graph;;

let gmap gr f = e_fold gr (fun g id1 id2 l-> new_arc g id1 id2 (f l)) (clone_nodes gr);;

let rec to_int acu = function
  | [] -> acu
  | (Some x)::tail -> to_int (x::acu) tail
  | None::tail -> to_int (0::acu) tail

let add_arc gr id1 id2 n = let aux = function
    | Some x -> x
    | None -> 0
  in new_arc gr id1 id2 ((aux (find_arc gr id1 id2))+n)


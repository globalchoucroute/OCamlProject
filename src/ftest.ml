open Gfile
open Tools
open Fordfulkerson
let () =

  (* Check the number of command-line arguments *)
  if Array.length Sys.argv <> 5 then
    begin
      Printf.printf "\nUsage: %s infile source sink outfile\n\n%!" Sys.argv.(0) ;
      exit 0
    end ;


  (* Arguments are : infile(1) source-id(2) sink-id(3) outfile(4) *)

  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(4)

  (* These command-line arguments are not used for the moment. *)
  and _source = int_of_string Sys.argv.(2)
  and _sink = int_of_string Sys.argv.(3)
  in

  (* Open file *)
  let graph = from_file infile in
  let intgraph = gmap graph int_of_string in

  let pathtest = find_path2 (gmap graph int_of_string) 0 5 in 
  let desomedpath = desome pathtest in
  (* Rewrite the graph that has been read. *)
  let () = (*write_file outfile (gmap (add_arc (gmap graph int_of_string) 0 1 2) string_of_int)*) 
    (*write_file outfile (gmap (incr2 intgraph desomedpath (get_lowest_weight intgraph desomedpath)) string_of_int)*)
    export outfile (gmap (fordFulkerson intgraph 0 5) string_of_int)
    (*export outfile (gmap (incr2 intgraph desomedpath (get_lowest_weight intgraph desomedpath)) string_of_int)*)
    (*export outfile graph*) 
    in

  ()


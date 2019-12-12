open Gfile
open Tools
open Fordfulkerson
open APB
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

  (* Get the source and the sink from the command line.
  If one uses the medium project, then these must be set at 0 and 1. *)
  and source = int_of_string Sys.argv.(2)
  and sink = int_of_string Sys.argv.(3)
  in

(********************************************)
(* Section dedicated to the minimal project *)
  (*
  (* Open file *)
  let graph = from_file infile in

  (*Convert the graph to an int Graph.graph*)
  let intgraph = gmap graph int_of_string in

  (*Apply the ford-fulkerson algorithm to the graph*)
  let exportedGraph = makeFlowGraph intgraph (fordFulkerson intgraph source sink) in
  
  (* Rewrite the graph that has been read. *)
  let () = export outfile exportedGraph;
    in

  ()*)
(*******************************************)
(* Section dedicated to the medium project *)
  
  
  (* Create a temporary transfer file *)
  let temporaryFile = "datasheet.tmp" in

  let listOfElements = namesToId infile in

  (* Read the data from the data file, stores it in the temporary file *)
  readFile infile temporaryFile;

  (* Open file *)
  let graph = from_file temporaryFile in

  (* Convert the graph to an int Graph.graph *)
  let intgraph = gmap graph int_of_string in

  (* Apply the ford-fulkerson algorithm to the graph *)
  let exportedGraph = makeFlowGraph intgraph (fordFulkerson intgraph source sink) in
  
  (* Rewrite the graph that has been read *)
  let () = export outfile (exportedGraph);
  displayConnections listOfElements; 
  in

  
()


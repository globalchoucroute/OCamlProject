open Printf
open Graph
(*Renvoie une liste associant les noms des noeuds à leur id :
Si on prend la liste suivante :
["Source";"Puit";"Theodule";"Esclarmonde";"Clapton";"PolytechMtp";"LicenceMaths"]
On aura : l'id du noeud associé à Source sera 0;
          l'id du noeud associé à Puit sera 1;
          l'id du noeud associé à Theodule sera 2;
          et ainsi de suite...*)
let namesToId file = 
  let infile = open_in file in
  let rec loop l = 
    try
      let line = input_line infile in
      let line = String.trim line in
      if line = "" then loop l else match line.[0] with
        | 'e'|'s' -> Scanf.sscanf line "%c %s %s" (fun _ name _ -> loop (name::l))
        | _ -> loop l
      with End_of_file -> l in
    List.rev(loop ["Puit";"Source"])

(* Récupère tous les noeuds des données au format biparti
Sera utilisé dans la fonction qui créé le fichier du graphe*)
let getNodes infile outfile = 
  let rec loop n = 
    try 
    let line = input_line infile in
    let line = String.trim line in
    if line = "" then loop n else match line.[0] with
      | 'e'|'s' -> fprintf outfile "%s" ("n 0 " ^ string_of_int n ^ "0\n"); loop (n+1)
      | _ -> loop n
    with End_of_file -> ()
  in loop 2 (*Les deux premiers éléments sont la source et le puit *)

(*Renvoie l'index d'un élément dans une liste donnée*)
let indexOf element alist = 
  let rec loop index = function
    | [] -> raise(Failure "Element not found")
    | head::tail -> if (head=element) then index else loop (index + 1) tail in
  loop 2 (List.rev alist);; (*On commence à deux car les éléments 0 et 1 sont la source et le puit*)

(*Sépare une chaîne de caractère entre chaque espace*)
let splitChoices choices = Str.split (Str.regexp " ") choices;;

(*Récupère les infos sur l'école de la ligne donnée,
les inscrit dans le fichier et retourne le nom de l'école*)
let getSchoolInfo line outfile id =
  Scanf.sscanf line "e %s %d" (fun schoolName schoolCapacity ->
                              fprintf outfile "e %d 1 %d\n" id schoolCapacity; schoolName);;

(*Récupère les infos sur l'étudiant de la ligne donnée, les inscrit dans le fichier.*)
let getStudentInfo line outfile alist id =
  let rec linkNodes = function
    | [] -> ()
    | head::tail -> fprintf outfile "e %d %d 1\n" id (indexOf head alist); linkNodes tail; in
      Scanf.sscanf line "s %s %[^\n]" (fun name choices -> fprintf outfile "\n";
                                        fprintf outfile "e 0 %d 1\n" id;
                                        linkNodes (splitChoices choices));; 

(*Lit un fichier de données au format biparti et créé un fichier graphe associé*)
let readFile path tmp_path =
  let infile = open_in path in
  let outfile = open_out tmp_path in

  fprintf outfile "n 0 0\n"; 
  fprintf outfile "n 0 10\n";

  fprintf outfile "\n";
  getNodes infile outfile;
  fprintf outfile "\n";

  let infile = open_in path in (*On repart du début*)

  let rec read_lines n schools =
    try
      let line = input_line infile in
      let line = String.trim line in

      if line = "" then read_lines n schools
      else match line.[0] with
        | 'e' -> read_lines (n+1) ((getSchoolInfo line outfile n) :: schools)
        | 's' -> getStudentInfo line outfile schools n; read_lines (n+1) schools
        | _ -> read_lines n schools;

    with End_of_file -> ()
  in read_lines 2 []; (*Encore une fois, on ne part pas de 0, car les indices 0 et 1 correspondent à la source et au puit*)

  close_out outfile;;
       
  (*Affiche les associations entre les noms et les id des noeuds *)
  let displayConnections listOfElements =
    List.iter (fun e -> Printf.printf "%s a pour id %d\n%!" e ((indexOf e (List.rev listOfElements))-2)) listOfElements

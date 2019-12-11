open Printf


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

(*Renvoie l'index d'un élément dans une liste donnée*)
let indexOf element alist = 
  let rec loop index = function
    | [] -> raise(Failure "Element not found")
    | head::tail -> if (head=element) then index else loop (index + 1) tail in
  loop 2 alist;; (*On commence à deux car les éléments 0 et 1 sont la source et le puit*)

(*Sépare une chaîne de caractère entre chaque virgule*)
let splitChoices choices = Str.split (Str.regexp ",") choices;;

(*Récupère les infos sur l'école de la ligne donnée,
les inscrit dans le fichier et retourne le nom de l'école*)
let getSchoolInfo line outfile id =
  Scanf.sscanf line "e %s %d" (fun schoolName schoolCapacity ->
                              fprintf outfile "e %d 1 %d\n" id schoolCapacity; schoolName);;

(*Récupère les infos sur l'étudiant de la ligne donnée, les inscrit dans le fichier.*)
let getStudentInfo line outfile alist id =
  let rec linkNodes = function
    | [] -> ()
    | head::tail -> fprintf outfile "e %d %d 1\n" id (indexOf alist head); linkNodes tail; in
      Scanf.sscanf line "s %s %[^\n]" (fun name choices -> fprintf outfile "\n";
                                        fprintf outfile "e 0 %d 1\n" id;
                                        linkNodes (splitChoices choices));; 

                                  
                    
open Graph
(*open Tools *)

(*
  Returns a list of arcs going from a node, avoiding the ones targeting forbidden nodes

  INPUT:
    The graph
    The list of forbidden nodes
    The node from which you want the arcs

  RETURNS:
    List of outgoing arcs from src
*)
let get_next (gr: int graph) (forbidden: id list) (src: id)=
  let aux acc arc =
    if arc.src = src && arc.lbl > 0 && not (List.mem arc.tgt forbidden) then arc :: acc else acc 
  in
    Graph.e_fold gr aux [];;

(*
  Finds a path going from src to dst

  INPUT:
    The graph
    The list of forbidden nodes
    The source node
    The destination node

  RETURNS:
    A list of ids that construct a correct path
*)
let rec find_path (gr: int graph) (forbidden: id list) (src: id) (dst: id) =
  if src = dst then Some [src]
  else if List.mem src forbidden then None
  else
    let neighbors = get_next gr forbidden src in
      let rec aux arcs =
        match arcs with
        | [] -> None
        | arc :: rest -> match find_path gr (src :: forbidden) arc.tgt dst with
                          | Some path -> Some (src :: path)
                          | None -> aux rest
      in
        aux neighbors
;;


(*
  Takes the label on all arcs in a path and returns the minimum

  INPUT:
    The graph
    The path (list of ids)

  RETURNS:
    The mimimum label value
*)
let path_min_capacity gr path = 
  let rec aux min path = 
    match path with
    | [] -> min
    | _::[] -> min
    | src::dest::rest -> match find_arc gr src dest with
                    | Some {src = _;tgt = _;lbl} -> if lbl < min then aux lbl (dest::rest) else aux min (dest::rest)
                    | None -> raise (Failure "Not a valid arc in pathlist.")
  in
    aux max_int path;;

  (*
  Updates the residual graph along the path by the flow

  INPUT:
    The graph
    The path to update along
    The flow to augment

  RETURNS:
    Graph with updated flows
  *)
let rec update_residual_graph gr path flow =
  match path with
  | [] -> gr
  | _::[] -> gr
  | head::dest::rest -> update_residual_graph 
                          (Tools.add_arc (Tools.add_arc gr dest head (flow)) head dest (-flow)) 
                          (dest::rest) 
                          flow;; 

(*
  Deletes all arcs with label = 0

  INPUTS:
    The graph

  RETURNS:
    The graph (without 0-arcs)

let delete_zero_arcs gr =
  let rec aux acu arcs =
    match arcs with
    | [] -> acu
    | arc::rest -> if arc.lbl<1 then aux acu rest else aux (new_arc acu arc) rest
  in
  aux (clone_nodes gr) (e_fold gr (fun acc arc -> arc :: acc) []);;
*)

(*
  Main loop for the Ford-Fulkerson algorithm

  INPUTS:
    The graph
    The source node
    The destination node

  RETURNS:
    The residual graph after max flow
*)
let ford_fulkerson gr src dst =
  let rec aux residual_graph flow =
    match find_path residual_graph [] src dst with
    | None -> residual_graph
    | Some path ->
        let min_cap = path_min_capacity residual_graph path in
          let updated_graph = update_residual_graph residual_graph path min_cap in
            (*let cleaned_graph = delete_zero_arcs updated_graph in *)
              aux updated_graph (flow + min_cap)
  in
    aux gr 0
;;

(*
  Uses the original and residual graph to create the final flow graph

  INPUT:
    The original graph
    The graph after the Ford-Fulkerson algorithm
  RETURNS:
    A new graph with the correct flows
*)
let reconstruct_flow_graph gr residual =
  Graph.e_fold gr
    (fun acc arc ->
      let res_cap =
        match Graph.find_arc residual arc.src arc.tgt with
        | Some a -> a.lbl
        | None -> 0
      in
        let flow = arc.lbl - res_cap in
          if flow > 0 then
            Tools.add_arc acc arc.src arc.tgt flow
          else
            acc) (Tools.clone_nodes gr)
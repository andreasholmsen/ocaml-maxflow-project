open Graph

type path = id list;;



(*
    A graph with the same nodes but no arcs

    INPUT:
        The graph

    RETURNS:
        The graph without arcs

*)
let clone_nodes (gr: 'a graph) = Graph.n_fold gr Graph.new_node Graph.empty_graph;;


(*
    maps all arcs with the function f

    INPUT:
        The graph
        The function to apply to each arc's label

    RETURNS:
    The resulting graph
*)
let gmap (gr: 'a graph) (map: ('a -> 'b)) =
    Graph.e_fold gr (fun acc {src; tgt; lbl} -> Graph.new_arc acc {src; tgt; lbl = map lbl}) (clone_nodes gr)
;;


(*
Adds n to the label of an arc, or creates it if not found

INPUT:
    The graph to search for arcs and return
    The identifier for the source node
    The identifier for the destination node
    The integer to add to the label

RETURNS:
    The graph with the updated or added arc
*)
let add_arc (gr: int graph) (src: id) (tgt: id) (n: int) = 
    match Graph.find_arc gr src tgt with
    | None -> Graph.new_arc gr {src =src; tgt = tgt; lbl = n}
    | Some {src =_; tgt = _; lbl} -> Graph.new_arc gr {src=src; tgt = tgt; lbl = lbl+n}
;;


(*
Converts string graph to int graph and vice-versa
i.e., between id graph and string graph
*)
let string_to_int_graph (graph: string graph) = gmap graph int_of_string;;
let int_to_string_graph (graph: int graph) = gmap graph string_of_int;;
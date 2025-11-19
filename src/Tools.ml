(* Yes, we have to repeat open Graph. *)
open Graph

(* assert false is of type ∀α.α, so the type-checker is happy. *) (* Merci au prof qui m'a aidé*)
let clone_nodes (gr: 'a graph) = Graph.n_fold gr Graph.new_node Graph.empty_graph;;

(* Iterates over all arcs and adds f to the arcs in the copy containing nodes but no arcs *)
let gmap (gr: 'a graph) f = 
  let gmap2 (gr2: 'a graph) =
    Graph.e_fold gr (fun acc {src = src1; tgt = tgt1; lbl = lbl1} -> Graph.new_arc acc {src = src1; tgt = tgt1; lbl = f lbl1}) gr2
  in
  gmap2 (clone_nodes gr)
;;

(*If arc does not exist, create graph. If does exist, update to value lbl+n*)
let add_arc (gr: int graph) (id1: id) (id2: id) (n: int) = 
    match Graph.find_arc gr id1 id2 with
    | None -> Graph.new_arc gr {src =id1; tgt = id2; lbl = n}
    | Some {src = _; tgt = _; lbl = l} -> Graph.new_arc gr {src=id1; tgt = id2; lbl = l+n}
;;
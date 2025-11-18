(* Yes, we have to repeat open Graph. *)
open Graph

(* assert false is of type ∀α.α, so the type-checker is happy. *) (* TODO: MAKE FUNCTION*)
let clone_nodes (gr: 'a graph) = Graph.n_iter gr;;

let gmap gr f = assert false
(* Replace _gr and _f by gr and f when you start writing the real function. *)
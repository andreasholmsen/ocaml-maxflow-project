open Graph

type path = id list


val clone_nodes: 'a graph -> 'b graph


val gmap: 'a graph -> ('a -> 'b) -> 'b graph


val add_arc: int graph -> id -> id -> int -> int graph


val string_to_int_graph : string graph -> int graph
val int_to_string_graph : int graph -> string graph

## Ford-Fulkerson Algorithm, Ocaml Implementation

The algorithm works by using the main loop `ford_fulkerson` to continually find paths (`find_path`), calculate a minimum flow (`path_min_capacity`) and create a residual graph ("wasted potential"). When the residual graph is complete, the function `reconstruct_flow_graph` outputs the new graph with the actual max flows (original values - the values of the residual graph).

The project focuses on code readability more than efficiency.

## Compilation

To compile the project, run `dune build` and afterwards, you can run the following syntax:

- `./ftest.exe <graph_path> <src> <dst> <outputname>`

I often just run `make test src=<src> dst=<dst> graph=<graph_name>` to automatically run `dot` as well. Visualizing the `outfile` in .svg format

var documenterSearchIndex = {"docs":
[{"location":"core_functions/feature_graph.html#Feature-Graph","page":"Feature Graph","title":"Feature Graph","text":"","category":"section"},{"location":"core_functions/feature_graph.html","page":"Feature Graph","title":"Feature Graph","text":"Definition of the FeatureDiGraph object used for representing directed graphs with multi-dimensional features on edges.","category":"page"},{"location":"core_functions/feature_graph.html#Index","page":"Feature Graph","title":"Index","text":"","category":"section"},{"location":"core_functions/feature_graph.html","page":"Feature Graph","title":"Feature Graph","text":"Pages = [\"feature_graph.md\"]","category":"page"},{"location":"core_functions/feature_graph.html#Full-docs","page":"Feature Graph","title":"Full docs","text":"","category":"section"},{"location":"core_functions/feature_graph.html","page":"Feature Graph","title":"Feature Graph","text":"Modules = [MultiFlows]\nPages = [\"feature_graph.jl\"]\n","category":"page"},{"location":"core_functions/feature_graph.html#MultiFlows.FeatureDiGraph","page":"Feature Graph","title":"MultiFlows.FeatureDiGraph","text":"FeatureDiGraph{T,N}\n\nConcrete directed graph with a feature vector for each arc.\n\nThe default constructor expects srcnodes, dstnodes to be vectors of source and destination vertices for each edge and arc_features to by a vector of numbers. The following example initialises a directed graph with three vertices and edges and a single Float64 feature on each edge.\n\nExamplex\n\njulia> using MultiFlows\n\njulia> g1 = FeatureDiGraph([1,2,3], [2,3,1], [5., 5., 5.])\nFeatureDiGraph{Int64, Float64}([1, 2, 3], [2, 3, 1], [5.0, 5.0, 5.0])\n\n\n\n\n\n\n","category":"type"},{"location":"core_functions/feature_graph.html#MultiFlows.FeatureDiGraph-Union{Tuple{N}, Tuple{T}, Tuple{Graphs.AbstractGraph{T}, AbstractArray{N, N1} where N1}} where {T<:Number, N<:Number}","page":"Feature Graph","title":"MultiFlows.FeatureDiGraph","text":"FeatureDiGraph(g::AbstractGraph{T}, arc_features::AbstractArray{N})\n\nConstruct a feature graph from an AbstractGraph object and a set of features.\n\nExamples\n\njulia> using Graphs\n\njulia> gr = grid((3,2));\n\njulia> FeatureDiGraph(gr, ones(ne(gr), 2))\nFeatureDiGraph{Int64, Vector{Float64}}([1, 1, 2, 2, 3, 4, 5], [2, 4, 3, 5, 6, 5, 6], [[1.0, 1.0], [1.0, 1.0], [1.0, 1.0], [1.0, 1.0], [1.0, 1.0], [1.0, 1.0], [1.0, 1.0]])\n\n\n\n\n\n\n","category":"method"},{"location":"core_functions/feature_graph.html#MultiFlows.FeatureDiGraph-Union{Tuple{N}, Tuple{T}, Tuple{Vector{T}, Vector{T}, AbstractArray{N, N1} where N1}} where {T<:Number, N<:Number}","page":"Feature Graph","title":"MultiFlows.FeatureDiGraph","text":"FeatureDiGraph(srcnodes::Vector{T}, dstnodes::Vector{T}, arc_features::AbstractArray{N}) where {T<:Number, N<:Number}\n\nConstruct a FeatureDiGraph object where edge features are given by arc_features[i,:].\n\nExamplex\n\nFor example we can build a graph with a two-dimensional feature on each edge : \n\njulia> g = FeatureDiGraph([1,2,3], [2,3,1], 5 * ones(3,2))\nFeatureDiGraph{Int64, Vector{Float64}}([1, 2, 3], [2, 3, 1], [[5.0, 5.0], [5.0, 5.0], [5.0, 5.0]])\n\n\n\n\n\n","category":"method"},{"location":"core_functions/feature_graph.html#MultiFlows.FeatureDiGraphEdge","page":"Feature Graph","title":"MultiFlows.FeatureDiGraphEdge","text":"FeatureDiGraphEdge\n\nConcrete type representing FeatureDiGraph edges.\n\n\n\n\n\n","category":"type"},{"location":"core_functions/feature_graph.html#Graphs.SimpleGraphs.add_edge!-Union{Tuple{N}, Tuple{T}, Tuple{FeatureDiGraph{T, N}, T, T, N}} where {T<:Number, N}","page":"Feature Graph","title":"Graphs.SimpleGraphs.add_edge!","text":"Graphs.add_edge!(g::FeatureDiGraph{T,N}, src::T, dst::T, feat::N}\n\nAdd arc to a FeatureDiGraph object going from vertex src to dst and with features feat. Return true on success and false if graph already has an edge (src, dst). \n\nExamples\n\njulia> g = FeatureDiGraph([1,2,3], [2,3,1], ones(3,2));\n\njulia> add_edge!(g, 1, 4, [2., 2.])\ntrue\n\njulia> add_edge!(g, 1, 2, [3., 3.])\nfalse\n\njulia> nv(g), ne(g)\n(4, 4)\n\njulia> add_edge!(g, 1, 4, ones(3)) # must have feature_dim(g) == size(feat)\nERROR: DimensionMismatch(\"Expected feature dimension (2,) got (3,)\")\n[...]\n\n\n\n\n\n","category":"method"},{"location":"core_functions/feature_graph.html#Graphs.dst-Tuple{FeatureDiGraphEdge}","page":"Feature Graph","title":"Graphs.dst","text":"Graphs.dst(e::FeatureDiGraphEdge)\n\nGet edge destination.\n\n\n\n\n\n","category":"method"},{"location":"core_functions/feature_graph.html#Graphs.edges-Tuple{FeatureDiGraph}","page":"Feature Graph","title":"Graphs.edges","text":"edges(g::FeatureDiGraph)\n\nReturn list of edges of the graph. Needed for compatibility with Graphs.jl package.\n\nExamples\n\njulia> g = FeatureDiGraph([1,2,3,1], [2,3,1,4], [1,1,1,2]);\n\njulia> edges(g)\n4-element Vector{FeatureDiGraphEdge{Int64, Int64}}:\n FeatureDiGraphEdge{Int64, Int64}(1, 2, 1)\n FeatureDiGraphEdge{Int64, Int64}(2, 3, 1)\n FeatureDiGraphEdge{Int64, Int64}(3, 1, 1)\n FeatureDiGraphEdge{Int64, Int64}(1, 4, 2)\n\n\n\n\n\n\n","category":"method"},{"location":"core_functions/feature_graph.html#Graphs.has_edge-Union{Tuple{N}, Tuple{T}, Tuple{FeatureDiGraph{T, N}, T, T}} where {T<:Number, N}","page":"Feature Graph","title":"Graphs.has_edge","text":"Graphs.has_edge(g::FeatureDiGraph{T,N}, s::T, d::T)\n\nCheck if graph contains edge (s,d). \n\nExamples\n\njulia> using Graphs\n\njulia> has_edge(g, 1, 2)\ntrue\n\njulia> has_edge(g, 2, 1)\nfalse\n\n\n\n\n\n\n","category":"method"},{"location":"core_functions/feature_graph.html#Graphs.inneighbors-Union{Tuple{N}, Tuple{T}, Tuple{FeatureDiGraph{T, N}, T}} where {T<:Number, N}","page":"Feature Graph","title":"Graphs.inneighbors","text":"Graphs.inneighbors(g::FeatureDiGraph{T,N}, v::T)\n\nGet neighbors u of vertex v such that edge (u,v) belongs to the graph. Needed for compatibility with Graphs.jl package.\n\nExamples\n\njulia> inneighbors(g, 1)\n1-element Vector{Int64}:\n 3\n\n\n\n\n\n\n","category":"method"},{"location":"core_functions/feature_graph.html#Graphs.is_directed-Tuple{FeatureDiGraph}","page":"Feature Graph","title":"Graphs.is_directed","text":"Graphs.is_directed(g::FeatureDiGraph{T,N})\n\nCheck if the graph is directed, always returns true. Needed for compatibility with the Graphs.jl package.\n\n\n\n\n\n","category":"method"},{"location":"core_functions/feature_graph.html#Graphs.ne-Tuple{FeatureDiGraph}","page":"Feature Graph","title":"Graphs.ne","text":"ne(g::FeatureDiGraph)\n\nReturn number of arcs of the graph. Needed for compatibility with the Graphs.jl package.\n\nExamples\n\njulia> ne(g)\n3\n\n\n\n\n\n","category":"method"},{"location":"core_functions/feature_graph.html#Graphs.nv-Tuple{FeatureDiGraph}","page":"Feature Graph","title":"Graphs.nv","text":"nv(g::FeatureDiGraph)\n\nReturns number of vertices of the graph. Needed for compatibility with the Graphs.jl package.\n\nExamples\n\njulia> nv(g)\n3\n\n\n\n\n\n","category":"method"},{"location":"core_functions/feature_graph.html#Graphs.outneighbors-Union{Tuple{N}, Tuple{T}, Tuple{FeatureDiGraph{T, N}, T}} where {T<:Number, N}","page":"Feature Graph","title":"Graphs.outneighbors","text":"Graphs.outneighbors(g::FeatureDiGraph{T,N}, v::T)\n\nGet outgoing neighbors of vertex v in the graph. Needed for compatibility with Graphs.jl package.\n\nExamples\n\njulia> outneighbors(g, 1)\n2-element Vector{Int64}:\n 2\n 4\n\n\n\n\n\n\n","category":"method"},{"location":"core_functions/feature_graph.html#Graphs.src-Tuple{FeatureDiGraphEdge}","page":"Feature Graph","title":"Graphs.src","text":"Graphs.src(e::FeatureDiGraphEdge)\n\nGet edge source.\n\n\n\n\n\n","category":"method"},{"location":"core_functions/feature_graph.html#Graphs.weights","page":"Feature Graph","title":"Graphs.weights","text":"Graphs.weights(g::FeatureDiGraph, feature_idx::Int64=1)\n\nGet graph weight matrix corresponding to in feature with index idx. Needed for compatibility with Graphs.jl.\n\nExamples\n\njulia> using Graphs\n\njulia> g = FeatureDiGraph([1,2,3,1], [2,3,1,3],[[1,1],[1,1],[1,1],[4,1]])\nFeatureDiGraph{Int64, Vector{Int64}}([1, 2, 3, 1], [2, 3, 1, 3], [[1, 1], [1, 1], [1, 1], [4, 1]])\n\njulia> ds = dijkstra_shortest_paths(g, 1);\n\njulia> enumerate_paths(ds, 3)\n3-element Vector{Int64}:\n 1\n 2\n 3\n\njulia> ds = dijkstra_shortest_paths(g, 1, weights(g, 2));\n\njulia> enumerate_paths(ds, 3)\n2-element Vector{Int64}:\n 1\n 3\n\n\n\n\n\n","category":"function"},{"location":"core_functions/feature_graph.html#MultiFlows.arc_features-Tuple{FeatureDiGraph, Int64}","page":"Feature Graph","title":"MultiFlows.arc_features","text":"arc_features(g::FeatureDiGraph, idx::Int64)\n\nGet array of arc features corresponding to index idx. Returns a (ne(g), 1) array.\n\nExamples\n\njulia> g = FeatureDiGraph([1,2,3,1], [2,3,1,4], hcat(3*ones(4), 4*ones(4)));\n\njulia> arc_features(g, 1)\n4-element Vector{Float64}:\n 3.0\n 3.0\n 3.0\n 3.0\n\n\n\n\n\n","category":"method"},{"location":"core_functions/feature_graph.html#MultiFlows.arc_features-Tuple{FeatureDiGraph}","page":"Feature Graph","title":"MultiFlows.arc_features","text":"arc_features(g::FeatureDiGraph)\n\nGet array of arc features. Returns a (ne(g), feature_dim(g)) array.\n\nExamples\n\njulia> g = FeatureDiGraph([1,2,3,1], [2,3,1,4], hcat(3*ones(4), 4*ones(4)));\n\njulia> arc_features(g)\n4×2 Matrix{Float64}:\n 3.0  4.0\n 3.0  4.0\n 3.0  4.0\n 3.0  4.0\n\n\n\n\n\n","category":"method"},{"location":"core_functions/feature_graph.html#MultiFlows.double_edges!-Tuple{FeatureDiGraph}","page":"Feature Graph","title":"MultiFlows.double_edges!","text":"double_edges!(g::FeatureDiGraph)\n\nFor each edge (u,v) add edge (v,u) if not already present in the graph. Features of the edge are copied.\n\nExamples\n\njulia> using Graphs\n\njulia> g = FeatureDiGraph([1,2,3,1], [2,3,1,3],[[1,1],[1,1],[1,1],[4,1]])\nFeatureDiGraph{Int64, Vector{Int64}}([1, 2, 3, 1], [2, 3, 1, 3], [[1, 1], [1, 1], [1, 1], [4, 1]])\n\njulia> ne(g)\n4\n\njulia> double_edges!(g)\nFeatureDiGraph{Int64, Vector{Int64}}([1, 2, 3, 1, 2, 3], [2, 3, 1, 3, 1, 2], [[1, 1], [1, 1], [1, 1], [4, 1], [1, 1], [1, 1]])\n\njulia> ne(g)\n6\n\n\n\n\n\n","category":"method"},{"location":"core_functions/feature_graph.html#MultiFlows.feature_dim-Tuple{FeatureDiGraph}","page":"Feature Graph","title":"MultiFlows.feature_dim","text":"feature_dim(g::FeatureDiGraph)\n\nGet arc feature dimension. \n\nExamplex\n\njulia> g1 = FeatureDiGraph([1,2,3], [2,3,1], ones(3));\n\njulia> feature_dim(g1) # scalar features\n()\n\njulia> g2 = FeatureDiGraph([1,2,3], [2,3,1], ones(3, 2));\n\njulia> feature_dim(g2)  # two-dimension features\n(2,)\n\n\n\n\n\n","category":"method"},{"location":"core_functions/feature_graph.html#MultiFlows.feature_matrix-Tuple{FeatureDiGraph, AbstractArray{Int64, N} where N}","page":"Feature Graph","title":"MultiFlows.feature_matrix","text":"feature_matrix(g::FeatureDiGraph, feature_idx::AbstractArray{Int64})\n\nGet a nv(g) x nv(g) x size(feature_idx) matrix with coefficients equal to arc feature values corresponding to indexes in feature_idx. TODO : managing feature_idx with multiple dimensions.\n\nExamples\n\njulia> feature_matrix(g, [2, 1])\n4×4×2 Array{Float64, 3}:\n[:, :, 1] =\n 0.0  4.0  0.0  4.0\n 0.0  0.0  4.0  0.0\n 4.0  0.0  0.0  0.0\n 0.0  0.0  0.0  0.0\n\n[:, :, 2] =\n 0.0  3.0  0.0  3.0\n 0.0  0.0  3.0  0.0\n 3.0  0.0  0.0  0.0\n 0.0  0.0  0.0  0.0\n\n\n\n\n\n\n","category":"method"},{"location":"core_functions/feature_graph.html#MultiFlows.feature_matrix-Union{Tuple{FeatureDiGraph}, Tuple{N}, Tuple{T}, Tuple{FeatureDiGraph, Int64}} where {T<:Number, N}","page":"Feature Graph","title":"MultiFlows.feature_matrix","text":"feature_matrix(g::FeatureDiGraph, feature_idx::Int64)\n\nGet a nv(g) x nv(g) matrix with coefficients equal to arc feature values. Values returned as a sparse matrix.\n\nExamples\n\nGraph with scalar features : \n\njulia> g = FeatureDiGraph([1,2,3,1], [2,3,1,4], [5.0, 5.0, 5.0, 1.0]);\n\njulia> feature_matrix(g)\n4×4 SparseArrays.SparseMatrixCSC{Float64, Int64} with 4 stored entries:\n  ⋅   5.0   ⋅   1.0\n  ⋅    ⋅   5.0   ⋅\n 5.0   ⋅    ⋅    ⋅\n  ⋅    ⋅    ⋅    ⋅\n\n\nGraph with multi-dimensional features : \n\njulia> g = FeatureDiGraph([1,2,3,1], [2,3,1,4], hcat(3*ones(4), 4*ones(4)));\n\njulia> feature_matrix(g, 2)\n4×4 SparseArrays.SparseMatrixCSC{Float64, Int64} with 4 stored entries:\n  ⋅   4.0   ⋅   4.0\n  ⋅    ⋅   4.0   ⋅\n 4.0   ⋅    ⋅    ⋅\n  ⋅    ⋅    ⋅    ⋅\n\n\n\n\n\n\n","category":"method"},{"location":"core_functions/feature_graph.html#MultiFlows.scale_features-Union{Tuple{N}, Tuple{T}, Tuple{FeatureDiGraph{T, N}, N}} where {T<:Number, N}","page":"Feature Graph","title":"MultiFlows.scale_features","text":"scale_features(g::FeatureDiGraph{T,N}, factor::N)\n\nScale the features of the graph by factor. factor should have the same dimension as the edge features.\n\n\n\n\n\n","category":"method"},{"location":"mcf/io.html#Reading/writing-MCFs","page":"Reading/writing MCFs","title":"Reading/writing MCFs","text":"","category":"section"},{"location":"mcf/io.html#Index","page":"Reading/writing MCFs","title":"Index","text":"","category":"section"},{"location":"mcf/io.html","page":"Reading/writing MCFs","title":"Reading/writing MCFs","text":"Pages = [\"io.md\"]","category":"page"},{"location":"mcf/io.html#MCF-file-formats","page":"Reading/writing MCFs","title":"MCF file formats","text":"","category":"section"},{"location":"mcf/io.html#Reading-CSV-files","page":"Reading/writing MCFs","title":"Reading CSV files","text":"","category":"section"},{"location":"mcf/io.html","page":"Reading/writing MCFs","title":"Reading/writing MCFs","text":"MCF instances are stored as two CSV files, a link.csv file containing edge data and a service.csv file containing the demand data. ","category":"page"},{"location":"mcf/io.html","page":"Reading/writing MCFs","title":"Reading/writing MCFs","text":"Example of a link.csv file: ","category":"page"},{"location":"mcf/io.html","page":"Reading/writing MCFs","title":"Reading/writing MCFs","text":"|# LinkId|srcNodeId|dstNodeId|capacity |cost|latency|\n|--------|---------|---------|---------|----|-------|\n|1       |1        |4        |6        |2   |0      |\n|2       |1        |2        |12       |3   |0      |\n|3       |2        |4        |12       |3   |0      |\n|4       |4        |7        |5        |8   |0      |\n|5       |2        |3        |11       |4   |0      |\n|6       |3        |4        |20       |8   |0      |\n|7       |4        |6        |10       |3   |0      |\n|8       |6        |7        |20       |3   |0      |\n|9       |1        |5        |10       |80  |0      |\n|10      |5        |7        |10       |20  |0      |","category":"page"},{"location":"mcf/io.html","page":"Reading/writing MCFs","title":"Reading/writing MCFs","text":"Example of a service.csv file: ","category":"page"},{"location":"mcf/io.html","page":"Reading/writing MCFs","title":"Reading/writing MCFs","text":"|# DemandId|srcNodeId|dstNodeId|amount   |latency|\n|----------|---------|---------|---------|-------|\n|1         |1        |7        |5        |0      |\n|2         |2        |6        |5        |0      |\n|3         |3        |7        |5        |0      |","category":"page"},{"location":"mcf/io.html","page":"Reading/writing MCFs","title":"Reading/writing MCFs","text":"If dirname is the path of a directory containing both files as described in the example above we may load an MCF instance : ","category":"page"},{"location":"mcf/io.html","page":"Reading/writing MCFs","title":"Reading/writing MCFs","text":"julia> pb = load(dirname)\nMCF(nv = 7, ne = 10, nk = 3)\n\tDemand{Int64, Int64}(1, 7, 5)\n\tDemand{Int64, Int64}(2, 6, 5)\n\tDemand{Int64, Int64}(3, 7, 5)\n\njulia> adjacency_matrix(pb.graph)\n7×7 SparseArrays.SparseMatrixCSC{Int64, Int64} with 10 stored entries:\n ⋅  1  ⋅  1  1  ⋅  ⋅\n ⋅  ⋅  1  1  ⋅  ⋅  ⋅\n ⋅  ⋅  ⋅  1  ⋅  ⋅  ⋅\n ⋅  ⋅  ⋅  ⋅  ⋅  1  1\n ⋅  ⋅  ⋅  ⋅  ⋅  ⋅  1\n ⋅  ⋅  ⋅  ⋅  ⋅  ⋅  1\n ⋅  ⋅  ⋅  ⋅  ⋅  ⋅  ⋅","category":"page"},{"location":"mcf/io.html","page":"Reading/writing MCFs","title":"Reading/writing MCFs","text":"By default the edges in the link.csv file are added only in one direction. Ensuring that edges exist in both directions can be achieved by passing edge_dir = :double to the load function. Note that for each edge that is specified in only one direction within the CSV file, features will be copied.","category":"page"},{"location":"mcf/io.html","page":"Reading/writing MCFs","title":"Reading/writing MCFs","text":"julia> pb = load(dirname, edge_dir=:double)\nMCF(nv = 7, ne = 20, nk = 3)\n\tDemand{Int64, Int64}(1, 7, 5)\n\tDemand{Int64, Int64}(2, 6, 5)\n\tDemand{Int64, Int64}(3, 7, 5)\n\njulia> adjacency_matrix(pb.graph)\n7×7 SparseArrays.SparseMatrixCSC{Int64, Int64} with 20 stored entries:\n ⋅  1  ⋅  1  1  ⋅  ⋅\n 1  ⋅  1  1  ⋅  ⋅  ⋅\n ⋅  1  ⋅  1  ⋅  ⋅  ⋅\n 1  1  1  ⋅  ⋅  1  1\n 1  ⋅  ⋅  ⋅  ⋅  ⋅  1\n ⋅  ⋅  ⋅  1  ⋅  ⋅  1\n ⋅  ⋅  ⋅  1  1  1  ⋅","category":"page"},{"location":"mcf/io.html#Saving-instances","page":"Reading/writing MCFs","title":"Saving instances","text":"","category":"section"},{"location":"mcf/io.html","page":"Reading/writing MCFs","title":"Reading/writing MCFs","text":"To save an MCF instance to a directory : ","category":"page"},{"location":"mcf/io.html","page":"Reading/writing MCFs","title":"Reading/writing MCFs","text":"julia> save(pb, \"path_to_instance\")","category":"page"},{"location":"mcf/io.html","page":"Reading/writing MCFs","title":"Reading/writing MCFs","text":"This will create two files : path_to_instance/link.csv and path_to_instance/service.csv.","category":"page"},{"location":"mcf/io.html#Full-docs","page":"Reading/writing MCFs","title":"Full docs","text":"","category":"section"},{"location":"mcf/io.html","page":"Reading/writing MCFs","title":"Reading/writing MCFs","text":"Modules = [MultiFlows]\nPages = [\"io.jl\"]\n","category":"page"},{"location":"mcf/io.html#MultiFlows.UnknownMultiFlowFormat","page":"Reading/writing MCFs","title":"MultiFlows.UnknownMultiFlowFormat","text":"UnknownMCFFormat Exception\n\nException raised when trying to load instance from unknown file format.\n\n\n\n\n\n","category":"type"},{"location":"mcf/io.html#MultiFlows.is_instance_dir-Tuple{String}","page":"Reading/writing MCFs","title":"MultiFlows.is_instance_dir","text":"is_instance_dir(dirname::String)\n\nCheck if a directory contains files link.csv, service.csv.\n\njulia> save(pb, \"test_instance\")\n(\"test_instance/link.csv\", \"test_instance/service.csv\")\n\njulia> is_instance_dir(\"test_instance\")\ntrue\n\n\n\n\n\n","category":"method"},{"location":"mcf/io.html#MultiFlows.load-Tuple{String}","page":"Reading/writing MCFs","title":"MultiFlows.load","text":"load(dirname::String; format=:csv, edge_dir=:single)\n\nLoad MultiFlow problem from file. If format=:csv uses load_csv(dirname::String) (at this time CSV files are the only supported format). edge_dir can be one of the following : \n\n:single : each edge in the input file is interpreted as a directed edge\n:double : each edge in the input file is interpreted as existing in both directions with the same attributes and features\n\n\n\n\n\n","category":"method"},{"location":"mcf/io.html#MultiFlows.load_csv-Tuple{String}","page":"Reading/writing MCFs","title":"MultiFlows.load_csv","text":"load_csv(dirname::String)\n\nLoad MultiFlow instance from CSV files. Default is to search for a link.csv and service.csv file.\n\n\n\n\n\n","category":"method"},{"location":"mcf/io.html#MultiFlows.save-Tuple{MCF, String}","page":"Reading/writing MCFs","title":"MultiFlows.save","text":"save(pb::MCF, dirname::String)\n\nSave MCF instance to dirname. Will create the files <dirname>/link.csv and <dirname>/service.csv. If folder does not exist it will be created.\n\n\n\n\n\n","category":"method"},{"location":"mcf/mcf.html#Multi-Commodity-Flow","page":"Multi-Commodity Flow","title":"Multi-Commodity Flow","text":"","category":"section"},{"location":"mcf/mcf.html","page":"Multi-Commodity Flow","title":"Multi-Commodity Flow","text":"MultiFlows.jl offers the MCF interface for creating Multi-Commodity Flow problems. An MCF instance is defined by a capacitated graph and a set of demands. The objective is to find a set of paths that satisfy the demands without exceeding edge capacities.","category":"page"},{"location":"mcf/mcf.html#Index","page":"Multi-Commodity Flow","title":"Index","text":"","category":"section"},{"location":"mcf/mcf.html","page":"Multi-Commodity Flow","title":"Multi-Commodity Flow","text":"Pages = [\"mcf.md\"]","category":"page"},{"location":"mcf/mcf.html#Full-docs","page":"Multi-Commodity Flow","title":"Full docs","text":"","category":"section"},{"location":"mcf/mcf.html","page":"Multi-Commodity Flow","title":"Multi-Commodity Flow","text":"Modules = [MultiFlows]\nPages = [\"demand.jl\", \"mcf.jl\"]\n","category":"page"},{"location":"mcf/mcf.html#MultiFlows.AbstractDemand","page":"Multi-Commodity Flow","title":"MultiFlows.AbstractDemand","text":"AbstractDemand\n\nAbstract type subtyped for creating MCF demands.\n\n\n\n\n\n","category":"type"},{"location":"mcf/mcf.html#MultiFlows.Demand","page":"Multi-Commodity Flow","title":"MultiFlows.Demand","text":"MCFDemand\n\nConcrete demand type for MCF problems. A demand has a source node src, destination node dst and an amount amount.\n\n\n\n\n\n","category":"type"},{"location":"mcf/mcf.html#MultiFlows.MCF","page":"Multi-Commodity Flow","title":"MultiFlows.MCF","text":"MCF\n\nMulti-Commodity Flow problem data container. The default expects graph to be a FeatureDiGraph object with 2-dimension edge features [cost, capacity]. demands must be a list of Demand objects.\n\nExamples\n\njulia> g = FeatureDiGraph([1,2,3,1], [2,3,1,3], ones(4,2))\nFeatureDiGraph{Int64, Vector{Float64}}([1, 2, 3, 1], [2, 3, 1, 3], [[1.0, 1.0], [1.0, 1.0], [1.0, 1.0], [1.0, 1.0]])\n\njulia> MCF(g, [Demand(1, 2, 1.0)])\nMCF(nv = 3, ne = 4, nk = 1)\n\tDemand{Int64, Float64}(1, 2, 1.0)\n\n\n\n\n\n","category":"type"},{"location":"mcf/mcf.html#MultiFlows.MCF-Union{Tuple{N}, Tuple{T}, Tuple{Graphs.AbstractGraph{T}, Vector{N}, Vector{N}, Array{Demand{T, N}, 1}}} where {T<:Number, N<:Number}","page":"Multi-Commodity Flow","title":"MultiFlows.MCF","text":"MCF(g::AbstractGraph{T}, cost::Vector{N}, capacity::Vector{N}, demands::Vector{Demand{T,N})\n\nCreate a MCF object from an AbstractGraph object, a cost and capacity vector with length ne(g) and a set of demands.\n\nExamples\n\njulia> using Graphs\n\njulia> gr = grid((3,2));\n\njulia> MCF(gr, ones(ne(gr)), ones(ne(gr)), [Demand(1,6,1.0)])\nMCF(nv = 6, ne = 7, nk = 1)\n\tDemand{Int64, Float64}(1, 6, 1.0)\n\ncost, capacity vectors must have same length as ne(gr) : \n\n\n\n\n\n","category":"method"},{"location":"mcf/mcf.html#Base.show-Tuple{IO, MCF}","page":"Multi-Commodity Flow","title":"Base.show","text":"Base.show(io::IO, pb::MCF)\n\nShow MCF object.\n\n\n\n\n\n","category":"method"},{"location":"mcf/mcf.html#Graphs.ne-Tuple{MCF}","page":"Multi-Commodity Flow","title":"Graphs.ne","text":"ne(pb::MCF)\n\nNumber of edges in the MCF network.\n\nExamples\n\njulia> ne(pb)\n7\n\n\n\n\n\n","category":"method"},{"location":"mcf/mcf.html#Graphs.nv-Tuple{MCF}","page":"Multi-Commodity Flow","title":"Graphs.nv","text":"nv(pb::MCF)\n\nNumber of vertices.\n\nExamples\n\njulia> nv(pb)\n6\n\n\n\n\n\n","category":"method"},{"location":"mcf/mcf.html#MultiFlows.capacity_matrix-Tuple{MCF}","page":"Multi-Commodity Flow","title":"MultiFlows.capacity_matrix","text":"capacity_matrix(pb::MCF)\n\nReturn a sparse matrix with dimension (nv(pb), nv(pb)) with values equal to arc capacity.\n\nExamples\n\njulia> capacity_matrix(pb)\n6×6 SparseArrays.SparseMatrixCSC{Float64, Int64} with 7 stored entries:\n  ⋅   2.0   ⋅   2.0   ⋅    ⋅\n  ⋅    ⋅   2.0   ⋅   2.0   ⋅\n  ⋅    ⋅    ⋅    ⋅    ⋅   2.0\n  ⋅    ⋅    ⋅    ⋅   2.0   ⋅\n  ⋅    ⋅    ⋅    ⋅    ⋅   2.0\n  ⋅    ⋅    ⋅    ⋅    ⋅    ⋅\n\n\n\n\n\n","category":"method"},{"location":"mcf/mcf.html#MultiFlows.cost_matrix-Tuple{MCF}","page":"Multi-Commodity Flow","title":"MultiFlows.cost_matrix","text":"cost_matrix(pb::MCF)\n\nReturn a sparse matrix with dimension (nv(pb), nv(pb)) with values equal to arc costs.\n\nExamples\n\njulia> cost_matrix(pb)\n6×6 SparseArrays.SparseMatrixCSC{Float64, Int64} with 7 stored entries:\n  ⋅   1.0   ⋅   1.0   ⋅    ⋅\n  ⋅    ⋅   1.0   ⋅   1.0   ⋅\n  ⋅    ⋅    ⋅    ⋅    ⋅   1.0\n  ⋅    ⋅    ⋅    ⋅   1.0   ⋅\n  ⋅    ⋅    ⋅    ⋅    ⋅   1.0\n  ⋅    ⋅    ⋅    ⋅    ⋅    ⋅\n\n\n\n\n\n","category":"method"},{"location":"mcf/mcf.html#MultiFlows.has_demand-Union{Tuple{N}, Tuple{T}, Tuple{MCF{T, N}, T, T}} where {T, N}","page":"Multi-Commodity Flow","title":"MultiFlows.has_demand","text":"has_demand(pb::MCF{T,N}, s::T, d::T)\n\nCheck if problem has a demand originating at vertex s and with destination d.\n\n\n\n\n\n","category":"method"},{"location":"mcf/mcf.html#MultiFlows.nk-Tuple{MCF}","page":"Multi-Commodity Flow","title":"MultiFlows.nk","text":"nk(pb::MCF)\n\nNumber of demands in the MCF instance.\n\nExamples\n\njulia> nk(pb)\n1\n\n\n\n\n\n","category":"method"},{"location":"mcf/mcf.html#MultiFlows.normalize-Tuple{MCF}","page":"Multi-Commodity Flow","title":"MultiFlows.normalize","text":"normalize(pb::MCF)\n\nNormalize MCF instance. Costs are scaled by 1 / max(pb.cost), capacity and demand amount are scaled by 1 / max(max(pb.capacity), max(pb.amount)).\n\nExample\n\njulia> pb = MCF(grid((3,2)), collect(1.0:7.0), collect(0.0:2:13.0), [Demand(1,6,10.0)])\nMCF(nv = 6, ne = 7, nk = 1)\n\tDemand{Int64, Float64}(1, 6, 10.0)\n\njulia> pbn = normalize(pb)\nMCF(nv = 6, ne = 7, nk = 1)\n\tDemand{Int64, Float64}(1, 6, 0.8333333333333333)\n\njulia> cost_matrix(pbn)\n6×6 SparseArrays.SparseMatrixCSC{Float64, Int64} with 7 stored entries:\n  ⋅   0.142857   ⋅        0.285714   ⋅         ⋅\n  ⋅    ⋅        0.428571   ⋅        0.571429   ⋅\n  ⋅    ⋅         ⋅         ⋅         ⋅        0.714286\n  ⋅    ⋅         ⋅         ⋅        0.857143   ⋅\n  ⋅    ⋅         ⋅         ⋅         ⋅        1.0\n  ⋅    ⋅         ⋅         ⋅         ⋅         ⋅\n\njulia> capacity_matrix(pbn)\n6×6 SparseArrays.SparseMatrixCSC{Float64, Int64} with 7 stored entries:\n  ⋅   0.0   ⋅        0.166667   ⋅         ⋅\n  ⋅    ⋅   0.333333   ⋅        0.5        ⋅\n  ⋅    ⋅    ⋅         ⋅         ⋅        0.666667\n  ⋅    ⋅    ⋅         ⋅        0.833333   ⋅\n  ⋅    ⋅    ⋅         ⋅         ⋅        1.0\n  ⋅    ⋅    ⋅         ⋅         ⋅         ⋅\n\n\n\n\n\n","category":"method"},{"location":"mcf/mcf.html#MultiFlows.scale-Union{Tuple{MCF{T, N}}, Tuple{N}, Tuple{T}, Tuple{MCF{T, N}, Any}, Tuple{MCF{T, N}, Any, Any}} where {T, N}","page":"Multi-Commodity Flow","title":"MultiFlows.scale","text":"scale(pb::MCF, cost_factor=1.0, capacity_factor=1.0)\n\nReturn a new MCF instance with costs scaled by a cost_factor, capacity and demand amounts scaled by capacity_factor.\n\nExample\n\njulia> pb1 = scale(pb, 1.5, 3)\nMCF(nv = 6, ne = 7, nk = 1)\n\tDemand{Int64, Float64}(1, 6, 3.0)\n\njulia> cost_matrix(pb1)\n6×6 SparseArrays.SparseMatrixCSC{Float64, Int64} with 7 stored entries:\n  ⋅   1.5   ⋅   1.5   ⋅    ⋅\n  ⋅    ⋅   1.5   ⋅   1.5   ⋅\n  ⋅    ⋅    ⋅    ⋅    ⋅   1.5\n  ⋅    ⋅    ⋅    ⋅   1.5   ⋅\n  ⋅    ⋅    ⋅    ⋅    ⋅   1.5\n  ⋅    ⋅    ⋅    ⋅    ⋅    ⋅\n\njulia> capacity_matrix(pb1)\n6×6 SparseArrays.SparseMatrixCSC{Float64, Int64} with 7 stored entries:\n  ⋅   6.0   ⋅   6.0   ⋅    ⋅ \n  ⋅    ⋅   6.0   ⋅   6.0   ⋅ \n  ⋅    ⋅    ⋅    ⋅    ⋅   6.0\n  ⋅    ⋅    ⋅    ⋅   6.0   ⋅ \n  ⋅    ⋅    ⋅    ⋅    ⋅   6.0\n  ⋅    ⋅    ⋅    ⋅    ⋅    ⋅ \n\n\n\n\n\n","category":"method"},{"location":"mcf/mcf.html#MultiFlows.scale_demands-Tuple{MCF, Any}","page":"Multi-Commodity Flow","title":"MultiFlows.scale_demands","text":"scale_demands(pb::MCF, factor)\n\nScale the amount of the demands by factor. Returns new list of demands.\n\nExample\n\njulia> dems = scale_demands(pb, 2)\n1-element Vector{Demand{Int64, Float64}}:\n Demand{Int64, Float64}(1, 6, 2.0)\n\n\n\n\n\n\n","category":"method"},{"location":"mcf/mcf.html#MultiFlows.weight_matrix","page":"Multi-Commodity Flow","title":"MultiFlows.weight_matrix","text":"weight_matrix(pb::MCF, idx::Int64=1)\n\nReturns a (nv(pb), nv(pb)) matrix with elements equal to edge features corresponding to idx.\n\nExamples\n\njulia> pb = MCF(grid((3,2)), ones(7), 2*ones(7), [Demand(1,6,1.0)]);\n\njulia> weight_matrix(pb)\n6×6 SparseArrays.SparseMatrixCSC{Float64, Int64} with 7 stored entries:\n  ⋅   1.0   ⋅   1.0   ⋅    ⋅\n  ⋅    ⋅   1.0   ⋅   1.0   ⋅\n  ⋅    ⋅    ⋅    ⋅    ⋅   1.0\n  ⋅    ⋅    ⋅    ⋅   1.0   ⋅\n  ⋅    ⋅    ⋅    ⋅    ⋅   1.0\n  ⋅    ⋅    ⋅    ⋅    ⋅    ⋅\n\n\n\n\n\n\n","category":"function"},{"location":"mcf/plot.html#Plotting","page":"Plotting","title":"Plotting","text":"","category":"section"},{"location":"mcf/plot.html","page":"Plotting","title":"Plotting","text":"Plotting MCF problems is done by using the GraphPlot.jl package. A plot can be generated through use of the mcfplot(pb::MCF, layout::Function=spring_layout) function. ","category":"page"},{"location":"mcf/plot.html","page":"Plotting","title":"Plotting","text":"julia> pb = load(\"instances/toytests/test1/\", edge_dir=:single)\nMCF(nv = 7, ne = 10, nk = 3)\n\tDemand{Int64, Int64}(1, 7, 5)\n\tDemand{Int64, Int64}(2, 6, 5)\n\tDemand{Int64, Int64}(3, 7, 5)\n\njulia> # draw and save figure\n\njulia> draw(PNG(\"test1.png\", 16cm, 16cm), mcfplot(pb))","category":"page"},{"location":"mcf/plot.html","page":"Plotting","title":"Plotting","text":"(Image: toytesttest1)","category":"page"},{"location":"mcf/plot.html#Index","page":"Plotting","title":"Index","text":"","category":"section"},{"location":"mcf/plot.html","page":"Plotting","title":"Plotting","text":"Pages = [\"plot.md\"]","category":"page"},{"location":"mcf/plot.html#Full-docs","page":"Plotting","title":"Full docs","text":"","category":"section"},{"location":"mcf/plot.html","page":"Plotting","title":"Plotting","text":"Modules = [MultiFlows]\nPages = [\"plot.jl\"]\n","category":"page"},{"location":"mcf/plot.html#MultiFlows.mcfplot","page":"Plotting","title":"MultiFlows.mcfplot","text":"mcfplot(pb::MCF, layout::Function=spring_layout)\n\nPlot MCF problem. MultiFlows.jl uses the GraphPlot.jl package for generating graph plots.\n\n\n\n\n\n","category":"function"},{"location":"index.html#MultiFlows.jl-Documentation","page":"MultiFlows.jl Documentation","title":"MultiFlows.jl Documentation","text":"","category":"section"},{"location":"index.html","page":"MultiFlows.jl Documentation","title":"MultiFlows.jl Documentation","text":"Modules = [MultiFlows]\nPages = [\"MultiFlows.jl\"]\n","category":"page"},{"location":"index.html#MultiFlows.MultiFlows","page":"MultiFlows.jl Documentation","title":"MultiFlows.MultiFlows","text":"MultiFlows\n\nMultiFlows package documentation.\n\n\n\n\n\n","category":"module"}]
}

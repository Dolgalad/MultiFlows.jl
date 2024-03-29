# Reading/writing MCFs

## Index

```@index
Pages = ["io.md"]
```

## MCF file formats
### Reading CSV files
MCF instances are stored as two CSV files, a `link.csv` file containing edge data and a `service.csv` file containing the demand data. 

Example of a `link.csv` file: 
```csv
|# LinkId|srcNodeId|dstNodeId|capacity |cost|latency|
|--------|---------|---------|---------|----|-------|
|1       |1        |4        |6        |2   |0      |
|2       |1        |2        |12       |3   |0      |
|3       |2        |4        |12       |3   |0      |
|4       |4        |7        |5        |8   |0      |
|5       |2        |3        |11       |4   |0      |
|6       |3        |4        |20       |8   |0      |
|7       |4        |6        |10       |3   |0      |
|8       |6        |7        |20       |3   |0      |
|9       |1        |5        |10       |80  |0      |
|10      |5        |7        |10       |20  |0      |
```

Example of a `service.csv` file: 
```csv
|# DemandId|srcNodeId|dstNodeId|amount   |latency|
|----------|---------|---------|---------|-------|
|1         |1        |7        |5        |0      |
|2         |2        |6        |5        |0      |
|3         |3        |7        |5        |0      |
```

If `dirname` is the path of a directory containing both files as described in the example above we may load an MCF instance : 
```julia
julia> pb = load(dirname)
MCF(nv = 7, ne = 10, nk = 3)
	Demand{Int64, Int64}(1, 7, 5)
	Demand{Int64, Int64}(2, 6, 5)
	Demand{Int64, Int64}(3, 7, 5)

julia> adjacency_matrix(pb.graph)
7×7 SparseArrays.SparseMatrixCSC{Int64, Int64} with 10 stored entries:
 ⋅  1  ⋅  1  1  ⋅  ⋅
 ⋅  ⋅  1  1  ⋅  ⋅  ⋅
 ⋅  ⋅  ⋅  1  ⋅  ⋅  ⋅
 ⋅  ⋅  ⋅  ⋅  ⋅  1  1
 ⋅  ⋅  ⋅  ⋅  ⋅  ⋅  1
 ⋅  ⋅  ⋅  ⋅  ⋅  ⋅  1
 ⋅  ⋅  ⋅  ⋅  ⋅  ⋅  ⋅
```

By default the edges in the `link.csv` file are added only in one direction. Ensuring that edges exist in both directions can be achieved by passing `edge_dir = :double` to the `load` function. Note that for each edge that is specified in only one direction within the CSV file, features will be copied.

```julia
julia> pb = load(dirname, edge_dir=:double)
MCF(nv = 7, ne = 20, nk = 3)
	Demand{Int64, Int64}(1, 7, 5)
	Demand{Int64, Int64}(2, 6, 5)
	Demand{Int64, Int64}(3, 7, 5)

julia> adjacency_matrix(pb.graph)
7×7 SparseArrays.SparseMatrixCSC{Int64, Int64} with 20 stored entries:
 ⋅  1  ⋅  1  1  ⋅  ⋅
 1  ⋅  1  1  ⋅  ⋅  ⋅
 ⋅  1  ⋅  1  ⋅  ⋅  ⋅
 1  1  1  ⋅  ⋅  1  1
 1  ⋅  ⋅  ⋅  ⋅  ⋅  1
 ⋅  ⋅  ⋅  1  ⋅  ⋅  1
 ⋅  ⋅  ⋅  1  1  1  ⋅
```

### Saving instances
To save an MCF instance to a directory : 

```@example savemcf
push!(LOAD_PATH, "../../..") # hide
using Graphs, CSV, MultiFlows, DataFrames, Latexify # hide
pb = MCF(grid((3,2)), ones(Int64,7), 1:7, [Demand(1,2,2)]);
save(pb, "instance")
df = CSV.read("instance/link.csv", DataFrame)
mdtable(df,latex=false) # hide
```

`service.csv` contents : 
```@example savemcf
df = CSV.read("instance/service.csv", DataFrame)
mdtable(df,latex=false) # hide
```



This will create two files : `path_to_instance/link.csv` and `path_to_instance/service.csv`.

## Full docs

```@autodocs
Modules = [MultiFlows]
Pages = ["io.jl"]

```


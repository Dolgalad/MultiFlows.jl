"""
    make_batchable(gl::Vector{GNNGraph})

Make GNNGraphs batchable, pads the `targets` fields with zeros thus ensuring that those fields may be concatenanted along their last dimension. Adds the `target_mask` field so that `g.targets[g.target_mask]` returns the original target values.

# Example
```jldoctest makebatch; setup = :(using GraphNeuralNetworks, JuMP, Graphs)
julia> pb1 = MCF(grid((2,2)), rand(4), rand(4), [Demand(1,4,1.), Demand(1,4,1.), Demand(3,2,1.)]);

julia> _,(mod1,_) = solve_compact(pb1, max_acceptance=true, return_model=true);

julia> y1 = value.(mod1[:x]) .> 0 ;

julia> gnn1 = to_gnngraph(pb1, y1)
GNNGraph:
  num_nodes: 7
  num_edges: 14
  ndata:
	mask = 7-element Vector{Bool}
  edata:
	e = 3×14 Matrix{Float64}
	demand_amounts_mask = 14-element BitVector
	mask = 14-element Vector{Bool}
	demand_to_source_mask = 14-element Vector{Bool}
	target_to_demand_mask = 14-element Vector{Bool}
  gdata:
	edge_stacked_idx = 24×1 Matrix{Int64}
	targets = 8×3×1 BitArray{3}
	K = 3
	demand_stacked_idx = 24×1 Matrix{Int64}
	E = 8

julia> pb2 = MCF(grid((2,3)), rand(7), rand(7), [Demand(1,4,1.), Demand(1,4,1.), Demand(3,2,1.)]);

julia> _,(mod2,_) = solve_compact(pb2, max_acceptance=true, return_model=true);

julia> y2 = value.(mod2[:x]) .> 0 ;

julia> gnn2 = to_gnngraph(pb2, y2)
GNNGraph:
  num_nodes: 9
  num_edges: 20
  ndata:
	mask = 9-element Vector{Bool}
  edata:
	e = 3×20 Matrix{Float64}
	demand_amounts_mask = 20-element BitVector
	mask = 20-element Vector{Bool}
	demand_to_source_mask = 20-element Vector{Bool}
	target_to_demand_mask = 20-element Vector{Bool}
  gdata:
	edge_stacked_idx = 42×1 Matrix{Int64}
	targets = 14×3×1 BitArray{3}
	K = 3
	demand_stacked_idx = 42×1 Matrix{Int64}
	E = 14

```

If we try to create a batch of `gnn1` and `gnn2` a `DimensionMismatch` error is raised : 
```jldoctest makebatch
julia> batch([gnn1, gnn2])
ERROR: DimensionMismatch("mismatch in dimension 1 (expected 24 got 42)")
[...]
```

```jldoctest makebatch
julia> gl = make_batchable(GNNGraph[gnn1,gnn2])
2-element Vector{GNNGraph}:
 GNNGraph(7, 14) with mask: 7-element, (e: 3×14, demand_amounts_mask: 14-element, mask: 14-element, demand_to_source_mask: 14-element, target_to_demand_mask: 14-element), (targets: 14×3×1, K: 0-dimensional, target_mask: 14×3×1, E: 0-dimensional) data
 GNNGraph(9, 20) with mask: 9-element, (e: 3×20, demand_amounts_mask: 20-element, mask: 20-element, demand_to_source_mask: 20-element, target_to_demand_mask: 20-element), (targets: 14×3×1, K: 0-dimensional, target_mask: 14×3×1, E: 0-dimensional) data

julia> batch_g = batch(gl)
GNNGraph:
  num_nodes: 16
  num_edges: 34
  num_graphs: 2
  ndata:
	mask = 16-element Vector{Bool}
  edata:
	e = 3×34 Matrix{Float64}
	demand_amounts_mask = 34-element BitVector
	mask = 34-element Vector{Bool}
	demand_to_source_mask = 34-element Vector{Bool}
	target_to_demand_mask = 34-element Vector{Bool}
  gdata:
	targets = 14×3×2 Array{Bool, 3}
	K = 2-element Vector{Int64}
	target_mask = 14×3×2 Array{Bool, 3}
	E = 2-element Vector{Int64}
```

Retrieving the labels 
```jldoctest makebatch
julia> gl[1].targets[gl[1].target_mask] == vec(y1)
true

julia> gl[2].targets[gl[2].target_mask] == vec(y2)
true

julia> batch_g.targets[batch_g.target_mask] == vcat(vec(y1), vec(y2))
true
```
"""
function make_batchable(gl::Vector{GNNGraph})
    max_k = maximum(g.K for g in gl)
    max_ne = maximum(size(g.targets,1) for g in gl)
    #max_stacked = maximum(size(g.demand_stacked_idx,1) for g in gl)
    new_graphs = GNNGraph[]
    for g in gl
        # targets and target mask
        nedges = size(g.targets,1)
        new_targets = zeros(Bool, (max_ne, max_k))
        new_targets[1:nedges, 1:size(g.targets, 2)] .= g.targets
        target_mask = zeros(Bool, (max_ne, max_k))
        target_mask[1:nedges, 1:size(g.targets, 2)] .= 1
        ng = GNNGraph(g, gdata=(;
                                   K=g.K, 
                                   E=g.E, 
                                   targets=new_targets, 
                                   target_mask=target_mask,
                                  )
                     )
        push!(new_graphs, ng)
    end
    return new_graphs
end


"""
    make_batchable(gl::Vector{AugmentedGNNGraph})

Specialization of the [`make_batchable`](@ref) for [`AugmentedGNNGraph`](@ref) objects. Ensures that all the items in the batch have compatible feature dimensions.

# Example
```jldoctest makebatch; setup = :(using GraphNeuralNetworks, JuMP, Graphs)
julia> pb1 = MCF(grid((2,2)), rand(4), rand(4), [Demand(1,4,1.), Demand(1,4,1.), Demand(3,2,1.)]);

julia> _,(mod1,_) = solve_compact(pb1, max_acceptance=true, return_model=true);

julia> y1 = value.(mod1[:x]) .> 0 ;

julia> gnn1 = AugmentedGNNGraph(to_gnngraph(pb1, y1));

julia> pb2 = MCF(grid((2,3)), rand(7), rand(7), [Demand(1,4,1.), Demand(1,4,1.), Demand(3,2,1.)]);

julia> _,(mod2,_) = solve_compact(pb2, max_acceptance=true, return_model=true);

julia> y2 = value.(mod2[:x]) .> 0 ;

julia> gnn2 = AugmentedGNNGraph(to_gnngraph(pb2, y2));

julia> bg = make_batchable([gnn1, gnn2])
2-element Vector{AugmentedGNNGraph}:
 AugmentedGNNGraph(GNNGraph(7, 14) with mask: 7-element, (e: 3×14, demand_amounts_mask: 14-element, mask: 14-element, demand_to_source_mask: 14-element, target_to_demand_mask: 14-element), (edge_stacked_idx: 42×1, targets: 14×3×1, K: 0-dimensional, demand_stacked_idx: 42×1, target_mask: 14×3×1, E: 0-dimensional) data)
 AugmentedGNNGraph(GNNGraph(9, 20) with mask: 9-element, (e: 3×20, demand_amounts_mask: 20-element, mask: 20-element, demand_to_source_mask: 20-element, target_to_demand_mask: 20-element), (edge_stacked_idx: 42×1, targets: 14×3×1, K: 0-dimensional, demand_stacked_idx: 42×1, target_mask: 14×3×1, E: 0-dimensional) data)
```

Notice that the values of the `edge_stacked_idx, demand_stacked_idx` have been changed. The vectors have been padded with zero values so that their dimensions match.
```jldoctest makebatch
julia> size(gnn1.g.edge_stacked_idx), size(gnn1.g.demand_stacked_idx)
((24, 1), (24, 1))

julia> size(bg[1].g.edge_stacked_idx), size(bg[1].g.demand_stacked_idx)
((42, 1), (42, 1))

```
"""
function make_batchable(gl::Vector{AugmentedGNNGraph})
    max_k = maximum(ag.g.K for ag in gl)
    max_ne = maximum(size(ag.g.targets,1) for ag in gl)
    max_stacked = maximum(size(ag.g.demand_stacked_idx,1) for ag in gl)
    new_graphs = AugmentedGNNGraph[]
    for ag in gl
        # targets and target mask
        nedges = size(ag.g.targets,1)
        new_targets = zeros(Bool, (max_ne, max_k))
        new_targets[1:nedges, 1:size(ag.g.targets, 2)] .= ag.g.targets
        target_mask = zeros(Bool, (max_ne, max_k))
        target_mask[1:nedges, 1:size(ag.g.targets, 2)] .= 1
        # stacked indexes
        new_demand_stacked_idx = zeros(Int64, max_stacked)
        new_demand_stacked_idx[1:size(ag.g.demand_stacked_idx,1)] .= ag.g.demand_stacked_idx
        new_edge_stacked_idx = zeros(Int64, max_stacked)
        new_edge_stacked_idx[1:size(ag.g.demand_stacked_idx,1)] .= ag.g.edge_stacked_idx
        ng = GNNGraph(ag.g, gdata=(;
                                   K=ag.g.K, 
                                   E=ag.g.E, 
                                   targets=new_targets, 
                                   target_mask=target_mask,
                                   demand_stacked_idx=new_demand_stacked_idx,
                                   edge_stacked_idx=new_edge_stacked_idx
                                  )
                     )
        push!(new_graphs, AugmentedGNNGraph(ng))
    end
    return new_graphs
end

"""
    load_dataset(dataset_dir::String; 
                      scale_instances::Bool=true, 
                      batchable::Bool=true, 
                      edge_dir::Symbol=:double,
                      feature_type::DataType=Float32,
                      show_progress::Bool=false
    )

Load dataset from directory. If instance directories contain a `labels.jld2` file it is added to the `targets` field of the GNNGraph object. If `scale_instances=true` instances are scaled by calling [`scale`](@ref) before being added, if `batchable=true` a call to [`make_batchable`](@ref) is executed on the list of graphs. 

# Example
Create a simple dataset : 
```jldoctest loaddataset; setup = :(using Graphs, Random, JLD2, JuMP, GraphNeuralNetworks; Random.seed!(123))
julia> pb = MCF(grid((2,2)), rand(4), rand(4), [Demand(1,4,1.), Demand(1,4,1.), Demand(3,2,1.)]);

julia> # labeling function

julia> function labeling_f(path::String)
           pb = MultiFlows.load(path, edge_dir=:double)
           _,(model,ss) = solve_compact(pb, return_model=true, max_acceptance=true)
           labels = value.(model[:x]) .> 0
           labels_path = joinpath(path, "labels.jld2")
           jldsave(labels_path; labels)
       end
labeling_f (generic function with 1 method)

julia> # perturbation function

julia> function perturbation_f(pb::MCF)
           generate_example(pb, nK=nk(pb)+rand([-1,0,1]))
       end
perturbation_f (generic function with 1 method)

julia> make_dataset(pb, 5, "small_dataset", 
                    overwrite=true,
                    perturbation_f=perturbation_f,
                    labeling_f=labeling_f,
                    show_progress=false
                   )

```

Now load the instances. By default `load_dataset` ensures that the graph features are batchable.
```jldoctest loaddataset
julia> d = load_dataset("small_dataset")
5-element Vector{AugmentedGNNGraph}:
 AugmentedGNNGraph(GNNGraph(7, 14) with mask: 7-element, (e: 3×14, demand_amounts_mask: 14-element, mask: 14-element, demand_to_source_mask: 14-element, target_to_demand_mask: 14-element), (edge_stacked_idx: 32×1, targets: 8×4×1, K: 0-dimensional, demand_stacked_idx: 32×1, target_mask: 8×4×1, E: 0-dimensional) data)
 AugmentedGNNGraph(GNNGraph(6, 12) with mask: 6-element, (e: 3×12, demand_amounts_mask: 12-element, mask: 12-element, demand_to_source_mask: 12-element, target_to_demand_mask: 12-element), (edge_stacked_idx: 32×1, targets: 8×4×1, K: 0-dimensional, demand_stacked_idx: 32×1, target_mask: 8×4×1, E: 0-dimensional) data)
 AugmentedGNNGraph(GNNGraph(6, 12) with mask: 6-element, (e: 3×12, demand_amounts_mask: 12-element, mask: 12-element, demand_to_source_mask: 12-element, target_to_demand_mask: 12-element), (edge_stacked_idx: 32×1, targets: 8×4×1, K: 0-dimensional, demand_stacked_idx: 32×1, target_mask: 8×4×1, E: 0-dimensional) data)
 AugmentedGNNGraph(GNNGraph(6, 12) with mask: 6-element, (e: 3×12, demand_amounts_mask: 12-element, mask: 12-element, demand_to_source_mask: 12-element, target_to_demand_mask: 12-element), (edge_stacked_idx: 32×1, targets: 8×4×1, K: 0-dimensional, demand_stacked_idx: 32×1, target_mask: 8×4×1, E: 0-dimensional) data)
 AugmentedGNNGraph(GNNGraph(8, 16) with mask: 8-element, (e: 3×16, demand_amounts_mask: 16-element, mask: 16-element, demand_to_source_mask: 16-element, target_to_demand_mask: 16-element), (edge_stacked_idx: 32×1, targets: 8×4×1, K: 0-dimensional, demand_stacked_idx: 32×1, target_mask: 8×4×1, E: 0-dimensional) data)

julia> batch(d)
GNNGraph:
  num_nodes: 33
  num_edges: 66
  num_graphs: 5
  ndata:
	mask = 33-element Vector{Bool}
  edata:
	e = 3×66 Matrix{Float32}
	demand_amounts_mask = 66-element BitVector
	mask = 66-element Vector{Bool}
	demand_to_source_mask = 66-element Vector{Bool}
	target_to_demand_mask = 66-element Vector{Bool}
  gdata:
	edge_stacked_idx = 32×5 Matrix{Int64}
	targets = 8×4×5 Array{Bool, 3}
	K = 5-element Vector{Int64}
	demand_stacked_idx = 32×5 Matrix{Int64}
	target_mask = 8×4×5 Array{Bool, 3}
	E = 5-element Vector{Int64}

```
"""
function load_dataset(dataset_dir::String; 
                      scale::Bool=true, 
                      batchable::Bool=true, 
                      edge_dir::Symbol=:double,
                      feature_type::DataType=Float32,
                      show_progress::Bool=false,
                      transform_f::Union{Nothing,Function}=nothing,
                      max_n::Union{Nothing,Int64}=nothing
    )
    graphs = AugmentedGNNGraph[]
    bar = readdir(dataset_dir, join=true)
    if !isnothing(max_n)
        if length(bar) > max_n
            bar = bar[1:max_n]
        end
    end

    if show_progress
        bar = ProgressBar(bar)
        set_description(bar, "Loading data $(dataset_dir)")
    end 
    for f in bar
        g = load_instance(f, scale=scale, feature_type=feature_type)
        if !isnothing(transform_f)
            g = transform_f(g)
        end
        push!(graphs, g)
    end
    if batchable
        graphs = make_batchable(graphs)
    end
    return graphs
end


"""
    load_instance(path::String; scale::Bool=true, feature_type::DataType=Float32)

Load single instance and return an [`AugmentedGNNGraph`](@ref) object.

# Example
```jldoctest; setup = :(using Graphs, Random; Random.seed!(123); pb = MCF(grid((2,2)), rand(4), rand(4), [Demand(1,4,1.), Demand(1,4,1.), Demand(3,2,1.)]); MultiFlows.save(pb, "test_instance"))
julia> g = load_instance("test_instance")
AugmentedGNNGraph(GNNGraph(7, 14) with mask: 7-element, (e: 3×14, demand_amounts_mask: 14-element, mask: 14-element, demand_to_source_mask: 14-element, target_to_demand_mask: 14-element), (edge_stacked_idx: 24×1, K: 0-dimensional, demand_stacked_idx: 24×1, E: 0-dimensional) data)

```
"""
function load_instance(path::String; scale::Bool=true, feature_type::DataType=Float32)
    inst = MultiFlows.load(path)
    # scale cost and capacities
    if scale
        inst = MultiFlows.scale(inst)
    end
    # check if a solution file exists
    labels_file_path = joinpath(path, "labels.jld2")
    if isfile(labels_file_path)
        y = JLD2.load(labels_file_path, "labels")
        g = to_gnngraph(inst, y, feature_type=feature_type)
    else
        g = to_gnngraph(inst, feature_type=feature_type)
    end
    # TODO: adding stacked indexes here slows things down for some reason ?
    g = add_stacked_index(g)
    return AugmentedGNNGraph(g)
end


"""
    Flux.batch(gs::AbstractVector{AugmentedGNNGraph}

Specialization of the `batch` function for [`AugmentedGNNGraph`](@ref) objects. Items in `gs` should have been made batchable by calling the [`make_batchable`](@ref) function beforehand. After concatenating the features of each graph the `edge_stacked_idx, demand_stacked_idx` values are increased by `cumsum(g.K)[i-1], cumsum(g.E)[i-1]` respectively. This ensures that each pair `ei,di` in `zip(edge_stacked_idx, demand_stacked_idx)` correspond to a edge-demand pair ``(a,k)`` where ``a`` and ``k`` belong to the same instance. 

# Example
```jldoctest; setup = :(using Graphs, JuMP, GraphNeuralNetworks; pb1 = MCF(grid((2,2)), rand(4), rand(4), [Demand(1,4,1.), Demand(1,4,1.), Demand(3,2,1.)]); (_,(mod1,_)) = solve_compact(pb1, max_acceptance=true, return_model=true);y1 = value.(mod1[:x]) .> 0 ; gnn1 = AugmentedGNNGraph(to_gnngraph(pb1, y1)); pb2 = MCF(grid((2,3)), rand(7), rand(7), [Demand(1,4,1.), Demand(1,4,1.), Demand(3,2,1.)]); (_,(mod2,_)) = solve_compact(pb2, max_acceptance=true, return_model=true); y2 = value.(mod2[:x]) .> 0 ; gnn2 = AugmentedGNNGraph(to_gnngraph(pb2, y2)))
julia> gl = make_batchable([gnn1, gnn2]);

julia> g = batch(gl)
GNNGraph:
  num_nodes: 16
  num_edges: 34
  num_graphs: 2
  ndata:
	mask = 16-element Vector{Bool}
  edata:
	e = 3×34 Matrix{Float64}
	demand_amounts_mask = 34-element BitVector
	mask = 34-element Vector{Bool}
	demand_to_source_mask = 34-element Vector{Bool}
	target_to_demand_mask = 34-element Vector{Bool}
  gdata:
	edge_stacked_idx = 42×2 Matrix{Int64}
	targets = 14×3×2 Array{Bool, 3}
	K = 2-element Vector{Int64}
	demand_stacked_idx = 42×2 Matrix{Int64}
	target_mask = 14×3×2 Array{Bool, 3}
	E = 2-element Vector{Int64}

julia> g.E, g.K
([8, 14], [3, 3])

julia> minimum(g.edge_stacked_idx[:,1]), maximum(g.edge_stacked_idx[:,1])
(0, 8)

julia> minimum(g.demand_stacked_idx[:,1]), maximum(g.demand_stacked_idx[:,1])
(0, 3)

julia> minimum(g.edge_stacked_idx[:,2]), maximum(g.edge_stacked_idx[:,2])
(9, 22)

julia> minimum(g.demand_stacked_idx[:,2]), maximum(g.demand_stacked_idx[:,2])
(4, 6)
```
"""
function Flux.batch(gs::AbstractVector{AugmentedGNNGraph})
    v_num_nodes = [ag.g.num_nodes for ag in gs]
    edge_indices = [edge_index(ag.g) for ag in gs]
    nodesum = cumsum([0; v_num_nodes])[1:(end - 1)]
    s = GraphNeuralNetworks.GNNGraphs.cat_features([ei[1] .+ nodesum[ii] for (ii, ei) in enumerate(edge_indices)])
    t = GraphNeuralNetworks.GNNGraphs.cat_features([ei[2] .+ nodesum[ii] for (ii, ei) in enumerate(edge_indices)])
    w = GraphNeuralNetworks.GNNGraphs.cat_features([get_edge_weight(ag.g) for ag in gs])
    graph = (s, t, w)

    function materialize_graph_indicator(ag)
        ag.g.graph_indicator === nothing ? ones_like(s, ag.g.num_nodes) : ag.g.graph_indicator
    end

    v_gi = materialize_graph_indicator.(gs)
    v_num_graphs = [ag.g.num_graphs for ag in gs]
    graphsum = cumsum([0; v_num_graphs])[1:(end - 1)]
    v_gi = [ng .+ gi for (ng, gi) in zip(graphsum, v_gi)]
    graph_indicator = GraphNeuralNetworks.GNNGraphs.cat_features(v_gi)

    g = GNNGraph(graph,
                 sum(v_num_nodes),
                 sum([ag.g.num_edges for ag in gs]),
                 sum(v_num_graphs),
                 graph_indicator,
                 GraphNeuralNetworks.GNNGraphs.cat_features([ag.g.ndata for ag in gs]),
                 GraphNeuralNetworks.GNNGraphs.cat_features([ag.g.edata for ag in gs]),
                 GraphNeuralNetworks.GNNGraphs.cat_features([ag.g.gdata for ag in gs])
                )
    if haskey(g.gdata, :demand_stacked_idx)
        if g.num_graphs > 1
            cumK, cumE = cumsum(g.K), cumsum(g.E)
            for i in 2:g.num_graphs
                g.demand_stacked_idx[g.demand_stacked_idx[:,i] .> 0, i] .+= cumK[i-1] #sum(g.K[1:i-1])
                g.edge_stacked_idx[g.edge_stacked_idx[:,i] .> 0, i] .+= cumE[i-1] #sum(g.E[1:i-1])
            end
        end
    end
    return g
end

"""
    MCF

Multi-Commodity Flow problem data container. The default expects `graph` to be a [`FeatureDiGraph`](@ref) object with 2-dimension edge features `[cost, capacity]`. `demands` must be a list of [`Demand`](@ref) objects.

# Examples
```jldoctest
julia> g = FeatureDiGraph([1,2,3,1], [2,3,1,3], ones(4,2))
FeatureDiGraph{Int64, Vector{Float64}}([1, 2, 3, 1], [2, 3, 1, 3], [[1.0, 1.0], [1.0, 1.0], [1.0, 1.0], [1.0, 1.0]])

julia> MCF(g, [Demand(1, 2, 1.0)])
MCF(nv = 3, ne = 4, nk = 1)
	Demand{Int64, Float64}(1, 2, 1.0)
```
"""
struct MCF{T<:Number, N<:Number}
    graph::FeatureDiGraph{T, Vector{N}}
    demands::Vector{Demand{T, N}}
end

"""
    MCF(g::AbstractGraph{T}, cost::AbstractVector{N}, capacity::AbstractVector{N}, demands::Vector{Demand{T,N})

Create a `MCF` object from an `AbstractGraph` object, a cost and capacity vector with length `ne(g)` and a set of demands.

# Examples
```jldoctest mcf
julia> using Graphs

julia> gr = grid((3,2));

julia> MCF(gr, ones(ne(gr)), ones(ne(gr)), [Demand(1,6,1.0)])
MCF(nv = 6, ne = 14, nk = 1)
	Demand{Int64, Float64}(1, 6, 1.0)
```

`cost, capacity` vectors must have same length as `ne(gr)` : 
"""
function MCF(g::AbstractGraph{T}, cost::AbstractVector{N}, capacity::AbstractVector{N}, demands::Vector{Demand{T,N}}) where {T<:Number, N<:Number}
    #if (ne(g) != length(cost)) || (ne(g) != length(capacity))
    #    throw(DimensionMismatch("Expect ne(g) == length(cost) == length(capacity), got $((ne(g), length(cost), length(capacity)))"))
    #end
    fg = FeatureDiGraph(g, hcat(cost, capacity))
    MCF(fg, demands)
end

"""
    nv(pb::MCF)

Number of vertices.

# Examples
```jldoctest; setup = :(using Graphs; pb = MCF(grid((3,2)), ones(7), ones(7), [Demand(1,6,1.0)]))
julia> nv(pb)
6
```
"""
Graphs.nv(pb::MCF) = nv(pb.graph)

"""
    ne(pb::MCF)

Number of edges in the MCF network.

# Examples
```jldoctest; setup = :(using Graphs; pb = MCF(grid((3,2)), ones(7), ones(7), [Demand(1,6,1.0)]))
julia> ne(pb)
14
```
"""
Graphs.ne(pb::MCF) = ne(pb.graph)

"""
    nk(pb::MCF)

Number of demands in the MCF instance.

# Examples
```jldoctest; setup = :(using Graphs; pb = MCF(grid((3,2)), ones(7), ones(7), [Demand(1,6,1.0)]))
julia> nk(pb)
1
```
"""
nk(pb::MCF) = size(pb.demands, 1)

"""
    Base.show(io::IO, pb::MCF)

Show MCF object.
"""
function Base.show(io::IO, pb::MCF)
    println(io, "MCF(nv = $(nv(pb)), ne = $(ne(pb)), nk = $(nk(pb)))")
    for k in 1:nk(pb)
        println(io, "\t$(pb.demands[k])")
    end
end


"""
    weight_matrix(pb::MCF, idx::Int64=1)

Returns a `(nv(pb), nv(pb))` matrix with elements equal to edge features corresponding to `idx`.

# Examples
```jldoctest; setup = :(using Graphs)
julia> pb = MCF(grid((3,2)), ones(7), 2*ones(7), [Demand(1,6,1.0)]);

julia> weight_matrix(pb)
6×6 SparseArrays.SparseMatrixCSC{Float64, Int64} with 14 stored entries:
  ⋅   1.0   ⋅   1.0   ⋅    ⋅
 1.0   ⋅   1.0   ⋅   1.0   ⋅
  ⋅   1.0   ⋅    ⋅    ⋅   1.0
 1.0   ⋅    ⋅    ⋅   1.0   ⋅
  ⋅   1.0   ⋅   1.0   ⋅   1.0
  ⋅    ⋅   1.0   ⋅   1.0   ⋅


```
"""
weight_matrix(pb::MCF, idx::Int64=1) = weights(pb.graph, idx)

"""
    cost_matrix(pb::MCF)

Return a sparse matrix with dimension `(nv(pb), nv(pb))` with values equal to arc costs.

# Examples
```jldoctest; setup = :(using Graphs; pb = MCF(grid((3,2)), ones(7), 2*ones(7), [Demand(1,6,1.0)]))
julia> cost_matrix(pb)
6×6 SparseArrays.SparseMatrixCSC{Float64, Int64} with 14 stored entries:
  ⋅   1.0   ⋅   1.0   ⋅    ⋅ 
 1.0   ⋅   1.0   ⋅   1.0   ⋅ 
  ⋅   1.0   ⋅    ⋅    ⋅   1.0
 1.0   ⋅    ⋅    ⋅   1.0   ⋅ 
  ⋅   1.0   ⋅   1.0   ⋅   1.0
  ⋅    ⋅   1.0   ⋅   1.0   ⋅ 

```

"""
cost_matrix(pb::MCF) = weight_matrix(pb, 1)

"""
    capacity_matrix(pb::MCF)

Return a sparse matrix with dimension `(nv(pb), nv(pb))` with values equal to arc capacity.

# Examples
```jldoctest; setup = :(using Graphs; pb = MCF(grid((3,2)), ones(7), 2*ones(7), [Demand(1,6,1.0)]))
julia> capacity_matrix(pb)
6×6 SparseArrays.SparseMatrixCSC{Float64, Int64} with 14 stored entries:
  ⋅   2.0   ⋅   2.0   ⋅    ⋅
 2.0   ⋅   2.0   ⋅   2.0   ⋅
  ⋅   2.0   ⋅    ⋅    ⋅   2.0
 2.0   ⋅    ⋅    ⋅   2.0   ⋅
  ⋅   2.0   ⋅   2.0   ⋅   2.0
  ⋅    ⋅   2.0   ⋅   2.0   ⋅

```

"""
capacity_matrix(pb::MCF) = weight_matrix(pb, 2)

"""
    scale_demands(pb::MCF, factor)

Scale the amount of the demands by `factor`. Returns new list of demands.

# Example
```jldoctest; setup = :(using Graphs; pb = MCF(grid((3,2)), ones(7), 2*ones(7), [Demand(1,6,1.0)]))
julia> dems = scale_demands(pb, 2)
1-element Vector{Demand{Int64, Float64}}:
 Demand{Int64, Float64}(1, 6, 2.0)

```
"""
function scale_demands(pb::MCF, factor)
    return [Demand(d.src, d.dst, factor*d.amount) for d in pb.demands]
end

"""
    scale(pb::MCF, cost_factor=1.0, capacity_factor=1.0)

Return a new MCF instance with costs scaled by a `cost_factor`, capacity and demand amounts scaled by `capacity_factor`.

# Example
```jldoctest; setup = :(using Graphs; pb = MCF(grid((3,2)), ones(7), 2*ones(7), [Demand(1,6,1.0)]))
julia> pb1 = scale(pb, 1.5, 3)
MCF(nv = 6, ne = 14, nk = 1)
	Demand{Int64, Float64}(1, 6, 3.0)

julia> cost_matrix(pb1)
6×6 SparseArrays.SparseMatrixCSC{Float64, Int64} with 14 stored entries:
  ⋅   1.5   ⋅   1.5   ⋅    ⋅
 1.5   ⋅   1.5   ⋅   1.5   ⋅
  ⋅   1.5   ⋅    ⋅    ⋅   1.5
 1.5   ⋅    ⋅    ⋅   1.5   ⋅
  ⋅   1.5   ⋅   1.5   ⋅   1.5
  ⋅    ⋅   1.5   ⋅   1.5   ⋅


julia> capacity_matrix(pb1)
6×6 SparseArrays.SparseMatrixCSC{Float64, Int64} with 14 stored entries:
  ⋅   6.0   ⋅   6.0   ⋅    ⋅
 6.0   ⋅   6.0   ⋅   6.0   ⋅
  ⋅   6.0   ⋅    ⋅    ⋅   6.0
 6.0   ⋅    ⋅    ⋅   6.0   ⋅
  ⋅   6.0   ⋅   6.0   ⋅   6.0
  ⋅    ⋅   6.0   ⋅   6.0   ⋅

```
"""
function scale(pb::MCF{T,N}, cost_factor=1.0, capacity_factor=1.0) where {T,N}
    return MCF(
               scale_features(pb.graph, N.([cost_factor, capacity_factor])),
               scale_demands(pb, capacity_factor)
              )
end

"""
    normalize(pb::MCF)

Normalize MCF instance. Costs are scaled by `1 / max(pb.cost)`, capacity and demand amount are scaled by `1 / max(max(pb.capacity), max(pb.amount))`.

# Example
```jldoctest; setup = :(using Graphs)
julia> pb = MCF(grid((3,2)), collect(1.0:7.0), collect(0.0:2:13.0), [Demand(1,6,10.0)])
MCF(nv = 6, ne = 14, nk = 1)
	Demand{Int64, Float64}(1, 6, 10.0)

julia> pbn = normalize(pb)
MCF(nv = 6, ne = 14, nk = 1)
	Demand{Int64, Float64}(1, 6, 0.8333333333333333)

julia> cost_matrix(pbn)
6×6 SparseArrays.SparseMatrixCSC{Float64, Int64} with 14 stored entries:
  ⋅        0.142857   ⋅        0.285714   ⋅         ⋅ 
 0.142857   ⋅        0.428571   ⋅        0.571429   ⋅ 
  ⋅        0.428571   ⋅         ⋅         ⋅        0.714286
 0.285714   ⋅         ⋅         ⋅        0.857143   ⋅ 
  ⋅        0.571429   ⋅        0.857143   ⋅        1.0
  ⋅         ⋅        0.714286   ⋅        1.0        ⋅ 

julia> capacity_matrix(pbn)
6×6 SparseArrays.SparseMatrixCSC{Float64, Int64} with 14 stored entries:
  ⋅        0.0        ⋅        0.166667   ⋅         ⋅ 
 0.0        ⋅        0.333333   ⋅        0.5        ⋅ 
  ⋅        0.333333   ⋅         ⋅         ⋅        0.666667
 0.166667   ⋅         ⋅         ⋅        0.833333   ⋅ 
  ⋅        0.5        ⋅        0.833333   ⋅        1.0
  ⋅         ⋅        0.666667   ⋅        1.0        ⋅ 

```
"""
function normalize(pb::MCF)
    return scale(pb, 1.0/maximum(cost_matrix(pb)), 1.0/max(maximum(capacity_matrix(pb)), maximum([d.amount for d in pb.demands])))
end

"""
    has_demand(pb::MCF{T,N}, s::T, d::T)

Check if problem has a demand originating at vertex `s` and with destination `d`.

# Example
```jldoctest; setup = :(using Graphs)
julia> pb = MCF(grid((3,2)), ones(7), ones(7), [Demand(1,2,1.)]);

julia> has_demand(pb, 1, 2)
true

julia> has_demand(pb, 2, 1)
false
```
"""
function has_demand(pb::MCF{T,N}, s::T, t::T) where {T,N}
    for d in pb.demands
        if d.src == s && d.dst == t
            return true
        end
    end
    return false
end

"""
    costs(pb::MCF)

Return edge costs in a Vector.

# Example
```jldoctest; setup = :(using Graphs)
julia> x, y = rand(14), rand(14);

julia> pb = MCF(grid((3,2)), x, y, [Demand(1,2,1.)]);

julia> costs(pb) == x
true
```
"""
function costs(pb::MCF)
    return edge_features(pb.graph, 1)
end

"""
    capacities(pb::MCF)

Return edge capacities in a Vector.

# Example
```jldoctest; setup = :(using Graphs)
julia> x, y = rand(14), rand(14);

julia> pb = MCF(grid((3,2)), x, y, [Demand(1,2,1.)]);

julia> capacities(pb) == y
true
```

"""
function capacities(pb::MCF)
    return edge_features(pb.graph, 2)
end

"""
    demands(pb::MCF{T,N}, s::T, t::T)

Get demands with origin and destination `s,t`.

# Example
```jldoctest; setup = :(using Graphs; pb = MCF(grid((3,2)), ones(14), ones(14), [Demand(1,2,1.)]))
julia> demands(pb, 1, 2)
1-element Vector{Demand{Int64, Float64}}:
 Demand{Int64, Float64}(1, 2, 1.0)

julia> demands(pb, 2, 1)
Demand{Int64, Float64}[]

```

"""
function demands(pb::MCF{T,N}, s::T, t::T) where {T,N}
    return [d for d in pb.demands if d.src==s && d.dst==t]
end

"""
    add_demand!(pb::MCF{T,N}, s::T, t::T, a::N) where {T,N}
    add_demand!(pb::MCF{T,N}, demand::Demand{N}) where {T,N}


Add a demand to the problem.

# Example
```jldoctest; setup = :(using Graphs)
julia> pb = MCF(grid((3,2)), ones(7), ones(7), Demand{Int64,Float64}[])
MCF(nv = 6, ne = 14, nk = 0)

julia> add_demand!(pb, 1, 2, 1.0)
1-element Vector{Demand{Int64, Float64}}:
 Demand{Int64, Float64}(1, 2, 1.0)

julia> add_demand!(pb, Demand(4, 2, 1.0))
2-element Vector{Demand{Int64, Float64}}:
 Demand{Int64, Float64}(1, 2, 1.0)
 Demand{Int64, Float64}(4, 2, 1.0)

julia> pb
MCF(nv = 6, ne = 14, nk = 2)
	Demand{Int64, Float64}(1, 2, 1.0)
	Demand{Int64, Float64}(4, 2, 1.0)

```
"""
function add_demand!(pb::MCF{T,N}, demand::Demand{T,N}) where {T,N}
    push!(pb.demands, demand)
end

function add_demand!(pb::MCF{T,N}, s::T, t::T, a::N) where {T,N}
    push!(pb.demands, Demand(s,t,a))
end

"""
    demand_amounts(pb::MCF)

Return a vector of the demand amounts.

# Example
```jldoctest; setup = :(using Graphs)
julia> pb = MCF(grid((3,2)), ones(7), ones(7), [Demand(1,2,1.), Demand(1,3,.5)]);

julia> demand_amounts(pb)
2-element Vector{Float64}:
 1.0
 0.5
```


"""
function demand_amounts(pb::MCF)
    return [d.amount for d in pb.demands]
end

"""
    demand_endpoints(pb::MCF)

Return vector of source and destination nodes for each demand.

# Example
```jldoctest; setup = :(using Graphs)
julia> pb = MCF(grid((3,2)), ones(7), ones(7), [Demand(1,2,1.), Demand(1,3,.5)]);

julia> demand_endpoints(pb)
([1, 1], [2, 3])

```
"""
function demand_endpoints(pb::MCF{T,N}) where {T,N}
    s, t = T[], T[]
    for d in pb.demands
        push!(s, d.src)
        push!(t, d.dst)
    end
    return s, t
end

"""
    aggregate_demands(pb::MCF)

Create new instance with aggregated demands : if demands ``k_1, k_2`` are such that ``s_{k_1} = s_{k_2}`` and ``t_{k_1} = t_{k_2}`` they are removed from the problem and a new demand ``k'`` with ``b_{k'} = b_{k_1} + b_{k_2}`` and same endpoints is added.

# Example
```jldoctest; setup = :(using Graphs)
julia> pb = MCF(grid((3,2)), ones(7), ones(7), [Demand(1,3,1.), Demand(1,3,1.)])
MCF(nv = 6, ne = 14, nk = 2)
	Demand{Int64, Float64}(1, 3, 1.0)
	Demand{Int64, Float64}(1, 3, 1.0)

julia> aggregate_demands(pb)
MCF(nv = 6, ne = 14, nk = 1)
	Demand{Int64, Float64}(1, 3, 2.0)

```
"""
function aggregate_demands(pb::MCF{T,N}) where {T,N}
    amounts = Dict{Tuple{T,T},N}()
    for d in pb.demands
        if (d.src,d.dst) in keys(amounts)
            amounts[d.src,d.dst] += d.amount
        else
            amounts[d.src,d.dst] = d.amount
        end
    end
    return MCF(pb.graph, [Demand(v.first[1], v.first[2], v.second) for v in amounts])
end

"""
    get_path(pb::MCF{T,N}, s::T, t::T; 
             alg::Function=(s,t)->enumerate_paths(dijkstra_shortest_paths(pb.graph, s), t)
            ) where {T,N}


Get path from `s` to `t` for MCF problem `pb`.

# Example
```jldoctest; setup = :(using Graphs; pb = MCF(grid((3,2)), ones(7), ones(7), [Demand(1,3,1.), Demand(1,3,1.)]))
julia> get_path(pb, 1, 6)
VertexPath{Int64}([1, 2, 5, 6])

```
"""
function get_path(pb::MCF{T,N}, s::T, t::T; 
        alg::Function=(s,t)->enumerate_paths(dijkstra_shortest_paths(pb.graph, s, cost_matrix(pb)), t)
    ) where {T,N}
    return VertexPath(alg(s,t))
end

"""
    Base.:(==)(p1::MCF{T,N}, p2::MCF{T,N}) where {T,N} 

Check path equality of two [`MCF`](@ref) instances.
"""
function Base.:(==)(p1::MCF{T,N}, p2::MCF{T,N}) where {T,N} 
    return [costs(p1), capacities(p1), demand_endpoints(p1), demand_amounts(p1)] == [costs(p2), capacities(p2), demand_endpoints(p2), demand_amounts(p2)]
end


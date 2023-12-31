module MultiFlows

import Graphs: AbstractGraph, nv, ne, edges
using GraphPlot
using Compose
using Measures

import Cairo, Fontconfig

export 
    AbstractDemand,
    AbstractMultiFlow,
    Demand,
    MultiFlow,
    nk,
    # plotting
    plot,
    # paths
    AbstractPath,
    Path,
    weight,
    edges,
    # graph utilities
    arc_index_matrix

nv(mf::AbstractMultiFlow) = nv(mf.graph)
ne(mf::AbstractMultiFlow) = ne(mf.graph)

include("interface.jl")
include("plotting.jl")
include("paths.jl")
include("graph_utils.jl")

end # module MultiFlows

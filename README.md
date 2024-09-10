# GraphFeatures

```julia
using Pkg
Pkg.add(PackageSpec(url="https://github.com/sebkaz/GraphFeatures.jl"))
```
Karate Example

```julia
using Graph
using GraphFeatures
g = Graphs.SimpleGraphs.smallgraph(:karate)
comm = [0,0,0,0,1,1,1,0,2,2,1,0,0,0,2,2,1,0,2,0,2,0,2,3,3,3,2,3,3,2,2,3,2,2]

df = compute_features(g, comm)

```

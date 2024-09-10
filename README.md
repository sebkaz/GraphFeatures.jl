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
comm = [1,1,1,1,2,2,2,1,3,3,2,1,1,1,3,3,2,1,3,1,3,1,3,4,4,4,3,4,4,3,3,4,3,3]

df = compute_features(g, comm)

```

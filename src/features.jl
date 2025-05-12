function participation_coeff(g::SimpleGraph, ind::Int, comm::AbstractVector{Int})
    degv = degree(g, ind)
    return sum((degvi / degv)^2 for degvi in values(countmap(comm[neighbors(g, ind)])))
end

function in_mod_deg_vec(g::SimpleGraph, comm::AbstractVector{Int})
    ekv = [count(nei -> comm[nei] == comm[ind], neighbors(g, ind)) for ind in 1:nv(g)]
    tmp_df = DataFrame(; ekv, comm)
    tmp_df.id = 1:nv(g)
    transform!(groupby(tmp_df, :comm), :ekv .=> (x -> (x .- mean(x)) ./ std(x)) => :in_mod_deg)
    @assert tmp_df.id == 1:nv(g)
    return tmp_df.in_mod_deg
end

function beta_star(g::SimpleGraph, ind::Int, comm::AbstractVector{Int})
    ek = count(nei -> comm[nei] == comm[ind], neighbors(g, ind))
    degak = degree(g, ind)
    volAi = sum(degree(g)[comm .== comm[ind]])
    volV = sum(degree(g))
    return ek/degak - (volAi-degak)/volV
end

function edge_contr(g::SimpleGraph, ind::Int, comm::AbstractVector{Int})
    ek = count(nei -> comm[nei] == comm[ind], neighbors(g, ind))
    degak = degree(g, ind)
    return ek/degak
end

function cada(g::SimpleGraph, ind::Int, comm::AbstractVector{Int})
    neigh = neighbors(g, ind)
    if isempty(neigh)
        return 0.0  # lub coś bardziej sensownego dla Twojej logiki
    end
    ek = maximum(values(countmap(comm[neigh])))
    degak = degree(g, ind)
    return degak / ek
end

function q_dist(clusters)
    if isempty(clusters)
        return Float64[]  # lub np. fill(0.0, 0)
    end
    cs = sort!(unique(clusters))
    @assert cs[1] == 1
    @assert cs[end] == length(cs)

    cs .= 0
    for c in clusters
        cs[c] += 1
    end

    return cs / sum(cs)
end

# note that we work with degreess so p < eps() should be the same as p == 0
log_diff((p, q),) = p < eps() ? 0.0 : p * log(p / q)

kl(p, q) = (@assert length(p) == length(q); sum(log_diff, zip(p, q)))

l1(p, q) = (@assert length(p) == length(q); sum(x -> abs(x[1] - x[2]), zip(p, q)))

l2(p, q) = (@assert length(p) == length(q); sqrt(sum(x -> (x[1] - x[2])^2, zip(p, q))))

hd(p, q) = (@assert length(p) == length(q); sqrt(sum(x -> (sqrt(x[1]) - sqrt(x[2]))^2, zip(p, q))) / sqrt(2))

function distances_gr(g::SimpleGraph, ind::Int, comm::AbstractVector{Int}, q::Vector{Float64})
    p = zeros(Float64, length(q))
    for nei in neighbors(g, ind)
        p[comm[nei]] += 1.0
    end
    p ./= sum(p)
    return (kl=kl(p, q), l1=l1(p, q), l2=l2(p, q), hd=hd(p, q))
end

function distances2_gr(g::SimpleGraph, ind::Int, comm::AbstractVector{Int}, q::Vector{Float64})
    p = zeros(Float64, length(q))
    for nei in Iterators.flatten(neighbors(g, x) for x in neighbors(g, ind))
        p[comm[nei]] += 1.0
    end
    p ./= sum(p)
    return (kl2=kl(p, q), l12=l1(p, q), l22=l2(p, q), hd2=hd(p, q))
end

function avg_neighbor_degree(g::SimpleGraph, ind::Int)
    neigh = neighbors(g, ind)
    return isempty(neigh) ? 0.0 : mean(x -> degree(g, x), neigh)
end
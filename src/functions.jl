function compute_features(g::SimpleGraph, clusters_g::AbstractVector{Int})
    n = nv(g)
    df = DataFrame(node_id=1:n)

    # cechy z compute_node_features
    features = [compute_node_features(g, i, clusters_g) for i in 1:n]
    df.participation = [f.participation for f in features]
    df.beta_star = [f.beta_star for f in features]
    df.edge_contr = [f.edge_contr for f in features]
    df.cada = [f.cada for f in features]

    # cechy związane z dystrybucją klas
    q_clusters_g = q_dist(clusters_g)
    g_distances = [distances_gr(g, i, clusters_g, q_clusters_g) for i in 1:n]
    df.kl = getproperty.(g_distances, :kl)
    df.l1 = getproperty.(g_distances, :l1)
    df.l2 = getproperty.(g_distances, :l2)
    df.hd = getproperty.(g_distances, :hd)

    g_distances2 = [distances2_gr(g, i, clusters_g, q_clusters_g) for i in 1:n]
    df.kl2 = getproperty.(g_distances2, :kl2)
    df.l12 = getproperty.(g_distances2, :l12)
    df.l22 = getproperty.(g_distances2, :l22)
    df.hd2 = getproperty.(g_distances2, :hd2)

    # cechy z Graphs.jl
    df.lcc = local_clustering_coefficient(g, 1:n)
    df.bc = betweenness_centrality(g)
    df.dc = degree(g)
    df.ndc = [avg_neighbor_degree(g, i) for i in 1:n]
    df.cc = closeness_centrality(g)
    df.ec = eigenvector_centrality(g)
    df.eccen = eccentricity(g)
    df.core = core_number(g)

    return df
end

function compute_node_features(g, i, clusters_g)
    return (
        participation = participation_coeff(g, i, clusters_g),
        beta_star = beta_star(g, i, clusters_g),
        edge_contr = edge_contr(g, i, clusters_g),
        cada = cada(g, i, clusters_g)
    )
end
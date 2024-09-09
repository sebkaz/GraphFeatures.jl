function compute_features(g::SimpleGraph, clusters_g::AbstractVector{Int})
    n = nv(g)
    df = DataFrame(node_id=1:n)
    df.participation = [participation_coeff(g, i, clusters_g) for i in 1:n]
    df.in_mod_deg = in_mod_deg_vec(g, clusters_g)
    df.beta_star = [beta_star(g, i, clusters_g) for i in 1:n]
    df.edge_contr = [edge_contr(g, i, clusters_g) for i in 1:n]
    df.cada = [cada(g, i, clusters_g) for i in 1:n]

    q_clusters_g = q_dist(clusters_g)
    g_distances = [distances_gr(g, i, clusters_g, q_clusters_g) for i in 1:nv(g)]
    df.kl = getproperty.(g_distances, :kl)
    df.l1 = getproperty.(g_distances, :l1)
    df.l2 = getproperty.(g_distances, :l2)
    df.hd = getproperty.(g_distances, :hd)
    g_distances2 = [distances2_gr(g, i, clusters_g, q_clusters_g) for i in 1:nv(g)]
    df.kl2 = getproperty.(g_distances2, :kl2)
    df.l12 = getproperty.(g_distances2, :l12)
    df.l22 = getproperty.(g_distances2, :l22)
    df.hd2 = getproperty.(g_distances2, :hd2)
    df.lcc = local_clustering_coefficient(g, 1:nv(g))
    df.bc = betweenness_centrality(g)
    df.dc = degree(g)
    df.ndc = [avg_neighbor_degree(g, i) for i in 1:n]
    df.cc = closeness_centrality(g)
    df.ec = eigenvector_centrality(g)
    df.eccen = eccentricity(g)
    df.core = core_number(g)
    return df
end
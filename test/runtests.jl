using GraphFeatures
using Test
using Graphs



g = path_graph(6)
comm = [1,1,2,2,1,2]



@testset "GraphFeatures.jl" begin
    @test size(GraphFeatures.compute_features(g,comm)) == (6,21)
end

@testset "Test obliczania cech grafu" begin
    g = SimpleGraph(4)
    add_edge!(g, 1, 2)
    add_edge!(g, 2, 3)
    add_edge!(g, 3, 4)
    clusters_g = [1, 1, 2, 2]  # Przykładowe grupy

    df = compute_features(g, clusters_g)

    @test size(df) == (4, 21)  
    @test all(names(df) .!= "")  # Sprawdzamy, czy kolumny nie są puste
end

@testset "Features" begin
    @test GraphFeatures.participation_coeff(g,1,comm) == 1.0
    @test GraphFeatures.participation_coeff(g,2,comm) == 0.5
end
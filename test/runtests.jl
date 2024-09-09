using GraphFeatures
using Test
using Graphs



g = path_graph(6)
comm = [1,1,2,2,1,2]


@testset "GraphFeatures.jl" begin
    @test size(GraphFeatures.compute_features(g,comm)) == (6,22)
end

# @testset "Features" begin
#     @test GraphFeatures.participation_coeff(g,1,comm) == 1.0
#     @test GraphFeatures.participation_coeff(g,2,comm) == 0.5
# end
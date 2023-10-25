using GraphFeatures
using Test

@testset "GraphFeatures.jl" begin
    @test GraphFeatures.greet_your_package_name() == "Hello, GraphFeatures.jl!"
    @test GraphFeatures.greet_your_package_name() != "Hello, World!"
end

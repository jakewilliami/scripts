using CommonAppVersions
using Test

@testset "CommonAppVersions.jl" begin
    @test get_latest_version(Firefox) == "97.0"
end

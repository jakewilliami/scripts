using CommonAppVersions
using Test

latest_version_equal(T::U, v::String) where {U <: CommonAppVersions.CommonApplication} = 
    isequal(get_latest_version(T), VersionNumber(v))

@testset "CommonAppVersions.jl" begin
    @test latest_version_equal(Firefox, "97.0")
    @test latest_version_equal(TeamViewer, "15.25.8")
end

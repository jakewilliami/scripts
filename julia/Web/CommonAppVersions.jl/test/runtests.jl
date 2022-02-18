using CommonAppVersions
using Test

latest_version_equal(T::U, v::String) where {U <: CommonAppVersions.CommonApplication} = 
    isequal(get_latest_version(T), VersionNumber(v))

@testset "CommonAppVersions.jl" begin
    @testset "Firefox" begin
        @test latest_version_equal(Firefox, "97.0.1")
    end
    
    @testset "Chrome" begin
        @test latest_version_equal(Chrome, "98.0.4758")
    end
    
    @testset "Adobe" begin
        @test latest_version_equal(TeamViewer, "15.25.8")
    end
    
    #=@testset "TeamViewer" begin
        @test latest_version_equal(Adobe, "")
    end=#
    
    @testset "Microsoft Office" begin
        @test latest_version_equal(Office365, "16.0.14729")
        @test CommonAppVersions._get_latest_build_version(Office365) == 
            VersionNumber("14827.20198.0")
    end
end

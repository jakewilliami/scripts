using CommonAppVersions
using Test

@testset "CommonAppVersions.jl" begin
    @testset "Firefox" begin
        firefox_v = get_latest_version(Firefox)
        expected_firefox_v = VersionNumber("97.0.1")
        @test firefox_v == expected_firefox_v
    end
    
    @testset "Chrome" begin
        chrome_v = get_latest_version(Chrome)
        expected_chrome_v = VersionNumber("98.0.4758")
        @test chrome_v == expected_chrome_v
    end
    
    @testset "Adobe" begin
        adobe_v = get_latest_version(Adobe)
        expected_adobe_v = VersionNumber("21.011.20039")
        @test adobe_v == expected_adobe_v
    end
    
    @testset "TeamViewer" begin
        teamviewer_v = get_latest_version(TeamViewer)
        expected_teamviewer_v = VersionNumber("15.25.8")
        @test teamviewer_v == expected_teamviewer_v
    end
    
    @testset "Microsoft Office" begin
        # Office 2007/2010 (end-of-life)
        @test get_latest_version(Office2007) == VersionNumber("12.0.6612")
        @test get_latest_version(Office2010) == VersionNumber("14.0.7261")
        
        # Office 2013
        
        # Office 2016
        
        # Office 365
        o365_v = get_latest_version(Office365)
        expected_o365_v = VersionNumber("16.0.14729")
        @test o365_v == expected_o365_v
        o365_build_v = CommonAppVersions._get_latest_build_version(Office365)
        expected_o365_build_v = VersionNumber("14827.20198.0")
        @test o365_build_v == expected_o365_build_v
    end
end

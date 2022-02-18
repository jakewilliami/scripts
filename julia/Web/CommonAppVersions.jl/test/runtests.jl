using CommonAppVersions
using Test

@testset "CommonAppVersions.jl" begin
    @testset "Firefox" begin
        firefox_v = get_latest_version(Firefox)
        expected_firefox_v = VersionNumber("97.0.1")
        @test firefox_v == expected_firefox_v
        # test that `get_latest_version` defaults to Windows
        firefox_v_win = get_latest_version(Firefox, Windows)
        @test firefox_v == firefox_v_win
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
        teamviewer_v_macos = get_latest_version(TeamViewer, MacOS)
        expected_teamviewer_v_macos = VersionNumber("15.25.5")
        @test teamviewer_v_macos == expected_teamviewer_v_macos
        @test_throws ArgumentError get_latest_version(TeamViewer, Linux)
    end
    
    @testset "Microsoft Office" begin
        # Office 2007/2010 (end-of-life)
        @test get_latest_version(Office2007) == VersionNumber("12.0.6612")
        @test get_latest_version(Office2010) == VersionNumber("14.0.7261")
        
        # Office 2013
        o2013_v = get_latest_version(Office2013)
        expected_o2013_v = VersionNumber("15.0.5423")
        @test o2013_v == expected_o2013_v
        
        # Office 2016
        # o2016_v = get_latest_version(Office2016)
        # expected_o2016_v = VersionNumber("")
        # @test o2016_v == expected_o2016_v
        o2016_retail_v = CommonAppVersions._get_latest_retail_version(Office2016, Windows)
        expected_o2016_retail_v = VersionNumber("16.0.14827")
        @test o2016_retail_v == expected_o2016_retail_v
        
        # Office 365
        o365_v = get_latest_version(Office365)
        expected_o365_v = VersionNumber("16.0.14729")
        @test o365_v == expected_o365_v
        o365_build_v = CommonAppVersions._get_latest_build_version(Office365, Windows)
        expected_o365_build_v = VersionNumber("14827.20198.0")
        @test o365_build_v == expected_o365_build_v
    end
end

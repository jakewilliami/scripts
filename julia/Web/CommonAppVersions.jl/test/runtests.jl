using CommonAppVersions
using Test
using InteractiveUtils

const EXPECTED_FIREFOX_V          = VersionNumber("97.0.1")
const EXPECTED_CHROME_V           = VersionNumber("98.0.4758")
const EXPECTED_ADOBE_V            = VersionNumber("21.011.20039")
const EXPECTED_TEAMVIEWER_V       = VersionNumber("15.25.8")
const EXPECTED_TEAMVIEWER_V_MACOS = VersionNumber("15.25.5")
const EXPECTED_O2007_V            = VersionNumber("12.0.6612")
const EXPECTED_O2010_V            = VersionNumber("14.0.7261")
const EXPECTED_O2013_V            = VersionNumber("15.0.5423")
const EXPECTED_O2016_V            = VersionNumber("16.0.5278")
const EXPECTED_O2016_RETAIL_V     = VersionNumber("16.0.14827")
const EXPECTED_O365_V             = VersionNumber("16.0.14827")
const EXPECTED_O365_BUILD_V       = VersionNumber("14827.20198.0")

@testset "CommonAppVersions.jl" begin
    @testset "Firefox" begin
        firefox_v = get_latest_version(Firefox)
        @test firefox_v == EXPECTED_FIREFOX_V
        # test that `get_latest_version` defaults to Windows
        firefox_v_win = get_latest_version(Firefox, Windows)
        @test firefox_v == firefox_v_win
    end
    
    @testset "Chrome" begin
        for OS in subtypes(CommonAppVersions.OperatingSystem)
            chrome_v = get_latest_version(Chrome, OS())
            @test chrome_v == EXPECTED_CHROME_V
        end
    end
    
    @testset "Adobe" begin
        adobe_v = get_latest_version(Adobe)
        @test adobe_v == EXPECTED_ADOBE_V
    end
    
    @testset "TeamViewer" begin
        teamviewer_v = get_latest_version(TeamViewer)
        @test teamviewer_v == EXPECTED_TEAMVIEWER_V
        teamviewer_v_macos = get_latest_version(TeamViewer, MacOS)
        @test teamviewer_v_macos == EXPECTED_TEAMVIEWER_V_MACOS
        @test_throws ArgumentError get_latest_version(TeamViewer, Linux)
    end
    
    @testset "Microsoft Office" begin
        # Office 2007/2010 (end-of-life)
        @test get_latest_version(Office2007) == EXPECTED_O2007_V
        @test get_latest_version(Office2010) == EXPECTED_O2010_V
        
        # Office 2013
        o2013_v = get_latest_version(Office2013)
        @test o2013_v == EXPECTED_O2013_V
        
        # Office 2016
        o2016_v = get_latest_version(Office2016)
        @test o2016_v == EXPECTED_O2016_V
        o2016_retail_v = CommonAppVersions._get_latest_retail_version(Office2016, Windows)
        @test o2016_retail_v == EXPECTED_O2016_RETAIL_V
        
        # Office 365
        o365_v = get_latest_version(Office365)
        @test o365_v == EXPECTED_O365_V
        o365_build_v = CommonAppVersions._get_latest_build_version(Office365, Windows)
        @test o365_build_v == EXPECTED_O365_BUILD_V
    end
end

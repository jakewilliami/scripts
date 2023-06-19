using CommonAppVersions
using Test
using InteractiveUtils
using VersionParsing

const EXPECTED_FIREFOX_V          = vparse("97.0.1")
const EXPECTED_CHROME_V           = vparse("98.0.4758.102")
const EXPECTED_ADOBE_V            = vparse("21.011.20039")
const EXPECTED_TEAMVIEWER_V       = vparse("15.25.8")
const EXPECTED_TEAMVIEWER_V_MACOS = vparse("15.25.5")
const EXPECTED_TEAMVIEWER_V_LINUX = vparse("15.42.4")
const EXPECTED_O2007_V            = vparse("12.0.6612")
const EXPECTED_O2010_V            = vparse("14.0.7261")
const EXPECTED_O2013_V            = vparse("15.0.5423.1000")
const EXPECTED_O2016_V            = vparse("16.0.5278.1000")
const EXPECTED_O2016_RETAIL_V     = vparse("16.0.14827")
const EXPECTED_O365_V             = vparse("16.0.14827.20158")
const EXPECTED_O365_V_MACOS       = vparse("16.58.22021501")
const EXPECTED_O365_BUILD_V       = vparse("14827.20198.0")
const EXPECTED_EDGE_V             = vparse("98.0.1108.56")

Base.isapprox(v1::VersionNumber, v2::VersionNumber) =
    v1.major == v2.major && v1.minor == v2.minor && v1.patch == v2.patch

@testset "CommonAppVersions.jl" begin
    @testset "Firefox" begin
        firefox_v = get_latest_version(Firefox)
        @test firefox_v ≈ EXPECTED_FIREFOX_V
        # test that `get_latest_version` defaults to Windows
        firefox_v_win = get_latest_version(Firefox, Windows)
        @test firefox_v ≈ firefox_v_win
    end

    @testset "Chrome" begin
        for OS in subtypes(CommonAppVersions.OperatingSystem)
            chrome_v = get_latest_version(Chrome, OS())
            @test chrome_v ≈ EXPECTED_CHROME_V
        end
    end

    @testset "Adobe" begin
        adobe_v = get_latest_version(Adobe)
        @test adobe_v ≈ EXPECTED_ADOBE_V
    end

    @testset "TeamViewer" begin
        teamviewer_v = get_latest_version(TeamViewer)
        @test teamviewer_v ≈ EXPECTED_TEAMVIEWER_V
        teamviewer_v_macos = get_latest_version(TeamViewer, MacOS)
        @test teamviewer_v_macos == EXPECTED_TEAMVIEWER_V_MACOS
        teamviewer_v_linux ≈ get_latest_version(TeamViewer, Linux)
        @test teamviewer_v_linux == EXPECTED_TEAMVIEWER_V_LINUX
    end

    @testset "Microsoft Office" begin
        # Office 2007/2010 (end-of-life)
        @test get_latest_version(Office2007) ≈ EXPECTED_O2007_V
        @test get_latest_version(Office2010) ≈ EXPECTED_O2010_V

        # Office 2013
        o2013_v = get_latest_version(Office2013)
        @test o2013_v ≈ EXPECTED_O2013_V

        # Office 2016
        o2016_v = get_latest_version(Office2016)
        @test o2016_v ≈ EXPECTED_O2016_V
        o2016_retail_v = CommonAppVersions._get_latest_retail_version(Office2016, Windows)
        @test o2016_retail_v ≈ EXPECTED_O2016_RETAIL_V

        # Office 365
        o365_v = get_latest_version(Office365)
        @test o365_v ≈ EXPECTED_O365_V
        o365_v_macos = get_latest_version(Office365, MacOS)
        @test o365_v_macos ≈ EXPECTED_O365_V_MACOS
        o365_build_v = CommonAppVersions._get_latest_build_version(Office365, Windows)
        @test o365_build_v ≈ EXPECTED_O365_BUILD_V
    end

    @testset "Edge" begin
        edge_v = get_latest_version(Edge)
        @test edge_v ≈ EXPECTED_EDGE_V
    end
end

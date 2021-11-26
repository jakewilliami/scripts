using Sockets, HTTP, JSON, Libz

function _request_compressed(request_type::String, URL::String)
    return HTTP.request(
        request_type, URL, [
			"Sec-Ch-Ua" => "\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"90\"",
			"Accept" => "application/json",
			"Sec-Ch-Ua-Mobile" => "?0",
			"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36",
            "Accept-Encoding" => "gzip, deflate",
			"Sec-Fetch-Site" => "same-site",
			"Sec-Fetch-Mode" => "cors",
			"Sec-Fetch-Dest" => "empty",
			"Accept-Language" => "en-GB,en-US;q=0.9,en;q=0.8",
			"Connection" => "close"
		])
end

# main method
function geolocate(IP::Sockets.IPAddr)
    r = HTTP.request("GET", string("https://freegeoip.app/json/", IP))
    return JSON.parse(String(r.body))
end
#=
geolocate(IP::Sockets.IPAddr) = 
    JSON.parse(String(read(ZlibInflateInputStream(_request_compressed("GET", string("https://freegeoip.app/json/", IP)).body))))
=#

# parse IP from string
geolocate(IP::AbstractString) = geolocate(parse(Sockets.IPAddr, IP))

# default to current public IP
function geolocate()
    r = HTTP.request("GET", "https://ipinfo.io/ip")
    return geolocate(String(r.body))
end
#=
geolocate() = 
    geolocate(String(read(ZlibInflateInputStream(_request_compressed("GET", "https://ipinfo.io/ip").body))))
=#

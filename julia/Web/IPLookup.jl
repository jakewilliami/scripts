using Gumbo, HTTP, Sockets, Libz
using AbstractTrees, Cascadia#, HttpCommon
    
function request_webpage(IP::Union{AbstractString, Sockets.IPAddr})
    base_url = "bgp.he.net"
    r = HTTP.request("GET", string("https://", base_url, "/ip/", IP),
        [
            "Host" => base_url,
            "Sec-Ch-Ua" => "\"Chromium\";v=\"91\", \" Not;A Brand\";v=\"99\"",
            "Sec-Ch-Ua-Mobile" => "?0",
            "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
            "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
            "Sec-Fetch-Site" => "none",
            "Sec-Fetch-Mode" => "navigate",
            "Sec-Fetch-User" => "?1",
            "Sec-Fetch-Dest" => "document",
            "Accept-Encoding" => "gzip, deflate",
            "Accept-Language" => "en-GB,en-US;q=0.9,en;q=0.8",
            "Connection" => "close",
        ])
    return Gumbo.parsehtml(String(r.body))
end
# request_webpage(IP::Sockets.IPAddr) = request_webpage(IP)
request_webpage() = request_webpage(String(HTTP.request("GET", "https://ipinfo.io/ip").body))


function parse_webpage(webpage::HTMLDocument)
    (main_head, main_body) = webpage.root.children
    body.children[1].children
end

parse_webpage(request_webpage())

#=
request_webpage(url::AbstractString) = HTTP.get(url).body
parse_webpage(webpage_body) = Gumbo.parsehtml(String(webpage_body))
get_webpage(url::AbstractString) = parse_webpage(request_webpage(url))
# xpath = "//div[@class=\"updateBox\"]"
# return header = findfirst(xpath, EzXML.root(EzXML.parsehtml(webpage)))
update_box = eachmatch(Selector("[class=\"updateBox\"]"), webpage.root)[1]
=#

# function ip_lookup(IP::Sockets.IPAddr)
#     r = HTTP.request("GET", )
#     document = parsehtml(String(r.body))
#     # for elem in Gumbo.PreOrderDFS(document.root)
#         # println(elem)
#     # end
#     (head, body) = document.root.children[2].children
#
#     return body
# end
# ip_lookup(IP::AbstractString) = ip_lookup(parse(Sockets.IPAddr, IP))
function ip_lookup()
    r = HTTP.request("GET", "https://ipinfo.io/ip")
    return ip_lookup(String((r.body)))
end

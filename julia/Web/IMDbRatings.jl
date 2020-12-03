using HTTP, Gumbo

url_base = "https://www.imdb.com/find?q="
url_film = "&s=tt&ttype=ft&ref_=fn_ft"

println("Please input your search string.")
search_string = readline()
search_url = "$(url_base)$(replace(search_string, " " => \"%20\"))$(url_film)"

request_webpage(url::AbstractString) = HTTP.get(url).body
parse_webpage(webpage_body) = Gumbo.parsehtml(String(webpage_body))
get_webpage(url::AbstractString) = parse_webpage(request_webpage(url))

for elem in PreOrderDFS(update_box)
    if typeof(elem) != HTMLText
		continue
    end

    tag = elem.parent

    update_box = eachmatch(Selector("[class=\"findList\"]"), webpage.root)[1]

    if typeof(tag) == HTMLElement{:p}
		return str
	end

    if typeof(tag) == HTMLElement{:h1} && "class" ∈ keys(tag.attributes)
        if tag.attributes["class"] == "chapter"
	        str = _latex_escape_string(split(elem.text, r"[0-9]+. ")[2])
            push!(scraped_text, (typeof(tag).parameters[1], str))
        end
    end

end

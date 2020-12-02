module NZISM

using HTTP, Gumbo, AbstractTrees, Cascadia#, HttpCommon
# import EzXML: root, parse # only importing to use root and pa

export request_webpage, parse_webpage, get_webpage, obtain_last_updated,
	construct_content_vector, write_to_file

const HTMLtoLaTeX = Dict{Symbol, String}(
    :h1 => "section",
    :h2 => "subsection",
	:h3 => "subsection*",
	:h4 => "subsubsection*",
	:p => "\\textbf{\\subsubsectioncounter}\\hspace*{1em}", # ⟵ THIS IS TEMPORARY
	# :a => "\\href",
	# :div => "\\textbf{\\subsubsectioncounter}\\hspace*{1em}", # ⟵ THIS IS TEMPORARY
	:b => "\\textbf",
	:strong => "\\emph",
	:img => "\\includegraphics[width=\\columnwidth]",
)

last_updated = string()

function _latex_escape_string(str::AbstractString)
	subs = Dict{AbstractString, AbstractString}(
		"&" => "\\&",
		" - " => "---",
		"_" => "\\_",
		"#" => "\\#"
	)
	str = lstrip(str) # lstrip removes leading white space
	# str = replace(str, subs...) # https://github.com/JuliaLang/julia/issues/29849#issuecomment-736425416
	str = replace(str, "&" => "\\&")
	str = replace(str, " - " => "\\emdash ")
	str = replace(str, "_" => "\\_")
	str = replace(str, "#" => "\\#")
	
	return str
end

request_webpage(url::AbstractString) = HTTP.get(url).body
parse_webpage(webpage_body) = Gumbo.parsehtml(String(webpage_body))
get_webpage(url::AbstractString) = parse_webpage(request_webpage(url))

function obtain_last_updated(webpage)
	# xpath = "//div[@class=\"updateBox\"]"
	# return header = findfirst(xpath, EzXML.root(EzXML.parsehtml(webpage)))
	update_box = eachmatch(Selector("[class=\"updateBox\"]"), webpage.root)[1]
	# return eachmatch(Selector("[class=\"updateBox\"]"), webpage.root)[1].attributes
	
	
	for elem in PreOrderDFS(update_box)
		if typeof(elem) != HTMLText
			continue
		end
		
		tag = elem.parent
		
		if typeof(tag) == HTMLElement{:p}
			str = replace(rstrip(elem.text), "." => "")
			str = replace(str, " " => ", ")
			return str
		end
	end
end

function construct_content_vector(webpage::HTMLDocument)
	TagText = Tuple{Symbol, String}
	scraped_text = Vector{TagText}()
	i = 0
	
	for elem in PreOrderDFS(webpage.root)
	    if typeof(elem) != HTMLText
			continue
		end
		
		i += 1
        tag = elem.parent
		great_tag = tag.parent
		
		# select section headers (called "chapters" in the NZISM)
        if typeof(tag) == HTMLElement{:h1} && "class" ∈ keys(tag.attributes)
            if tag.attributes["class"] == "chapter"
				str = _latex_escape_string(split(elem.text, r"[0-9]+. ")[2])
                push!(scraped_text, (typeof(tag).parameters[1], str))
            end
        end
		
		# select subsection headers (called "sections" in the NZISM)
		if typeof(tag) == HTMLElement{:h2} && "class" ∈ keys(tag.attributes)
			if tag.attributes["class"] == "section"
				str = _latex_escape_string(split(elem.text, r"[0-9]+. ")[2])
				push!(scraped_text, (typeof(tag).parameters[1], str))
			end
		end
		
		# select subsection* headers (called "sections" in the NZISM)
		if typeof(tag) == HTMLElement{:h3} && "class" ∈ keys(tag.attributes)
			if tag.attributes["class"] == "subsection"
				str = _latex_escape_string(elem.text)
				push!(scraped_text, (typeof(tag).parameters[1], str))
			end
		end
		
		# select subsubsection* headers (called "subBlock" or "blockRandC" in the NZISM)
		if typeof(tag) == HTMLElement{:h4} && "class" ∈ keys(tag.attributes)
			if tag.attributes["class"] == "subBlock" || tag.attributes["class"] == "blockRandC"
				str = _latex_escape_string(elem.text)
				push!(scraped_text, (typeof(tag).parameters[1], str))
			end
		end
		
		
		# select main content (called "NormSiCjx" (where i and j are numbers, and x may be blank or a letter) or "Normal-nonumbering" in the NZISM)
		if typeof(tag) == HTMLElement{:p}
			# probably won't need the following 8 lines of code once we get the paragraph selector working properly
			date_str = replace(rstrip(elem.text), "." => "")
			possible_date = split(date_str)
			if isequal(length(possible_date), 2)
				possible_month, possible_year = possible_date
				if possible_month ∈ ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"] && possible_year ∈ [1900:2100...]
					continue
				end
			else
				str = _latex_escape_string(elem.text)
				push!(scraped_text, (typeof(tag).parameters[1], str))
			end
		end
		
		#=
		if typeof(great_tag) == HTMLElement{:div} && "class" ∈ keys(great_tag.attributes)
            if great_tag.attributes["class"] == "blockPara" || great_tag.attributes["class"] == "blockRandC"
                str = _latex_escape_string(elem.text)
                push!(scraped_text, (typeof(great_tag).parameters[1], str))
				# push!(scraped_text, (typeof(tag).parameters[1], str))
            end
        end
		=#
		
		if typeof(great_tag) == HTMLElement{:div} && "class" ∈ keys(great_tag.attributes)
            if great_tag.attributes["class"] == "blockPara"
                for child in great_tag.children
                    if typeof(child) == HTMLElement{:p}
						if typeof(child.children[1]) == HTMLElement{:img}
							# println(fieldnames(HTMLElement{:img}))
							push!(scraped_text, (:img, child.children[1].attributes["src"]))
						elseif typeof(child.children[1]) == HTMLElement{:b}
							push!(scraped_text, (:b, child.children[1].children[1].text))
							# println(fieldnames(HTMLElement{:b}))
							# continue
						elseif typeof(child.children[1]) == HTMLElement{:strong}
							# println(child.children[1].children[1])
							if typeof(child.children[1].children[1]) == HTMLElement{:img}
								push!(scraped_text, (:img, child.children[1].children[1].attributes["src"]))
								# continue
							else
								# normal HTMLText
								push!(scraped_text, (:strong, child.children[1].children[1].text))
								# continue
							end
						else
							continue
							# normal HTMLText
							# println(typeof(child.children[1]))
							push!(scraped_text, (typeof(great_tag).parameters[1], child.children[1].text))
							# println((typeof(great_tag).parameters[1], child.children[1]))
						end
                    end
                end
                # println("")
                # str = _latex_escape_string(elem.text)
                # push!(scraped_text, (typeof(great_tag).parameters[1], str))
            end
        end
		
		#=
		block_paragraph = eachmatch(Selector("[class=\"blockPara\"]"), webpage.root)[i]
		
		for inner_elem in PreOrderDFS(block_paragraph)
			if typeof(inner_elem) != HTMLText
				continue
			end
		
			inner_tag = inner_elem.parent
		
			if typeof(inner_tag) == HTMLElement{:p}
				push!(scraped_text, (typeof(inner_tag).parameters[1], inner_elem.text))
				break
			end
		end
		=#
		
		
		#=
		# select main content (called "NormSiCjx" (where i and j are numbers, and x may be blank or a letter) or "Normal-nonumbering" in the NZISM)
		if typeof(tag) == HTMLElement{:div} && "class" ∈ keys(tag.attributes)
			if tag.attributes["class"] == "blockPara"
				# println(elem.text)
				# println(tag.attributes["class"])
				str = _latex_escape_string(elem.text) # lstrip removes leading white space
				push!(scraped_text, (typeof(tag).parameters[1], str))
			end
		end
		=#
		
		
		#=
		if typeof(tag) == HTMLElement{:div} && "class" ∈ keys(tag.attributes)
			# println(tag.attributes)
			# break
			if tag.attributes["class"] == "subBlock"
				# println(fieldnames(typeof(tag)))
			    for child in tag.children
					# println(typeof(child))
			        if typeof(child) == HTMLText #HTMLElement{:p}
						println(child)
						str = _latex_escape_string(child.text)
						push!(scraped_text, (typeof(tag).parameters[1], str))
					end
			    end
			end
		end
		=#
	end
	
	return scraped_text
end

function _wget(url, dest)
    HTTP.open(:GET, url) do http
        open(dest, "w") do file
            write(file, http)
        end
    end
end

function write_to_file(
	save_path::AbstractString,
	# webpage::HTMLDocument;
	url::AbstractString;
	begin_file::AbstractString = string(),
	end_file::AbstractString = string()
	)
	
	scraped_text = construct_content_vector(get_webpage(url))
	
	open(save_path, "w") do io
		write(io, begin_file)

		for line in scraped_text
			line_to_write = ""
			section_level = HTMLtoLaTeX[line[1]]

			if line[1] == :p || line[1] == :div
				line_to_write = "$(section_level) $(line[2])\\\\\n"
			elseif line[1] == :strong || line[1] == :b
				line_to_write = " $(section_level){$(line[2])} "
			elseif line[1] == :img
				# str = rstrip(str, ['/'])
				# str[1:findlast('/', str)]
				split_url = split(url, "/")
				base_url = "$(split_url[1])//$(split_url[3])/"
				_wget("$(base_url)$(line[2])", joinpath(dirname(save_path), "figs", split_url[end]))
				section_level_label = replace(line[2], " " => "_")
				section_level_label = replace(section_level_label, "\\&" => "and")
				section_level_label = replace(section_level_label, "\\emdash" => "-")
				section_level_label = "fig:$(section_level_label)"
				line_to_write = "\\begin{figure}\\centering$(section_level){figs/$(split_url[end])}\\caption{}\\label{$(section_level_label)}\\end{figure}"
			else
				# normal sectioning
				# subs = Dict{AbstractString, AbstractString}(
				# 	" " => "_",
				# 	"\\&" => "and",
				# 	"\\emdash" => "-"
				# )
				# section_level_label = "$(section_level):$(replace(line[2], subs...))" # https://github.com/JuliaLang/julia/issues/29849#issuecomment-736425416
				section_level_label = replace(line[2], " " => "_")
				section_level_label = replace(section_level_label, "\\&" => "and")
				section_level_label = replace(section_level_label, "\\emdash" => "-")
				section_level_label = "$(section_level):$(section_level_label)"
				line_to_write = "\\$(section_level){$(line[2])}\\label{$(section_level_label)}\n"
			end
			
			write(io, line_to_write)
		end

		write(io, end_file)
	end
end

function _get_open_command()
	_open_command = Cmd(``)

	if Sys.islinux()
	    return _open_command = Cmd(`xdg-open`)
	elseif Sys.isapple()
	    return _open_command = Cmd(`open`)
	elseif Sys.iswindows()
	    error("Please get a better operating system.")
	else
		error("What OS are you even using??")
	end
end

end # end module

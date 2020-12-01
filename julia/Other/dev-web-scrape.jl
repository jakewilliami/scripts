#!/usr/bin/env bash
    #=
    exec julia -tauto --project="$(realpath $(dirname $(realpath $(dirname $0))))" --color=yes --startup-file=no -e "include(popfirst!(ARGS))" \
    "${BASH_SOURCE[0]}" "$@"
    =#

#module NZISM

using HTTP, Gumbo, AbstractTrees#, Cascadia, LaTeXStrings

save_path = joinpath(homedir(), "Desktop", "nzism", "nzism_auto.tex")
begin_file = """
% !TEX TS-program = pdflatexmk.py
\\documentclass[11pt, a4paper]{article}
% https://www.gcsb.govt.nz/publications/the-nz-information-security-manual

\\input{nzism_preamble.sty}

\\title{New Zealand Information Security Manual\\\\{\\scriptsize as of September, 2020}}
\\author{Government Communications Security Bureau}

\\begin{document}
"""
end_file = "\\end{document}"
url = "https://www.nzism.gcsb.govt.nz/ism-document/"

const HTMLtoLaTeX = Dict{Symbol, String}(
    :h1 => "section",
    :h2 => "subsection",
	:h3 => "subsection*",
	:h4 => "subsubsection*",
	:p => "\\textbf{\\subsubsectioncounter}\\hspace{1em}",
)

function _latex_escape_string(str::AbstractString)
	str = lstrip(str) # lstrip removes leading white space
	str = replace(str, "&" => "\\&")
	str = replace(str, " - " => "\\emdash ")
	str = replace(str, "_" => "\\_")
	str = replace(str, "#" => "\\#")
	return str
end

function curl_webpage(url::AbstractString)
	return moosehead = parsehtml(String(HTTP.get(url).body))
end

function construct_content_vector(webpage::HTMLDocument)
	TagText = Tuple{Symbol, String}
	scraped_text = Vector{TagText}()
	
	for elem in PreOrderDFS(webpage.root)
	    if typeof(elem) != HTMLText
			continue
		end
		
        tag = elem.parent
		
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
		if typeof(tag) == HTMLElement{:p} #&& "class" ∈ keys(tag.attributes)
			# if tag.attributes["class"] == "subBlock" || tag.attributes["class"] == "blockRandC"
			# println(tag.attributes["class"])
				str = _latex_escape_string(elem.text)
				push!(scraped_text, (typeof(tag).parameters[1], str))
			# end
		end
		
		
		
		# select main content (called "NormSiCjx" (where i and j are numbers, and x may be blank or a letter) or "Normal-nonumbering" in the NZISM)
		if typeof(tag) == HTMLElement{:div} && "class" ∈ keys(tag.attributes)
			if tag.attributes["class"] == "blockPara"
				# println(elem.text)
				# println(tag.attributes["class"])
				str = replace(elem.text, "&" => "\\&") # lstrip removes leading white space
				push!(scraped_text, (typeof(tag).parameters[1], str))
			end
		end
		
		
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

# write to file!
function write_to_file(
	save_path::AbstractString,
	webpage::HTMLDocument,
	begin_file::AbstractString,
	end_file::AbstractString)
	
	scraped_text = construct_content_vector(webpage)
	
	open(save_path, "w") do io
		write(io, begin_file)

		for line in scraped_text
			section_level = HTMLtoLaTeX[line[1]]

			if line[1] == :p
				write(io, "$(section_level) $(line[2])\\\\\n")
				# continue
			else
				section_level_label = replace(line[2], " " => "_")
				section_level_label = replace(section_level_label, "\\&" => "and")
				section_level_label = replace(section_level_label, "\\emdash" => "-")
				section_level_label = "$(section_level):$(section_level_label)"
				write(io, "\\$(section_level){$(line[2])}\\label{$(section_level_label)}\n")
			end
		end

		write(io, end_file)
	end
end

############# TESTING ###################

# using BenchmarkTools
# @btime write_to_file(save_path, curl_webpage(url), begin_file, end_file) # <= 1.583 s (4166524 allocations: 274.18 MiB)

moosehead = curl_webpage(url)

# write_to_file(save_path, moosehead, begin_file, end_file)

scraped_text = construct_content_vector(moosehead)
for i in scraped_text
	# if i[1] == :h1
		println(i)
	# end
end

# run(`open $(save_path)`)

#end # end module

# TODO:
# - get `description` working
# - pull image from webpage (no TiKZ...)
# - get Rationale and Controls section working
# - get reference tables working (use longtable)
# - remove random subsubsection at start
# - "as of [September, 2020]" automated
# - remove date

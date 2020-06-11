#! /usr/bin/env julia

# import Pkg; Pkg.add("PDFIO"); Pkg.add("Match")

using PDFIO


"""
​```
    getPDFText(src, out) -> Dict
​```
- src - Input PDF file from where text is to be extracted
- out - Output TXT file where the output will be written
return - A dictionary containing metadata of the document
"""
function getPDFText(src, out)
    # handle that can be used for subsequence operations on the document.
    doc = pdDocOpen(src)

    # Metadata extracted from the PDF document.
    # This value is retained and returned as the return from the function.
    docinfo = pdDocGetInfo(doc)
    open(out, "w") do io

        # Returns number of pages in the document
        npage = pdDocGetPageCount(doc)

        for i=1:npage

            # handle to the specific page given the number index.
            page = pdDocGetPage(doc, i)

            # Extract text from the page and write it to the output file.
            pdPageExtractText(io, page)

        end
    end
    # Close the document handle.
    # The doc handle should not be used after this call
    pdDocClose(doc)
    return docinfo
end


"""
​```
    scanFiles(path, key)
​```
- path - The path from which to search.
- key - The regex or file names to search for
"""
function scanFiles(path, key)
    # walk through directories from current directory
    for (root, dirs, files) in walkdir(expanduser(path))
        
        # loop through files in present directory
        for file in files
            f, ex = splitext(file)
            
            # focus files with pdf extension
            if ex == key
                
                # define a full path to pdf fule
                pathToFile = joinpath(root, file)
                
                println(pathToFile)
                # get PDF plain text
                getPDFText("$pathToFile", "/tmp/tempPDFOut")
                
                # read file created
                # open("/tmp/tempPDFOut") do f
                #
                #     # loop through lines in file
                #     # for l in eachline(f)
                #     #
                #     #     # find matches to input
                #     #     # if occursin(r"$ARGS[1]"i, l)
                #     #         # println(l)
                #     #     # end
                #     #
                #     # end
                #
                # end
                
            end
            
        end
        
    end
end

println(scanFiles(pwd(), ".pdf"))

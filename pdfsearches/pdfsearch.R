#!/usr/bin/env Rscript

#Run using `Rscript ~/scripts/pdfsearches/pdfsearch.R`

#print("Hello World!", quote = FALSE)

start_time <- Sys.time()

# Install package manager
library(pacman)
#pacman::p_load(package1, package2, ...)
pacman::p_load(pdftools, crayon, pkgcond)

args = commandArgs(trailingOnly = TRUE)
# message(sprintf("Hello %s", args[1L]))
main <- function() {
    found = FALSE
    found_count = 0

    pdfs_found <- dir(path = ".",
                        pattern = "^.*\\.pdf$",
                        all.files = FALSE,
                        ignore.case = TRUE,
                        full.names = TRUE,
                        recursive = TRUE)
                        
    # print(pdfs_found)

    for (pdf in pdfs_found) {
        # `pdf_text` converts it to a list
        textified <- try(pdftools::pdf_text(pdf), silent=TRUE)
        grepped_text <- grep(args[1L], textified, ignore.case = TRUE)
        found <- any(grepped_text)
        
        if (found) {
            found_count <- found_count + 1
            cat(green(paste(pdf)),"\n") # print the file in which it is found
        }
        
        match_count <- sum(lengths(grepped_text))
    }

    end_time <- Sys.time()

    print(end_time - start_time)

    cat(yellow(paste(end_time - start_time, " minutes\n")))

    cat(blue(paste("Found", "\"", args[1L], "\"",  " in ", found_count, "PDFs.")))
}


suppress_warnings(main(), "warning")

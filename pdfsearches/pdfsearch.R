#!/usr/bin/env Rscript

#Run using `Rscript ~/scripts/pdfsearches/pdfsearch.R`

#print("Hello World!", quote = FALSE)

start_time <- Sys.time()

# Install package manager
library(pacman)
#pacman::p_load(package1, package2, ...)
pacman::p_load(pdftools, crayon)

args = commandArgs(trailingOnly = TRUE)
#message(sprintf("Hello %s", args[1L]))

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
    textified <- pdftools::pdf_text(pdf)
    grepped_text <- grep(args[1L], textified, ignore.case = TRUE)
    found <- any(grepped_text)
    if (found == TRUE) {
        found_count <- found_count + 1
        cat(green(paste(pdf)),"\n") # print the file in which it is found
    }
    match_count <- sum(lengths(grepped_text))
}

pdf_dir <- '/Users/jakeireland/Desktop/Study/Victoria University/2018/Trimester 2/PSYC221/Minority Report/Report/Minority Report.pdf'


end_time <- Sys.time()

cat(yellow(paste(end_time - start_time, " seconds\n")))

cat(blue(paste("Found", "\"", args[1L], "\"",  " in ", found_count, "PDFs.")))

#!/usr/bin/env Rscript

#Run using `Rscript ~/bin/scripts/pdfsearches/pdfsearch.R`

#print("Hello World!", quote = FALSE)

# Install package manager
library(pacman)
#pacman::p_load(package1, package2, ...)
pacman::p_load(pdftools, crayon)

args = commandArgs(trailingOnly = TRUE)
#message(sprintf("Hello %s", args[1L]))

pdf_dir <- '/Users/jakeireland/Desktop/Study/Victoria University/2018/Trimester 2/PSYC221/Minority Report/Report/Minority Report.pdf'

# `pdf_text` converts it to a list
textified <- pdftools::pdf_text(pdf_dir)
grepped_text <- grep(args[1L], textified, ignore.case = TRUE)
found <- any(grepped_text)
match_count <- sum(lengths(grepped_text))

if(found == TRUE){
    cat(blue(paste("Fgound", "\"", args[1L], "\"",  match_count, "times in a PDF.")))
}







#rm(list = ls()) #clears environment
#
#detach("package:datasets", unload = TRUE) #unloads packages
#
#dev.off() #clears plots if there are any
#
#cat("\014")#clears console
#!/usr/bin/env Rscript

# install.packages("pacman")
library(pacman)

pacman::p_load(readr, tree)

args <- commandArgs(trailingOnly=TRUE)

df <- tibble::as_tibble(read.csv(args[1]))
df$comparison <- factor(as.integer(df$comparison))

# open plot file
plot_file <- paste("~/projects/CodingTheory.jl/other/Rplots_", args[2], ".pdf", sep="")
pdf(plot_file)
# create plot
fit <- tree(comparison ~ q + n + d, data = df)
plot(fit)
text(fit, cex=0.75)
# close plot file
dev.off()



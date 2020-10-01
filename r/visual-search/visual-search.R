#!/usr/bin/env Rscript

# install.packages("pacman")
library(pacman)

pacman::p_load(readr, ggplot2)

df <- read.csv("data.csv", header = FALSE, sep = "\t")
colnames(df) <- c("block", "stim_no", "trial_type", "set_size", "response", "RT")

fit = aov(RT ~ set_size, data=df)

print(fit)
print(summary(fit))

#!/usr/bin/env Rscript

# install.packages("pacman")
library(pacman)
pacman::p_load(readxl, plyr, dplyr, tidyr, Rmisc, ggplot2)

# read the first worksheet in the excel file
df_gist <- read_excel("GISTdata.xlsx", col_names = FALSE)
cn <- gsub("'", "", df_gist$`...1`)

# Transpose table you want
df_gist_T <- df_gist %>%
  select(-`...1`) %>%
  t() %>%
  as_tibble()

# Set the column headings from the first column in the original table
colnames(df_gist_T) <- cn

# write to CSV the transposed data
write.csv(df_gist_T, "out_transposed.csv", row.names = FALSE)

# select columns starting with "F"
pic_groups <- c("F", "C", "LF", "HF")
col_starts_with <- function(df, str) select(df, starts_with(str))
df_starts_with <- lapply(pic_groups, col_starts_with, df = df_gist_T)
names(df_starts_with) <- pic_groups

# get the average face gist
face_avg_gist <- rowMeans(df_starts_with$F, na.rm = TRUE)

# get correlations
cor_with_avg <- function(mat, x) apply(mat, 2, cor, y = x)
cor_with_avg_df <- function(df, nm, x) tibble(tt = nm, val = cor_with_avg(df[[nm]], x))

all_corrs <- lapply(pic_groups, cor_with_avg_df, df = df_starts_with, x = face_avg_gist) %>%
    do.call(what = bind_rows)

# construct summary for cross bars used in plot
all_corrs_summary <- Rmisc::summarySE(all_corrs, measurevar = "val", groupvars = "tt")

# construct plot!
all_corrs %>%
  ggplot(aes(x = tt, y = val)) +
  geom_jitter(colour = "red", width = 0.05) +
  geom_crossbar(data = all_corrs_summary, inherit.aes = FALSE,
                aes(x = tt, y = val, ymin = val, ymax = val, group = tt),
                width = 0.5) +
  labs(y = "Correlation to Faces", x = "Image Type")

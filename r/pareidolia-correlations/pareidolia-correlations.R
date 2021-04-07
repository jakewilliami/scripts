#!/usr/bin/env Rscript

# install.packages("pacman")

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
col_starts_with <- function(df, str) select(df, starts_with(str))

df_gist_T_F  <- col_starts_with(df_gist_T, "F")
df_gist_T_C  <- col_starts_with(df_gist_T, "C")
df_gist_T_LF <- col_starts_with(df_gist_T, "LF")
df_gist_T_HF <- col_starts_with(df_gist_T, "HF")

# get the average face gist
face_avg_gist <- rowMeans(df_gist_T_F, na.rm = TRUE)

# get correlations
cor_with_avg <- function(mat, x) apply(mat, 2, cor, y = x)

corr_F  <- cor_with_avg(df_gist_T_F,  face_avg_gist)
corr_C  <- cor_with_avg(df_gist_T_C,  face_avg_gist)
corr_LF <- cor_with_avg(df_gist_T_LF, face_avg_gist)
corr_HF <- cor_with_avg(df_gist_T_HF, face_avg_gist)

# construct a long dataframe with all correlations and discrete types
all_corrs <- bind_rows(
  tibble(tt = "F", val = corr_F),
  tibble(tt = "C", val = corr_C),
  tibble(tt = "LF", val = corr_LF),
  tibble(tt = "HF", val = corr_HF)
)

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

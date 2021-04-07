#!/usr/bin/env Rscript

# install.packages("pacman")
library(pacman)

pacman::p_load(readxl, plyr, dplyr, tidyr, Rmisc, ggplot2)

# read the first worksheet in the excel file
df.gist <- tibble::as_tibble(read_excel("GISTdata.xlsx"))

# Transpose table you want
df.gist.T <- t(df.gist[, 2:ncol(df.gist)])

# Set the column headings from the first column in the original table
colnames(df.gist.T) <- gsub("'", '', t(df.gist[,1])) # note that this outputs a matrix!

# make nice dataframe
df.gist.T <- tibble::as_tibble(as.data.frame(df.gist.T))

# write to CSV the transposed data
write.csv(df.gist.T, "out_transposed.csv", row.names = FALSE)

# select columns starting with "F"
df.gist.T.F <- df.gist.T %>% dplyr::select(dplyr::matches("^F"))

# by the same logic, collect other image categories
df.gist.T.C <- df.gist.T %>% select(matches("^C"))
df.gist.T.LF <- df.gist.T %>% select(matches("^LF"))
df.gist.T.HF <- df.gist.T %>% select(matches("^HF"))

# get the average face gist
face_avg_gist <- apply(X = df.gist.T.F, MARGIN = 1, FUN = mean, na.rm = TRUE)

# get correlations
corr_F <- apply(X = df.gist.T.F, MARGIN = 2, FUN = cor, y = face_avg_gist)
corr_C <- apply(X = df.gist.T.C, MARGIN = 2, FUN = cor, y = face_avg_gist)
corr_LF <- apply(X = df.gist.T.LF, MARGIN = 2, FUN = cor, y = face_avg_gist)
corr_HF <- apply(X = df.gist.T.HF, MARGIN = 2, FUN = cor, y = face_avg_gist)

# construct a long dataframe with all correlations and discrete types
all_corrs <- data.frame(tt = rep("F", length(corr_F)), val = corr_F)
all_corrs <- rbind(all_corrs, data.frame(tt = rep("C", length(corr_C)), val = corr_C))
all_corrs <- rbind(all_corrs, data.frame(tt = rep("LF", length(corr_LF)), val = corr_LF))
all_corrs <- rbind(all_corrs, data.frame(tt = rep("HF", length(corr_HF)), val = corr_HF))
all_corrs <- as.data.frame(all_corrs)

# construct summary for cross bars used in plot
all_corrs_summary <- Rmisc::summarySE(all_corrs, measurevar = "val", groupvars = "tt")

# construct plot!
ggplot()+
    geom_jitter(aes(tt, val), data = all_corrs, colour = I("red"), 
                position = position_jitter(width = 0.05)) +
    geom_crossbar(data = all_corrs_summary, aes(x = tt, ymin = val, ymax = val, y = val, group = tt), width = 0.5) +
    labs(y = "Correlation to Faces", x = "Image Type") # +
  ## scale_x_continuous(breaks = c("F", "C", "LF", "HF"), labels = c("Faces", "Cars", "High-face Pareidolia", "Low-face Pareidolia"))


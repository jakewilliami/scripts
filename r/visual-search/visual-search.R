#!/usr/bin/env Rscript

# install.packages("pacman")
library(pacman)

pacman::p_load(readr, dplyr, ggplot2)

df <- tibble::as_tibble(read.csv("~/projects/scripts/r/visual-search/data.csv", header = FALSE, sep = "\t"))
colnames(df) <- c("block", "stim_no", "trial_type", "set_size", "response", "RT")

df_pivot <- df %>%
    filter(trial_type == 1, response == 1) %>%
    select(set_size, RT) %>%
    group_by(set_size) %>%
    dplyr::summarise(average_rt = mean(RT))

myTheme <- theme(plot.title = element_text(family = "Helvetica", face = "bold", size = (15)),
                 axis.title = element_text(family = "Helvetica", size = (10), colour = "steelblue4"),
                 axis.text = element_text(family = "Courier", colour = "cornflowerblue", size = (10)))

line <- lm(average_rt ~ set_size, data = df_pivot)
line_coeffs = coefficients(line)
equation = paste("italic(y) == ", round(line_coeffs[2],1), "*italic(x) + ", round(line_coeffs[1],1))

ggplot(df_pivot, aes(set_size, average_rt)) +
    geom_point(colour = "orange") +
    scale_x_continuous(limits = c(0, max(df_pivot$set_size))) + 
    scale_y_continuous(limits = c(0, max(df_pivot$average_rt))) + 
    myTheme +
    ggtitle("Response Time of Visual Searches") +
    theme(plot.title = element_text(hjust = 0.5)) +
    labs(y="Response Time", x = "Set Size") + 
    geom_abline(intercept = line_coeffs[1], slope = line_coeffs[2], color="steelblue") +
    annotate("text",
              x = 3, y = 1100, 
              label = equation, 
              parse = TRUE)

#analysis_df <- df %>%
#    filter(trial_type == 1, response == 1) %>%
#    select(set_size, RT, stim_no) %>%
#    group_by(set_size, stim_no) %>%
#    dplyr::summarise(average_rt = mean(RT)) %>%
#    spread(set_size, average_rt)

analysis_df <- df %>%
    filter(trial_type == 1, response == 1) %>%
    select(set_size, RT, stim_no) %>%
    group_by(set_size, stim_no) %>%
    dplyr::summarise(average_rt = mean(RT))
analysis_df$set_size <- as.factor(analysis_df$set_size)

model <- lm(average_rt ~ set_size, data = analysis_df)
anova(model)

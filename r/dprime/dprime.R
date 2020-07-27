#!/usr/bin/env Rscript

# install.packages("pacman")
library(pacman)

pacman::p_load(psycho, dplyr)


data <- read.csv('data.csv')
df <- data.frame(data)

numberPresent <- sum(df$Condition == 'Present', na.rm=TRUE)
numberAbsent <- sum(df$Condition == 'Absent', na.rm=TRUE)

dfPivot <- df %>%
     na_if("") %>%
     na.omit %>%
     group_by(Condition, Response) %>% 
     summarise(count = n()) %>%
     tibble::as_tibble() %>%
     pull()


dfAccuracy <- c(dfPivot[1]/numberAbsent, dfPivot[2]/numberAbsent, dfPivot[3]/numberPresent, dfPivot[4]/numberPresent)

dprime <- as.numeric(qnorm(dfAccuracy[4])) - as.numeric(qnorm(dfAccuracy[2]))

print(dprime)
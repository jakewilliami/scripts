library(pacman)
pacman::p_load(tidyjson,dplyr,tidyverse,jsonlite,rjson,dummies,tibble,Rmisc)

# import dataset (untouched) as 'originalDataset' and dataset grepped using command line as 'testResponses'
originalDataset <- readr::read_csv(file = "kfc_stimulusResponses.csv", col_names = TRUE)

# get index of user_ids that finished the questionnaire
greppedByThanks <- originalDataset[grepl("Thanks for helping", originalDataset$data_string),]

# create index of completed ids
IDIndex <- greppedByThanks[[2]]

# filter the original dataset by the index of completed IDs
importantIDs <- filter(originalDataset, user_id %in% IDIndex)

# this creates a dataframe of presponses made by participants who have finished
testResponses <- importantIDs[grepl('"correct":(true|false)', importantIDs$data_string),]

# sanity test: check number of user_ids completed and number of rows for the completed dataset
length(IDIndex)
nrow(importantIDs)


# if parameter is empty, make an empty dataframe; else import it as JSON
f <- function(.x) 
  if (is.na(.x) || .x == "") data.frame()[1, ] else 
    as.data.frame(jsonlite::fromJSON(.x))

#name object called 'named' from dataframe and take the JSON out of it
named <- testResponses %>% 
  tidyr::unnest(data_string = lapply(data_string, f)) %>% 
  mutate_at(vars("correct"), as.character)


correct <- named[14]
song_type_str <- named[8]


testResponses["correctness"] <- correct
testResponses["song_type_str"] <- song_type_str


# summarise correctness for song type (grouped by user id) and return proportion
df_test <- 
testResponses %>%
  group_by(., user_id, song_type_str) %>%
  dplyr::summarise(., n = n(),
               trues  = sum(as.logical(correctness))) %>%
  mutate(prop = (trues / n) * 100) 

# "quick and dirty" average across participants (within song type)
Rmisc::summarySEwithin(df_test, measurevar = "prop", withinvars = "song_type_str",
                       idvar = "user_id")



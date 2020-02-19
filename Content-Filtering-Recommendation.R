library(dplyr)

jaccard <- function(a, b){
  length(intersect(a, b)) / length(union(a, b))
}

cos.sim <- function(a, b) 
{
  return( sum(a*b)/sqrt(sum(a^2)*sum(b^2)) )
} 

movies <- read.csv("ml-latest-small/movies.csv", stringsAsFactors = FALSE)
tags   <- read.csv("ml-latest-small/tags.csv", stringsAsFactors = FALSE)
movies_tags <- inner_join(movies, tags, by = "movieId")

id <- 1
movie <- filter(movies_tags, movieId == id)
title <- unique(movie$title)
message("Movie name: ", title, "...")
scores <- numeric()
for (candidate in unique(movies_tags$movieId)){
  candidateTags <- movies_tags %>%
    filter(movieId == candidate)
  scores[as.character(candidate)] <- jaccard(movie$tag, candidateTags$tag)
}
message("Recommend :")
recommendations <- movies_tags %>%
  filter(movieId %in% names(tail(sort(scores), 10))) %>%
  select(title) %>%
  unique() %>%
  print()

library(dplyr)

jaccard <- function(a, b){
  length(intersect(a, b)) / length(union(a, b))
}

cos.sim <- function(a, b) 
{
  return( sum(a*b)/sqrt(sum(a^2)*sum(b^2)) )
}

products <- read.csv("sample-data.csv", header = TRUE, 
                     stringsAsFactors = FALSE)

id <- 1
product <- filter(products, id == id)
description <- unique(product$description)

message("Product : ", strsplit(description, split = " - ")[[1]][1], "...")
scores <- numeric()
for (candidate in unique(product$id)){
  candidateTags <- products %>%
    filter(id == candidate)
  scores[as.character(candidate)] <- jaccard(product$description, products$description)
}
message("Recommend :")
recommendations <- products %>%
  filter(id %in% names(tail(sort(scores), 10))) %>%
  select(description)

for (recommend in 1:nrow(recommendations)) {
  message(recommend, " : ", strsplit(recommendations[recommend,1], split = " - ")[[1]][1])
}


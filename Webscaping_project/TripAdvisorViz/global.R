 library(wordcloud)
 library(tm)
 library(dplyr)
 library(tidytext)
 library(streamgraph)
 library(tidyr)
 library(ggplot2)
 library(reshape2)

 ####### Word Comparison ##########
 reviewsdf<-read.csv("reviews.csv")
 reviewsdf$hotel_name<-as.character(reviewsdf$hotel_name)
 byratings<-reviewsdf %>%
   group_by(ratings) %>%
   summarise(text=paste(review,collapse=''))
 clean.text = function(x)
 {
# tolower
   x = tolower(x)
#   # remove rt
   x = gsub("rt", "", x)
#   # remove at
   x = gsub("@\\w+", "", x)
#   # remove punctuation
   x = gsub("[[:punct:]]", " ", x)
#   # remove numbers
   x = gsub("[[:digit:]]", "", x)
#   # remove links http
   x = gsub("http\\w+", "", x)
#   # remove tabs
   x = gsub("[ |\t]{2,}", " ", x)
#   # remove blank spaces at the beginning
   x = gsub("^ ", "", x)
#   # remove blank spaces at the end
  x = gsub(" $", "", x)
   return(x)
 }

 byratings$cleanedreviews<-lapply(byratings$text, clean.text)
 docs <- Corpus(VectorSource(byratings$cleanedreviews))
 inspect(docs)
 dtm <- TermDocumentMatrix(docs)
 m <- as.matrix(dtm)
 # # add column names
  colnames(m) = byratings$ratings
 

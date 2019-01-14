shinyServer(
  function(input, output, session) {
    output$data<-renderTable({
    head(reviewsdf,10)
      
    })
    
    selectedHotel<-reactive({
      as.character((input$hotel))
    })
    output$allcloud<-renderPlot({
   if(input$hotel=="All"){
    comparison.cloud(m, random.order=FALSE, 
                     colors = c("#00af87", "red", "#000000", "#FCC40F","#6b7a8f"),
                     title.size=1.5, max.words=400, scale=c(4,0.4))
      
   }
      else{
   
    byratingsin<-reviewsdf %>%
      filter(hotel_name %in% selectedHotel()) %>%
      group_by(hotel_name) %>%
      summarise(text=paste(review,collapse=''))
    byratingsin$cleanedreviews<-lapply(byratingsin$text, clean.text)
    docsin <- Corpus(VectorSource(byratingsin$cleanedreviews))
    inspect(docsin)
    dtmin <- TermDocumentMatrix(docsin)
    matr <- as.matrix(dtmin)
    # # add column names
    colnames(matr) = byratingsin$hotel_name
    matr<-as.data.frame(matr)
    wordcloud(rownames(matr), freq=matr[,1],random.order=FALSE, 
                     title.size=1.5, max.words=400, scale=c(4,0.9),colors = c("#00af87", "red", "#000000", "#FCC40F","#6b7a8f"))
   
    }
    }
    )
    
    output$sentiment<-renderPlot({
      if(input$hotel=="All"){
    reviewsdfsentiments<-m
    reviewsdfsentiments<-melt(reviewsdfsentiments, value.name = "n")
    colnames(reviewsdfsentiments)[1]<-"word"
   reviewsdfsentiments$word<-as.character(reviewsdfsentiments$word)
    sentiments=  reviewsdfsentiments %>% inner_join(get_sentiments("bing")) %>%
      spread(sentiment, n, fill = 0) %>% mutate(sentiment = positive - negative)
    sentiments$Docs<-as.character(sentiments$Docs)
    sentiments<-sentiments  %>% mutate(index=rownames(sentiments))
    sentiments$index<-as.numeric(sentiments$index)
    ggplot(sentiments, aes(index, sentiment)) +
      geom_col(show.legend = FALSE, width=3) + theme_bw()
    
    
      } else{
        byratingsin<-reviewsdf %>% filter(hotel_name %in% selectedHotel()) %>%
          group_by(hotel_name) %>%
          summarise(text=paste(review,collapse=''))
        byratingsin$cleanedreviews<-lapply(byratingsin$text, clean.text)
        docsin <- Corpus(VectorSource(byratingsin$cleanedreviews))
        inspect(docsin)
        dtmin <- TermDocumentMatrix(docsin)
        matr <- as.matrix(dtmin)
        # # add column names
        colnames(matr) = byratingsin$hotel_name
        matr<-as.data.frame(matr)
    
        reviewsdfsentiments<-matr
        #reviewsdfsentiments<-melt(reviewsdfsentiments, value.name = "n")
        #r(reviewsdfsentiments)<-"word"
        reviewsdfsentiments$word<-rownames(reviewsdfsentiments)
        colnames(reviewsdfsentiments)[1]<-"n"
        reviewsdfsentiments$word<-as.character(reviewsdfsentiments$word)
        sentiments=  reviewsdfsentiments %>% inner_join(get_sentiments("bing")) %>%
          spread(sentiment, n, fill = 0) %>% mutate(sentiment = positive - negative)
        #sentiments$<-as.character(sentiments$Docs)
        sentiments<-sentiments  %>% mutate(index=rownames(sentiments))
        sentiments$index<-as.numeric(sentiments$index)
        ggplot(sentiments, aes(index, sentiment)) +
          geom_col(show.legend = FALSE, width=0.9) + theme_bw()
      }
    
    })
  }
  
)
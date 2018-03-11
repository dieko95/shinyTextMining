
library(shiny)
library(rtweet)
library(twitteR)
library(quanteda)
library(tm)
library(factoextra)
library(FactoMineR)
library(cluster)
library(tm)
library(ggplot2)
library(stringr)
library(RTextTools)



shinyServer(function(input, output) {
   
  # output$nombre <- renderPrint({ 
  #   h1<-
  #   
  #   })
  # output$query<- reactiveValues(data = NULL)
  
  # observeEvent(input$busquedaTweets, {
  #   # input$busquedaTweets
  #   # h1<-search_tweets(input$nombreTweet,n = input$nTerminos)
  #   # texto<-h1$text
  #   })
    
  # 
  # observe({
  #   tweets_result<-search_tweets(h1,n = input$nTerminos)
  # })
  

  
  

# Correlation graph -------------------------------------------------------

  
  output$grafico<-renderPlot({
    
    input$busquedaTweets

        
       isolate({
         h1<-search_tweets(input$nombreTweet,n = input$nTerminos, lang = "es")
       
        texto<-h1$text
        
        texto <- iconv(texto, 'UTF-8', 'ASCII')
        
        texto<-str_replace_all(texto,"[^[:graph:]]", " ") 
        
        texto<-tolower(texto)
        
        
        # texto<-wordStem(texto, language = "spanish")
        
        # Reemplaza @UserName y #hastags
        texto<-gsub("@\\w+", " ", texto)
        texto<-gsub("#\\w+", " ", texto)
        
        # Reemplaza rt
        texto<-gsub("rt ", " ", texto)
        
        # Remove punctuation
        texto<-gsub("[[:punct:]]", " ", texto)
        
        #Remueve los acentos
        texto<-gsub("ú", "u", texto)
        texto<-gsub("ù", "u", texto)
        texto<-gsub("ü", "u", texto)
        texto<-gsub("ó", "o", texto)
        texto<-gsub("ò", "o", texto)
        texto<-gsub("í", "i", texto)
        texto<-gsub("ì", "i", texto)
        texto<-gsub("é", "e", texto)
        texto<-gsub("è", "e", texto)
        texto<-gsub("á", "a", texto)
        texto<-gsub("à", "a", texto)
        texto<-gsub("ñ", "gn", texto)
        texto<-gsub("Ã", "A",texto)
        
        # Remueve los links
        texto<-gsub("http.+", " ", texto)
        
        # Remueve los espacios especiales
        texto<-gsub("[ |\t]{6,7}", " ", texto)
        texto<-gsub("[ |\t]{4,5}", " ", texto)
        texto<-gsub("[ |\t]{2,3}", " ", texto)
        
        # Remueve los espacios en blanco
        texto<-gsub("^ ", "", texto)
        
        # Remove los espacios al final de cada palabra
        texto<-gsub(" $", "", texto)
        
        # Remueve los numeros
        texto<-gsub("\\d", " ", texto)
        
        
        
        precorpus<-Corpus(VectorSource(as.character(texto)))
        precorpus<-tm_map(precorpus, removeWords, stopwords("spanish"))
        matrix.corpus<-TermDocumentMatrix(precorpus)
        
       })
        # matrix.corpus<-dfm(h1$text)
        palabra <- input$text # term of interest
        corlimit <- input$cor #  lower correlation bound limit.
        correlacion <- data.frame(corr = findAssocs(matrix.corpus, palabra, corlimit)[[1]],
                                  terms = names(findAssocs(matrix.corpus, palabra, corlimit)[[1]]))
        
        correlacion$terms <- factor(correlacion$terms ,levels = correlacion$terms)
        
        p <-ggplot(correlacion, aes(terms, corr, fill = corr))
        p <-p + geom_bar(stat="identity")
        p <-p + theme(axis.text.x = element_text(angle=60, hjust=1, size = 10),
                      axis.text.y = element_text(size = 15), 
                      axis.line = element_line(colour = "darkblue", 
                                               size = 1, linetype = "solid"))
        p <-p + scale_y_continuous(name = "Correlaciones", breaks = seq(0,1,input$tick))  
        p <-p + coord_flip()
        p <-p + xlab(paste0("Correlacion con el termino", "\"", palabra, "\""))
        
        # plot_ly(data = correlacion, x = ~terms, y = ~corr,
        # name = "barras", type = "bar")
        print(p)
        
        
  })
    thedata<-reactive(

      search_tweets(input$nombreTweet,n = input$nTerminos, lang = "es")

      )

  output$downloadData <- downloadHandler(

      filename = function() {
      paste("data_twitter-",Sys.time(),".csv", sep = "")
    },
    content = function(file) {
      # assign()

      save_as_csv(thedata(),
                  file)
    }
  )

  # output$tweets_table <- renderDataTable({
  #   h1<-search_tweets(input$nombreTweet,n = input$nTerminos, lang = "es") })
  #   h1
  # })
  
})

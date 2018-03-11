
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
library(RTextTools)



consumer_key<-'XXXXXXXXXXXXXXXXXXXXX'
consumer_secret<-'XXXXXXXXXXXXXXXX'
access_token<- 'XXXXXXXXXXXX'
access_secret<-'XXXXXXXXXX'


setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
appname <- "rtweet_tokens1995"
key <- consumer_key
secret <- consumer_secret

twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Shiny Text Mining App"),
    
    mainPanel(
      textInput("nombreTweet", label = h3("Text input"), value = "Enter text..."),
      sliderInput(inputId = "nTerminos",
                  label = "Cantidad de tweets a extraer", 
                  value = 0, min = 0, max = 500, step = 50),
      actionButton("busquedaTweets", label = "Buscar Tweets"),
      downloadButton("downloadData", "Download"),
      # dataTableOutput('tweets_table'),
      
      h4(strong("Analisis de Correlaciones"), align = "center"),
      
        sidebarPanel(  
    textInput(inputId = "text", label = ("Panel de Control"), value = "Escriba palabra a visualizar en minusculas..."),
          sliderInput(inputId = "cor",
                      label = "Magnitud de Correlacion", 
                      value = 0.03, min = 0, max = 1, step = 0.01),
          sliderInput(inputId = "tick",
                      label = "Subdivision en Eje 'X'", 
                      value = 0.1, min = 0.01, max = 1, step = 0.01)
      ),
    plotOutput("grafico",  width = "1200px", height = "1200px")
  ))
)

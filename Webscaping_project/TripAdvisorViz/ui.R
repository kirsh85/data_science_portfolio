library(shiny)
shinyUI(
  fixedPage(
  br(),
  titlePanel("Hotel Reviews"),
  h5("This App uses Trip Advisor data to analyse customer reviews from Hotels in Cape Town. These are my findings:"),
  hr(),
  sidebarLayout(
    sidebarPanel(width=3,
                 
                 img(src="tripadvisor.png", height = 125, width = 200),
                 br(), br(),
                 #textInput("artist", "Enter Hotel", placeholder="hotel name..."),
                 selectInput("hotel","Hotel", choices = c("All",as.character(reviewsdf$hotel_name)), selected = "All"),
                 tags$head(tags$style(HTML('#run{background-color:#00af87}'))),
                 actionButton("run",label="Find Reviews!", icon=icon("user")),
                 br(), br(),
                 p("Data scraped from the  ", a("Trip Advisor", href = "https://tripadvisor.com/", target="_blank"), "using Scrapy")#,
                
    ),
    mainPanel 
      ({
        tabsetPanel(
        tabPanel("data",
                tableOutput("data")
                 ),
        
        tabPanel("sentiments",
        column(12,
        fluidRow(
          h3("Sentiments of Reviews at each Hotel"),
       
        plotOutput("allcloud",width="700px",height="600px"),
        plotOutput("sentiment")
        )
      
          
        
        )    
      )
      )
      
      })
      
    
  
  
)
)
)
    
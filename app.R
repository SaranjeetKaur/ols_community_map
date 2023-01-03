library(maps)
library(leaflet)
library(dplyr)
library(shiny)

df <- read.csv("data/olscommunity.csv")

ui <- fillPage(
  tags$style(type = "text/css", "html, body {width:100%; height:100%}"),
  titlePanel("OLS Community Map"),
  leafletOutput("mymap", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
                selectInput(inputId = "ols_cohort",
                            label = "Choose the cohort you want to see:",
                            choices = list("OLS 1" = "OLS_1", 
                                           "OLS 2" = "OLS_2",
                                           "OLS 3" = "OLS_3",
                                           "OLS 4" = "OLS_4",
                                           "OLS 5" = "OLS_5",
                                           "OLS 6" = "OLS_6"))
  )
)

server <- function(input, output, session) {
  output$mymap <- renderLeaflet({
    leaflet(df %>%
              dplyr::filter(
                ols_cohort == input$ols_cohort
              )) %>%
      addTiles() %>%
      addMarkers(lat = ~latitude, lng=~longitude)
  })
}

shinyApp(ui, server)

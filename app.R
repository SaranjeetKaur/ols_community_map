library(maps)
library(leaflet)
library(dplyr)
library(shiny)

df <- read.csv('https://raw.githubusercontent.com/open-life-science/ols-program-paper/main/data/people_per_cohort.csv')

ui <- fillPage(
  tags$style(type = "text/css", "html, body {width:100%; height:100%}"),
  titlePanel("OLS Community Map"),
  leafletOutput("mymap", width = "100%", height = "100%"),
  absolutePanel(
    top = 10,
    right = 10,
    selectInput(
      inputId = "cohort",
      label = "Choose the cohort you want to see:",
      choices = list(
        "OLS 1" = "1",
        "OLS 2" = "2",
        "OLS 3" = "3",
        "OLS 4" = "4",
        "OLS 5" = "5",
        "OLS 6" = "6"))
  )
)

server <- function(input, output, session) {
  output$mymap <- renderLeaflet({
    leaflet(
      df %>%
      dplyr::filter(cohort == input$cohort)
    ) %>%
    addTiles() %>%
    addMarkers(lat = ~latitude, lng=~longitude)
  })
}

shinyApp(ui, server)

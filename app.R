library(maps)
library(leaflet)
library(dplyr)
library(DT)
library(shinythemes)
library(shiny)

encoding <- getOption("shiny.site.encoding", default = "UTF-8")


inclRmd <- function(path, r_env = parent.frame()) {
  paste(
    readLines(path, warn = FALSE, encoding = encoding),
    collapse = '\n'
  ) %>%
    knitr::knit2html(
      text = .,
      fragment.only = TRUE,
      envir = r_env,
      options = "",
      stylesheet = "",
      encoding = encoding
    ) %>%
    gsub("&lt;!--/html_preserve--&gt;","",.) %>%  ## knitr adds this
    gsub("&lt;!--html_preserve--&gt;","",.) %>%   ## knitr adds this
    HTML
}


df <- read.csv('https://raw.githubusercontent.com/open-life-science/ols-program-paper/main/data/people_per_cohort.csv')

leafIcons <- iconList(
  participant = makeIcon(
    iconUrl = "https://leafletjs.com/examples/custom-icons/leaf-green.png",
    iconWidth = 38,
    iconHeight = 95,
    iconAnchorX = 22,
    iconAnchorY = 94,
    shadowUrl = "https://leafletjs.com/examples/custom-icons/leaf-shadow.png",
    shadowWidth = 50,
    shadowHeight = 64,
    shadowAnchorX = 4,
    shadowAnchorY = 62),
  mentor = makeIcon(
    iconUrl = "https://leafletjs.com/examples/custom-icons/leaf-red.png",
    iconWidth = 38,
    iconHeight = 95,
    iconAnchorX = 22,
    iconAnchorY = 94,
    shadowUrl = "https://leafletjs.com/examples/custom-icons/leaf-shadow.png",
    shadowWidth = 50,
    shadowHeight = 64,
    shadowAnchorX = 4,
    shadowAnchorY = 62),
  expert = makeIcon(
    iconUrl = "https://leafletjs.com/examples/custom-icons/leaf-orange.png",
    iconWidth = 38,
    iconHeight = 95,
    iconAnchorX = 22,
    iconAnchorY = 94,
    shadowUrl = "https://leafletjs.com/examples/custom-icons/leaf-shadow.png",
    shadowWidth = 50,
    shadowHeight = 64,
    shadowAnchorX = 4,
    shadowAnchorY = 62),
  speaker = makeIcon(
    iconUrl = "https://leafletjs.com/examples/custom-icons/leaf-orange.png",
    iconWidth = 38,
    iconHeight = 95,
    iconAnchorX = 22,
    iconAnchorY = 94,
    shadowUrl = "https://leafletjs.com/examples/custom-icons/leaf-shadow.png",
    shadowWidth = 50,
    shadowHeight = 64,
    shadowAnchorX = 4,
    shadowAnchorY = 62)
)

ui <- fixedPage(
  theme = shinytheme("cerulean"),
  tags$style(type = "text/css", "html, body {width:100%; height:100%}"),
  titlePanel("OLS Community Map"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "cohort",
                  label = "Which cohort(s) you want to see? (multiple selection possible)",
                  choices = list(
                    "OLS 1" = "1",
                    "OLS 2" = "2",
                    "OLS 3" = "3",
                    "OLS 4" = "4",
                    "OLS 5" = "5",
                    "OLS 6" = "6"),
                  multiple = TRUE,
                  selected = "1"
                  )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Map", leafletOutput("map", width = "100%", height = 800)),
        tabPanel("Table", DTOutput(outputId = "table")),
        tabPanel("About", uiOutput("about"))
      )
    )
  )
)

server <- function(input, output, session) {
  
  filter_map_data_react <- reactive({
      df %>% 
        dplyr::filter(cohort == input$cohort)
    })
  
  table_data_react <- reactive({
    df %>% 
      dplyr::filter(cohort == input$cohort)
  })
  
  output$map <- renderLeaflet({
    
  filter_map_data <- filter_map_data_react()
  
  html_legend <- "<img src='http://leafletjs.com/examples/custom-icons/leaf-green.png'>Participant<br/>
<img src='http://leafletjs.com/examples/custom-icons/leaf-red.png'>Mentor<br/>
<img src='http://leafletjs.com/examples/custom-icons/leaf-orange.png'>Expert<br/>
<img src='http://leafletjs.com/examples/custom-icons/leaf-orange.png'>Speaker" 
  
  leaflet(filter_map_data) %>%
    setView(20,1, zoom = 4) %>%
    addTiles() %>%
    addMarkers(lat = ~latitude, lng = ~longitude, icon = ~leafIcons[role]) %>%
    addControl(html = html_legend, position = "bottomleft")
  })
  
  output$table <- renderDT({
    table_data <- table_data_react()
    table_data
  })
  
  output$about <- renderUI({
    inclRmd("./about.Rmd")
  })
}

shinyApp(ui = ui, server = server)

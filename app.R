library(maps)
library(ggplot2)
library(countrycode)
library(tidyverse)
library(tidygeocoder)

# Load world map data
world_data <- ggplot2::map_data('world')
world_data <- fortify(world_data)
world_data$iso3c <- rep(NA, nrow(world_data))
world_data$iso3c <- countryname(world_data$region, destination = 'iso3c')
# head(world_data)

# Load OLS data
urlfile <- 'https://raw.githubusercontent.com/open-life-science/ols-program-paper/main/data/people.csv'
data_ols <- read.csv(urlfile)
#View(data_ols)
#str(data_ols)
data_ols$iso3c <- rep(NA, nrow(data_ols))
#View(data_ols)
data_ols$iso3c <- countryname(data_ols$country, destination = 'iso3c')
data_ols$OLS_1 <- rep(NA, nrow(data_ols))
data_ols$OLS_1 <- ifelse(data_ols$ols.1 == "", "", "OLS_1")
data_ols$OLS_2 <- rep(NA, nrow(data_ols))
data_ols$OLS_2 <- ifelse(data_ols$ols.2 == "", "", "OLS_2")
data_ols$OLS_3 <- rep(NA, nrow(data_ols))
data_ols$OLS_3 <- ifelse(data_ols$ols.3 == "", "", "OLS_3")
data_ols$OLS_4 <- rep(NA, nrow(data_ols))
data_ols$OLS_4 <- ifelse(data_ols$ols.4 == "", "", "OLS_4")
data_ols$OLS_5 <- rep(NA, nrow(data_ols))
data_ols$OLS_5 <- ifelse(data_ols$ols.5 == "", "", "OLS_5")
data_ols$OLS_6 <- rep(NA, nrow(data_ols))
data_ols$OLS_6 <- ifelse(data_ols$ols.6 == "", "", "OLS_6")

data_ols$ols_cohort <- rep(NA, nrow(data_ols))
data_ols$ols_cohort <- paste(data_ols$OLS_1,
                             data_ols$OLS_2,
                             data_ols$OLS_3,
                             data_ols$OLS_4,
                             data_ols$OLS_5,
                             data_ols$OLS_6,
                             sep=";")

data_ols_separate <- separate_rows(data_ols, 20, sep = ';')
data_ols_separate <- data_ols_separate[!(data_ols_separate$ols_cohort == ""), ]
colnames(data_ols_separate)
to_use_data_ols <- data_ols_separate[, c("X", "city", "country", "iso3c", "ols_cohort")]

df <- to_use_data_ols %>%
  geocode(city = city, method = 'osm', lat = latitude , long = longitude)

# install.packages("devtools")
# devtools::install_github("cardiomoon/editData")
# library(editData)
# result <- editData(df)

# Creating the Shiny App

library(shiny)

# Define the UI
ui = fluidPage(
  
  # App title
  titlePanel(title=h4("Geographical distribution of the OLS Community", 
                      align="center")),
  # Sidebar layout with input and output definitions
  sidebarLayout(
    # Sidebar panel for inputs 
    sidebarPanel(
      # First input: OLS Cohort
      selectInput(inputId = "ols_cohort",
                  label = "Choose the cohort you want to see:",
                  choices = list("OLS_1" = "OLS_1", 
                                 "OLS_2" = "OLS_2",
                                 "OLS_3" = "OLS_3",
                                 "OLS_4" = "OLS_4",
                                 "OLS_5" = "OLS_5",
                                 "OLS_6" = "OLS_6"))),
    # Main panel for displaying outputs
    mainPanel(plotOutput("plot2"))
  )
)

# Define the server
server = function(input, output) {
  dat <- reactive({
    test <- df[df$ols_cohort == input$ols_cohort, ]
    print(test)
    test
  })
  # Create the interactive world map
  output$plot2 <- renderPlot({
    ggplot() +
      # geom_map() function takes world coordinates as input
      # to plot world map color parameter determines the
      # color of borders in map fill parameter determines the
      # color of fill in map size determines the thickness of
      # border in map
      geom_map(
        data = world_data, map = world_data,
        mapping = aes(long, lat, map_id = region),
        color = "blue", fill= "lightblue"
      )+
      # geom_point function is used to plot scatter plot on top
      # of world map
      geom_point(
        dat(),
        mapping = aes(longitude, latitude, color = X,
                      size=X),
        alpha = 1
      ) +
      # legend.position as none removes the legend
      theme(legend.position="none")
  })
}  

# Finally, we can run our app by either clicking "Run App" in the top of our RStudio IDE, or by running
shinyApp(ui = ui, server = server)


# OLS Community Map
An interactive map of the geographical distribution of the Open Life Science (OLS) community (from OLS cohort 1 to 6), created as a project during OLS-6.

Link to the map: https://qwertyquest169.shinyapps.io/ols_community_map/

# Run the App
To run the App on your RStudio:

- Install the `Shiny` package 
```sh
install.packages("Shiny")
```

- Load the `Shiny` package
```sh
library(Shiny)
```

- Use the command `runGitHub()`
```sh
runGitHub( "ols_community_map", "SaranjeetKaur")
```

After the app is launched, you can select the cohort for which you want to see the geographical distribution from the drop down menu.

# References:
- [Leaflet for R](https://rstudio.github.io/leaflet/)
- [Interactive worldmap Shiny app](https://github.com/fverkroost/RStudio-Blogs/blob/master/interactive_worldmap_shiny_app.R)
- [Shiny reference](https://shiny.rstudio.com/reference/shiny/latest/sidebarlayout)

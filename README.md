# OLS Community Map

An interactive map of the geographical distribution of the Open Life Science (OLS) community (from OLS cohort 1 to 6), created as a project during OLS-6 by [Saranjeet Kaur](https://github.com/SaranjeetKaur)

# Installation and deployment

## Installation

- Using RStudio
    1. Install RStudio
    2. Launch RStudio
    3. Install R Shiny and some packages by running `requirements.R`

- Using conda
    1. Install conda
    2. Create conda environment using the `environment.yml` file

## Deployment locally

- Using RStudio
    1. Launch RStudio
    2. Run `app.R` script

- Using conda
    1. Activate conda environment

        ```sh
        $ conda activate ols-community-map
        ```

    2. Run `app.R` script

        ```sh
        $ Rscript app.R
        ```

The interactive map will then be available on the URL given.

## Deployment on shinyapps.io

1. Authorize account following instructions on [shinyapps.io](https://www.shinyapps.io)
2. Deploy (after launching R)

    ```sh
    library(rsconnect)
    rsconnect::deployApp('.')
    ```

# References

- [Leaflet for R](https://rstudio.github.io/leaflet/)
- [Interactive worldmap Shiny app](https://github.com/fverkroost/RStudio-Blogs/blob/master/interactive_worldmap_shiny_app.R)
- [Shiny reference](https://shiny.rstudio.com/reference/shiny/latest/sidebarlayout)

# Contributing

If you would like to contribute to this repo, please [open an issue](https://github.com/SaranjeetKaur/ols_community_map/issues/new/choose) and reach out to discuss further.

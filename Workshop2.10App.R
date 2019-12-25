library(shiny)
library(dplyr)
library(ggplot2)
library(DT)
library(shinydashboard)
library(tidyverse)
library(leaflet)
library(stringr)
library(sf)
library(here)
library(widgetframe)

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)
bangkok_shape <- here("./GIS/BMA_ADMIN_SUB_DISTRICT.shp") %>% st_read()
bangkok_shape
bangkok_shape_wgs84 <- st_transform(bangkok_shape, "+init=epsg:4326")
bins <- c(0, 100000, 1000000, 10000000, 100000000, 1000000000, Inf)
pal <- colorBin("RdYlBu", domain = bangkok_shape_wgs84$Shape_Area, 
                bins = bins)


ui <- dashboardPage(skin = "green",
  dashboardHeader(title = "BC Liquor Store prices"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Inputs", icon = icon("bar-chart-o"),
               # Input directly under menuItem
               sliderInput("priceInput", "Price", 0, 100, c(25, 40), pre = "$"),
               radioButtons("typeInput", "Product type",
                            choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                            selected = "WINE"),
               selectInput("countryInput", "Country",
                           choices = c("CANADA", "FRANCE", "ITALY"))
               
               )
      )
  ),
  dashboardBody(
    box(title = "GIS", fluidRow(bangkok_shape_wgs84 %>%
                                  mutate(popup = str_c("<strong>", SUBDISTR_1, "</strong>",
                                                       "<br/>",
                                                       "Area : ", Shape_Area) %>%
                                           map(htmltools::HTML)) %>%
                                  leaflet() %>%
                                  addTiles() %>%
                                  addPolygons(label = ~popup,
                                              fillColor = ~pal(Shape_Area),
                                              color = "#444444",
                                              weight = 1,
                                              smoothFactor = 0.5,
                                              opacity = 1.0,
                                              fillOpacity = 0.5,
                                              highlightOptions = highlightOptions(color = "white",
                                                                                  weight = 2,
                                                                                  bringToFront = TRUE),
                                              labelOptions = labelOptions(
                                                style = list("font-weight" = "normal", padding = "3px 8px"),
                                                textsize = "15px",
                                                direction = "auto")) %>%
                                  addLegend(pal = pal,
                                            values = ~Shape_Area,
                                            opacity = 0.7,
                                            title = NULL,
                                            position = "bottomright") ), offset = 0, width = 6),
    box(title = "Plot",fluidRow(plotOutput("coolplot")), offset = 0, width = 6),
    box(title = "Table",fluidRow(DT::dataTableOutput("results")), offset = 0, width = 12)
    
  )
)

server <- function(input, output) {
  # Build Sample Plot output
  # output$coolplot <- renderPlot({
  #   plot(rnorm(input$priceInput[1]))
  # })
  # Build Histogram output
  # output$coolplot <- renderPlot({
  #   ggplot(bcl, aes(Alcohol_Content)) +
  #     geom_histogram()
  # })
  # Build Histogram with Reactivity
  output$coolplot <- renderPlot({
    filtered <-
      bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput
      )
    ggplot(filtered, aes(Alcohol_Content)) +
      geom_histogram()
  })
  output$results <- DT::renderDT({
    filtered <-
      bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput
      )
    filtered
  }, options = list(pageLength=5, autowidth = TRUE))
}

shinyApp(ui = ui, server = server)



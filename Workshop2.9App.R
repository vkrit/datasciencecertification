library(shiny)
library(dplyr)
library(ggplot2)
library(DT)
library(shinydashboard)

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

ui <- dashboardPage(skin = "green",
  dashboardHeader(title="BC Liquor Store prices"),
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
    box(title = "Plot",fluidRow(plotOutput("coolplot")), offset = 0, width=12),
    box(title = "Table",fluidRow(DT::dataTableOutput("results")), offset = 0, width=12)
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



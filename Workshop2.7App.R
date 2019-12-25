library(shiny)
library(dplyr)
library(ggplot2)

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)
bcl

ui <- fluidPage(
  titlePanel("BC Liquor Store prices"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("priceInput", "Price", 0, 100, c(25, 40), pre = "$"),
      radioButtons("typeInput", "Product type",
                   choices = unique(bcl$Type),
                   selected = unique(bcl$Type)[1]),
      selectInput("countryInput", "Country",
                  choices = unique(bcl$Country))
    ),
    mainPanel(
      plotOutput("coolplot"),
      br(), br(),
      tableOutput("results")
    )
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
  output$results <- renderTable({
    filtered <-
      bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput
      )
    filtered
  })
}

shinyApp(ui = ui, server = server)



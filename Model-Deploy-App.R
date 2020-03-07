library(shiny)
library(keras)

reticulate::use_condaenv(condaenv="r-deeplearning2", 
                         conda="/Users/kris/anaconda3/bin/conda", 
                         required=TRUE)

# Load the model
model <- load_model_tf("cnn-mnist/")

# Define the UI
ui <- fluidPage(
  # App title ----
  titlePanel("Hello TensorFlow!"),
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    # Sidebar panel for inputs ----
    sidebarPanel(
      # Input: File upload
      fileInput("image_path", label = "Input a JPEG image")
    ),
    # Main panel for displaying outputs ----
    mainPanel(
      # Output: Histogram ----
      textOutput(outputId = "prediction"),
      plotOutput(outputId = "image")
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  image <- reactive({
    req(input$image_path)
    jpeg::readJPEG(input$image_path$datapath)
  })
  
  output$prediction <- renderText({
    
    img <- image() %>% 
      array_reshape(., dim = c(1, dim(.), 1))
    
    paste0("The predicted class number is ", predict_classes(model, img))
  })
  
  output$image <- renderPlot({
    plot(as.raster(image()))
  })
  
}

shinyApp(ui, server)
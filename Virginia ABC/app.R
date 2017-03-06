library(shiny)
library(tidyverse)

abc <- read_csv("abc.csv")

ui <- fluidPage(
  titlePanel("Virginia ABC Store prices"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("priceInput", "Price", min = 0, max = 100,
                  value = c(25, 40), pre = "$"),
      radioButtons("typeInput", "Product type",
                   choices = c("Mixers", "Rimmers", "Spirits", "Wine"),
                   selected = "Spirits"),
      selectInput("proofInput", "Proof",
                  choices = c("0-40", "40-80", "80-120", "120-160", "160+"))
    ),
    mainPanel(
      plotOutput("coolplot"),
      tableOutput("results")
    )
  )
)

server <- function(input, output) {
  output$coolplot <- renderPlot({
    filtered <- abc %>%
      filter(CurrentPrice >= input$priceInput[1],
             CurrentPrice <= input$priceInput[2],
             Type == input$typeInput,
             ProofBin == input$proofInput
      )
    ggplot(filtered, aes(Size)) +
      geom_histogram()
  })
}

shinyApp(ui = ui, server = server)

library(shiny)
library(ObservablePlotR)

cars <- data.frame(mtcars, car=row.names(mtcars), row.names = NULL)
units <- c("Miles per gallon" = "mpg", 
           "Kilometers per liter" = "kpl")

ui <- fluidPage(
  htmltools::HTML('<script src="https://cdn.jsdelivr.net/npm/d3"></script>'), 
  htmltools::HTML('<script src="https://cdn.jsdelivr.net/npm/@observablehq/plot"></script>'), 
  tags$h1("Example using literals as arrow functions"),
  radioButtons("units", "Units", choices=units), 
  uiOutput("carplot"))

server <- function(input, output) {
  output$carplot <- renderUI({
    mframe <- obsjs_mark(mark="frame")
    mdot <- obsjs_mark(mark="dot", 
                       data=cars, 
                       options=list(y=if(input$units=="kpl") literal("d => d.mpg*1.60934/3.78541") else "mpg", 
                                    x="disp")) 
    obsjs_plot(inputId="carplot", mdot, mframe,
               options=list(y=list(
                 label=setNames(names(units), units)[input$units],
                 tickFormat=literal("d => d3.format('0.2f')(d)"))))
  })
}


shinyApp(ui = ui, server = server)


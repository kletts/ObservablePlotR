
library(shiny)
library(ObservablePlotR)

ui <- fluidPage(
  htmltools::HTML('<script src="https://cdn.jsdelivr.net/npm/d3@7"></script>'), 
  htmltools::HTML('<script src="https://cdn.jsdelivr.net/npm/@observablehq/plot@0.6"></script>'),
  uiOutput("myplot") 
)

server <- function(input, output) { 
  output$myplot <- renderUI({ 
    obsjs_plot(inputId="myplot", 
        obsjs_mark(mark="barY", 
                   data=data.frame(x=letters[1:5], y=1:5), 
                   options=list(x="x", y="y")
                   )
        )
  })
}

shinyApp(ui, server)
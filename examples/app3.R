
library(shiny)
library(ObservablePlotR)

cars <- data.frame(mtcars, car=row.names(mtcars), row.names = NULL)

factors <- c("cyl", "vs", "am", "gear", "carb")


ui <- fluidPage(
  includeCSS("style.css"),
  htmltools::HTML('<script src="https://cdn.jsdelivr.net/npm/d3@7"></script>'), 
  htmltools::HTML('<script src="https://cdn.jsdelivr.net/npm/@observablehq/plot@0.6"></script>'),
  tags$h1("Fuel Efficiency of Cars"),
  tags$p("An implementation of the ", 
         tags$a(href="https://observablehq.com/plot/", "Observables Javascript Plot library"), 
         " in R shiny. An example applying smoothing and density plots."), 
  sliderInput("bd", label="Bandwidth", value=20, min=1, max=100, ticks=FALSE),
  selectInput("fct", label="Factor variable", choices=factors, multiple=FALSE),
  tags$p("Fuel Efficiency, Engine Displacement and Weight"),
  uiOutput("carplot")
)

server <- function(input, output) {
  output$carplot <- renderUI({ 
    mdot <- obsjs_mark(mark="dot", 
                       data=cars,
                       options=list(y="mpg", x="disp", stroke=input$fct, fill=input$fct, title="car", tip=TRUE)) 
    mframe <- obsjs_mark(mark="frame", options=list(fill='white', stroke='darkgray'))
    mdensity <- obsjs_mark(mark="density", 
                           data=cars,
                           options=list(y="mpg", x="disp", stroke=input$fct, 
                                        bandwidth=input$bd, clip=TRUE))
    mregression <- obsjs_mark(mark="linearRegressionY", 
                              data=cars, 
                              options=list(y="mpg", x="disp", stroke=input$fct, clip=TRUE))
    options <- list(height=400, 
                    width=600, 
                    color=list(legend=TRUE, scheme="Dark2"), 
                    style=list(fontFamily='Georgia'), 
                    x=list(label="Engine displacement"), 
                    y=list(label="Miles per gallon"))
    obsjs_plot(inputId="carplot", mframe, mdensity, mdot, mregression, options=options)
  })
}


shinyApp(ui = ui, server = server)



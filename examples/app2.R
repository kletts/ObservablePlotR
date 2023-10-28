
library(shiny)
library(ObservablePlotR)

cars <- data.frame(mtcars, car=row.names(mtcars), row.names = NULL)

ui <- fluidPage(
    htmltools::HTML('<script src="https://cdn.jsdelivr.net/npm/d3@7"></script>'), 
    htmltools::HTML('<script src="https://cdn.jsdelivr.net/npm/@observablehq/plot@0.6"></script>'),
    h1("Fuel Efficiency of Cars"),
    tags$p("An implementation of the ", 
           tags$a(href="https://observablehq.com/plot/", "Observables Javascript Plot library"), 
           " in R shiny"), 
    sliderInput("wt", label="Weight range", value=range(cars$wt), min=min(cars$wt), max=max(cars$wt), ticks=FALSE),
    p("Fuel Efficiency, Engine Displacement and Weight"),
    uiOutput("carplot")
)

server <- function(input, output) {
    output$carplot <- renderUI({ 
        mdot <- obsjs_mark(mark="dot", 
                        data=subset(cars, wt >= min(input$wt) & wt <= max(input$wt)), 
                        options=list(x="mpg", y="disp", fx="am", stroke="wt", fill="wt", title="car", tip=TRUE)) 
        mframe <- obsjs_mark(mark="frame")
        options <- list(height=400, width=600, color=list(legend=TRUE, scheme="Cool", domain=range(cars$wt)))
        obsjs_plot(inputId="carplot", mdot, mframe, options=options)
        })
    }


shinyApp(ui = ui, server = server)

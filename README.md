# Observable Plot

[Observable Plot](https://observablehq.com/plot) is a new Javascript plot function library.  Observable Plot is similar to GGPLOT in using the grammar of graphics syntax for constructing plots through building layers (which in observable are called `marks`).  

Observable plots are already available in {ojs} blocks in [Quarto](https://quarto.org/docs/interactive/ojs/). 

This repository includes functions which facilitate using the Observable plot library in R shiny apps, using R shiny inputs and data objects. 

Examples of using the Observable and the functions provided are available in the Examples folder. The second uses the 
`mtcars` dataset to illustrate reactive elements. 

<img src="example.png" width="400" height="400">

# Installation 

Install the latest version from github:

```
devtools::install_github("kletts/ObservablePlotR")
```

In the shiny app, in the app header include the following script src statements, these will import the libraries 
for Observable when the app is started. 

```
fluidPage(
    htmltools::HTML('<script src="https://cdn.jsdelivr.net/npm/d3"></script>'), 
    htmltools::HTML('<script src="https://cdn.jsdelivr.net/npm/@observablehq/plot"></script>'),
    ...
```

The above will import the latest version from NPM each time the app loads. This can be risky if breaking changes have been introduced, the observable plot library has been evolving significantly over the last couple of years. To import a specific version every time the app is loaded include the version number after `@` as follows: 

```
htmltools::HTML('<script src="https://cdn.jsdelivr.net/npm/d3@7.8.5"></script>')
htmltools::HTML('<script src="https://cdn.jsdelivr.net/npm/@observablehq/plot@0.6.13"></script>'),
```

Available versions: 

 - [d3](https://www.npmjs.com/package/d3?activeTab=versions)
 - [observablehq/plot](https://www.npmjs.com/package/@observablehq/plot?activeTab=versions)

# Usage

Observable plots are called in shiny using the  `uiOutput` `renderUI` function pairs. In the UI, include the plot output: 

```
ui <- fluidPage(
  htmltools::HTML('<script src="https://cdn.jsdelivr.net/npm/d3@7"></script>'), 
  htmltools::HTML('<script src="https://cdn.jsdelivr.net/npm/@observablehq/plot@0.6"></script>'),
  uiOutput("myplot") 
  )
```

In the server: 

```
server <- function(input, output) { 
  output$myplot <- renderUI({ 
    ObservablePlotR::obsjs_plot(inputId="myplot", 
      ObservablePlotR::obsjs_mark(
        mark="barY", 
        data=data.frame(x=letters[1:5], y=1:5), 
        options=list(x="x", y="y")))
    })
    }
```

# Live

Example 3 from this project are available on [ShinyLive](https://shinylive.io/r/app/#gist=2bc16189a629451bc6254bc46ca50ed4), use the editor to explore the data and charting features. 

# Arrow functions 

Javascript arrow functions can be specified in marks and options by wrapping the string in the R function `literal`. 
See Example 4 on [ShinyLive](https://shinylive.io/r/app/#gist=35fe75cec6b8764db34fc65dc26d29ce). 


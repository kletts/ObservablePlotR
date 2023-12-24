
#' Observable Plot Mark 
#' @description Takes a data frame, mark type and specification list and compiles a JSON format specification 
#' mark specification for Observable Plot JS library. 
#' @param mark Character the plot [mark](https://observablehq.com/plot/features/marks) some common ones are: 
#'  * dot: scatter plot dot, equivalent to geom_point
#'  * line: line plot, equivalent to geom_line
#'  * path: path plot, equivalent to geom_path 
#'  * barX, barY: column or bar plots in the x or y dimension, equivalent to geom_col
#'  * text: scatter plot with text marks, equivalent to geom_text
#'  * ruleX, ruleY: horizontal or vertical lines across the plot panel 
#'  * frame: outer box for the plot panel 
#'  * tickX, tickY: strokes in the x or y dimension, of fixed length
#' @param data Data frame or vector of data to be plotted (R format)
#' @param options List of specification options for the mark including: 
#'  * x axis variable `x`, 
#'  * y axis variable `y`, 
#'  * stroke color variable `stroke`, 
#'  * fill color variable `fill`, 
#'  * mark radius `r` for dot size,
#'  * faceting variable in the y dimension `fy` 
#'  * faceting variable in the x dimension `fx` 
#'  * text labels `text`
#'  * tip titles `title`
#' @return Character, the mark data and specification
#' @export
#' @examples
#' obsjs_mark("frame")  # add box to plot panel area
#' obsjs_mark("ruleY", data=0) # add x axis at y=0 
#' obsjs_mark("barY", data=data.frame(x=letters[1:5], y=1:5), options=list(x="x", y="y"))
#' obsjs_mark("line", data=data.frame(x=letters[1:5], y=1:5), options=list(x="x", y="y"), transform="regression")

obsjs_mark <- function(mark, data=NULL, options=NULL, transform=NULL) { 
  if (is.null(data) & is.null(options)) { 
    return(glue::glue("Plot.{mark}()")) 
  } else if (is.null(options)) { 
    data <- jsonlite::toJSON(data) 
    return(glue::glue("Plot.{mark}({data})")) 
  } else if (is.null(data)) {
    options  <- jsonlite::toJSON(options, auto_unbox = TRUE) 
    return(glue::glue("Plot.{mark}({options})")) 
  } else { 
    options  <- jsonlite::toJSON(options, auto_unbox = TRUE)
    if (!is.null(transform)) { 
      options <- glue::glue("Plot.{transform}({options})")
      
    }
    data <- jsonlite::toJSON(data) 
    return(glue::glue("Plot.{mark}({data}, {options})"))
  }}


#' Observable Plot
#' @description Builds a [Observable Plot](https://observablehq.com/plot/) from plot marks and a plot options list.
#' The output of this function can be called in Shiny through [shiny::renderUI] as HTML. 
#' Shiny needs to import the javascript libraries for Observables, this can be done by including the 
#' following two statements in the App UI: 
#'  * `htmltools::HTML('<script src="https://cdn.jsdelivr.net/npm/d3@7"></script>')`, 
#'  * `htmltools::HTML('<script src="https://cdn.jsdelivr.net/npm/@observablehq/plot@0.6"></script>')`,
#' @param inputId Character, unique ID for plot in Shiny
#' @param ... Plot marks as many as required, output from the [obsjs_mark]
#' @param options List of plot options
#' @return A script module containing the plot attached to the DOM at the InputId.  
#' @export
#' @examples 
#' obsjs_plot("myplot",  obsjs_mark("barY", data=data.frame(x=letters[1:5], y=1:5), options=list(x="x", y="y")))

obsjs_plot <- function(inputId,  ..., options=NULL) {   
  marks <- glue::glue_collapse(list(...), sep=", ") 
  marks <- glue::glue("[{marks}]")
  spec <- list(marks="insertmark") 
  if (is.null(options)==FALSE) { 
    spec <- append(options, spec) } 
  spec <- jsonlite::toJSON(spec, auto_unbox = TRUE) 
  spec <- sub('\\"insertmark\\"', marks, spec) 
  spec <- glue::glue('
        <script type="module">
            const {inputId}plot = Plot.plot({ spec }); 
            document.querySelector("#{inputId}").append({inputId}plot);
        </script>')  
  htmltools::HTML(as.character(spec)) } 


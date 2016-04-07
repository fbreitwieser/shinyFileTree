#' <Add Title>
#'
#' <Add Description>
#'
#' checkbox: https://www.jstree.com/api/#/?q=$.jstree.defaults.checkbox&f=$.jstree.defaults.checkbox.visible
#'
#' @import htmlwidgets
#'
#' @export
shinyFileTree <- function(data, plugins = NULL, ...,
                          plugin_opts = list(
                            checkbox = list(visible = TRUE,three_state = TRUE, whole_node = TRUE, cascade = TRUE),
                            types = list(file=list(icon="glyphicon glyphicon-flash"))
                          ), 
                          width = NULL, height = NULL) {

  # forward options using x
  x <- list(
    core = list( data = data )
  )
  if (!is.null(plugins)) x$plugins <- I(plugins)
  
  for (plugin_name in names(plugin_opts)[names(plugin_opts) %in% plugins])
    x[[plugin_name]] <- plugin_opts[[plugin_name]]
  
  # create widget
  htmlwidgets::createWidget(
    name = 'jstree',
    x,
    width = width,
    height = height,
    package = 'shinyFileTree'
  )
}

#' Shiny bindings for mywidget
#'
#' Output and render functions for using shinyFileTree within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a mywidget
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name shinyFileTree-shiny
#'
#' @export
shinyFileTreeOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'jstree', width, height, package = 'shinyFileTree')
}

#' @rdname shinyFileTree-shiny
#' @export
renderShinyFileTree <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, shinyFileTreeOutput, env, quoted = TRUE)
}

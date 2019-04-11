#' <Add Title>
#'
#' <Add Description>
#'
#' checkbox: https://www.jstree.com/api/#/?q=$.jstree.defaults.checkbox&f=$.jstree.defaults.checkbox.visible
#'
#' @import htmlwidgets
#'
#' @export
shinyFileTree <- function(data, plugins = NULL, 
                          core_opts = list(check_callback = TRUE),
                          is_directory = FALSE,
                          default_plugin_opts = list(
                            checkbox = list(visible = TRUE,three_state = TRUE, whole_node = TRUE, cascade = TRUE),
                            contextmenu = list(select_node = TRUE, show_at_node = TRUE),
                            types = list(file=list(icon="glyphicon glyphicon-flash"))
                          ),
                          ...,
                          width = NULL, height = NULL) {

  if (isTRUE(is_directory)) {
    mydir <- data
    data <- list(text=data_dir,
                 state=list(opened=TRUE), 
                 children=shinyFileTree::get_list_from_directory(data_dir, max_depth=1, hide_files=TRUE, show_hidden_files = FALSE))
  }
  # forward options using x
  x <- list(
    core = c(list( data = data), 
             core_opts )
  )
  if (!is.null(plugins)) x$plugins <- I(plugins)
  
  overwriteDefaults <- function (default_opts, set_opts) {
    stopifnot(is.list(default_opts))
    if (length(set_opts) == 0)
      return(default_opts)
    for (my_opt in names(set_opts)) 
      default_opts[[my_opt]] <- set_opts[[my_opt]]
    
    default_opts
  }
  
  dots_list <- list(...)
  for (plugin_name in intersect(names(default_plugin_opts), plugins))
    x[[plugin_name]] <- overwriteDefaults(default_plugin_opts[[plugin_name]],
                                          dots_list[[plugin_name]])
  
  # create widget
  htmlwidgets::createWidget(
    name = 'jstree',
    x,
    width = width,
    height = height,
    package = 'shinyFileTree'
  )
}

updateShinyFileTree <- function(session, inputId, data) {
  message("updating shiny file tree..");
  session$sendInputMessage(inputId, list(data=data));
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
shinyFileTreeOutput <- function(outputId, width = '100%', height = 'auto'){
  htmlwidgets::shinyWidgetOutput(outputId, 'jstree', width, height, package = 'shinyFileTree')
}

#' @rdname shinyFileTree-shiny
#' @export
renderShinyFileTree <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, shinyFileTreeOutput, env, quoted = TRUE)
}

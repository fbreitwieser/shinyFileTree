#' Create a Shiny File Tree
#'
#' This creates a widget with a shiny file tree. The widget is based on jstree,
#' and the R implementation has the same implementation as jstree. For more 
#' details, please refer to https://www.jstree.com/docs/config/ and
#' https://www.jstree.com/api/#/?q=$.jstree.defaults
#'
#'
#' @param data 
#' @param plugins 
#' @param opts 
#' @param is_directory 
#' @param default_plugin_opts 
#' @param ... 
#' @param width 
#' @param height 
#'
#' @import htmlwidgets
#'
#' @export
shinyFileTree <- function(data, plugins = NULL, 
                          opts = shinyFileTreeOpts(),
                          default_plugin_opts = list(
                            checkbox = list(visible = TRUE,three_state = TRUE, whole_node = TRUE, cascade = TRUE),
                            contextmenu = list(select_node = TRUE, show_at_node = TRUE),
                            search = list(
                              case_sensitive=FALSE,
                              show_only_matches = TRUE
                            ),
                            types = list(file=list(icon="glyphicon glyphicon-flash"))
                          ),
                          ...,
                          is_directory = FALSE,
                          directory_depth = NULL,
                          directory_hide_files = FALSE,
                          width = NULL, height = NULL) {

  if (isTRUE(is_directory)) {
    mydir <- data
    data <- list(text=mydir,
                 state=list(opened=TRUE), 
                 children=get_list_from_directory(mydir, max_depth=directory_depth, hide_files=directory_hide_files, show_hidden_files = FALSE))
  }
  # forward options using x
  x <- list(
    core = c(list( data = data), 
             opts )
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


#' Function to set options for shinyFileTree
#' 
#' Use as argument to opts parameter of shinyFileTree
#'
#' @param animation the open / close animation duration in milliseconds - set this to false to disable the animation (default is 200)
#' @param multiple a boolean indicating if multiple nodes can be selected (default FALSE).
#' @param force_text Force node text to plain text (and escape HTML) (default FALSE).
#' @param dblclick_toggle Should the node be toggled if the text is double clicked (default TRUE).
#' @param check_callback
#' @param themes.name the name of the theme to use (if left as FALSE the default theme is used)
#' @param themes.url the URL of the theme's CSS file, leave this as false if you have manually included the theme CSS (recommended). You can set this to true too which will try to autoload the theme.
#' @param themes.dir the location of all jstree themes - only used if url is set to TRUE
#' @param themes.dots a boolean indicating if connecting dots are shown.
#' @param themes.icons a boolean indicating if node icons are shown.
#' @param themes.stripes a boolean indicating if the tree background is striped.
#' @param themes.variant a string (or boolean false) specifying the theme variant to use (if the theme supports variants), e.g. 'large'.
#' @param themes.reposonsive a boolean specifying if a reponsive version of the theme should kick in on smaller screens (if the theme supports it). Defaults to FALSE.
#' @param ... Additional jstree options
shinyFileTreeOpts <- function(
    animation = 200,
    multiple = FALSE,
    force_text = FALSE,
    dblclick_toggle = TRUE,
    check_callback = TRUE,
    themes.name = FALSE,
    themes.url = FALSE,
    themes.dir = FALSE,
    themes.dots = TRUE,
    themes.icons = TRUE,
    themes.stripes = TRUE,
    themes.variant = FALSE,
    themes.reposonsive = FALSE, 
    ...) {

  argg <- c(as.list(environment()), list(...))
  nn <- strsplit(names(argg), ".", fixed = T)
  res1 <- list()
  for (i in seq_along(argg)) {
    n <- nn[[i]]
    if (length(n) == 1) {
      res1[[n]] <- argg[[i]]
    } else if (length(n) == 2) {
      if (!is.list(res1[[n[1]]])) {
        res1[[n[1]]] <- list()
      }
      res1[[n[1]]][[n[2]]] <- argg[[i]]
    } else {
      stop("maximum list depth is 2 - error w/ property ",names(argg)[i])
    }
  }
  res1
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

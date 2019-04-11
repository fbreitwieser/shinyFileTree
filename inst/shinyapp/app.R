library(shiny)
library(shinyFileTree)

ui = shinyUI(fluidPage(
  textInput("dir",label = "Directory", value = system.file(package="shinyFileTree")),
  textInput("ext",label = "Extension", value = ""),
  checkboxGroupInput("shiny_opts",
                     sort(c("hide_empty_dirs", "hide_files")),
                     label = "Options for directory listing"),
  numericInput("max_depth",label = "Maximum depth of directory listing", value = 10, min = 1, max = 10),
  checkboxGroupInput("plugins","Plugins for jstree", sort(c("checkbox",
                 "contextmenu",
                 "dnd",
                 "massload",
                 "search",
                 "sort",
                 "state",
                 "types",
                 "unique",
                 "wholerow",
                 "changed",
                 "conditionalselect"
  )), selected = c("checkbox", "types"), inline = TRUE),
  shinyFileTreeOutput('jstree'),
  "Selected files:",
  verbatimTextOutput("msg")
))

server = function(input, output, session) {

  get_list <- function(dir, max_depth, shiny_opts) {
    list(text=dir,
         type="directory",
         state=list(opened=TRUE),
         children=get_list_from_directory(dir,
                        #file_ext = input$ext, 
                                         max_depth = max_depth,
                                         hide_empty_dirs = "hide_empty_dirs" %in% shiny_opts,
                                         hide_files = "hide_files" %in% shiny_opts))
  }

  output$jstree <- renderShinyFileTree(
    shinyFileTree(get_list(input$dir, input$max_depth, input$shiny_opts),
                  plugins = input$plugins)
  )
  output$msg <- renderPrint( {
    input$jstree_selected
  })

  observeEvent(input$jstree_dblclick, {
    message(input$jstree_selected)
    updateShinyFileTree(session, "jstree", get_list(input$jstree_selected, input$max_depth, input$shiny_opts));
  })
}

shinyApp(ui = ui, server = server)

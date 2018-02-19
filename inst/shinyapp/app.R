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

server = function(input, output) {
  output$jstree <- renderShinyFileTree(
    shinyFileTree(list(text=input$dir,
                       type="directory",
                       state=list(opened=TRUE),
                       children=get_list_from_directory(input$dir,
                                                        #file_ext = input$ext, 
                                                        max_depth = input$max_depth,
                                                        hide_empty_dirs = "hide_empty_dirs" %in% input$shiny_opts,
                                                        hide_files = "hide_files" %in% input$shiny_opts)),
                  plugins = input$plugins)
  )
  output$msg <- renderPrint( {
    input$jstree_selected
  })
}

shinyApp(ui = ui, server = server)

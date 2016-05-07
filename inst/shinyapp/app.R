library(shiny)
library(shinyFileTree)

ui = shinyUI(fluidPage(
  textInput("dir",label = "Directory", value = system.file(package="shinyFileTree")),
  textInput("ext",label = "Extension", value = ""),
  checkboxInput("hide_empty_dirs",label = "Hide empty directories", value = TRUE),
  checkboxGroupInput("plugins","Plugins", sort(c("checkbox",
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
                                                        file_ext = input$ext, 
                                                        hide_empty_dirs = input$hide_empty_dirs)),
                  plugins = input$plugins)
  )
  output$msg <- renderPrint( {
    input$jstree_selected
  })
}

shinyApp(ui = ui, server = server)

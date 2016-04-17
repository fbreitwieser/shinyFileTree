library(shiny)
library(shinyFileTree)

ui = shinyUI(fluidPage(
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
  )), selected = c("checkbox", "types")),
  verbatimTextOutput("msg"),
  "",
  shinyFileTreeOutput('jstree')
))

server = function(input, output) {
  output$jstree <- renderShinyFileTree(
    shinyFileTree(get_list_from_directory(system.file(package="shinyFileTree")),
                  plugins = input$plugins)
  )
  output$msg <- renderPrint( {
    input$jstree_selected
  })
}

shinyApp(ui = ui, server = server)

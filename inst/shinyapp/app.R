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
  shinyFileTreeOutput('jstree')
))

server = function(input, output) {
  output$jstree <- renderShinyFileTree(
    shinyFileTree(get_list_from_directory(system.file(package="shinyFileTree")),
                  plugins = input$plugins)
  )
}

shinyApp(ui = ui, server = server)

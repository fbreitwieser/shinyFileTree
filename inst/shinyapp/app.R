library(shiny)
library(shinyFileTree)

ui = shinyUI(fluidPage(
  titlePanel("shinyFileTree demo"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput("multiple", "Allow selection of multiple files", value=T),
      checkboxGroupInput("themes", label = "Theme options", choices = c("icons", "stripes", "responsive"), selected = c("icons")),
      sliderInput("Animation", label="animation (ms)", 200, min=0, max=2000, step = 50),
      textInput("themes.variant", label = "Theme variant (try 'large')"),
      checkboxGroupInput("plugins","Plugins for jstree", sort(c("checkbox",
                 #"contextmenu",
                 "dnd",
                 #"massload",
                 #"search",
                 "sort",
                 #"state",
                 "types",
                 "unique",
                 "wholerow"#,
                 #"changed",
                 #"conditionalselect"
        )), selected = c("checkbox", "types"), inline = FALSE)),
    mainPanel(
      wellPanel(
        textInput("dir",label = "Directory", value = system.file(package="shinyFileTree")),
        checkboxGroupInput("shiny_opts",
                     sort(c("hide_empty_dirs", "hide_files")),
                     label = "Options for directory listing")
      ),
      shinyFileTreeOutput('jstree'),
      "Selected files:",
      verbatimTextOutput("msg")
))))

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
    shinyFileTree(get_list(input$dir, 5, input$shiny_opts),
                  opts = shinyFileTreeOpts(check_callback = TRUE,
                                                animation = input$animation,
                                                multiple = input$multiple,
                                                themes.icons = "icons" %in% input$themes,
                                                themes.stripes = "stripes" %in% input$themes,
                                                themes.variant = input$themes.variant,
                                                themes.responsive = "reposonsive" %in% input$themes),
                  plugins = input$plugins)
  )
  output$msg <- renderPrint( {
    input$jstree_selected
  })

  observeEvent(input$jstree_dblclick, {
    message("doubleclicked: ", input$jstree_selected)
  #  updateShinyFileTree(session, "jstree", get_list(input$jstree_selected, input$max_depth, input$shiny_opts));
  })
}

shinyApp(ui = ui, server = server)

# shinyFileTree

R/Shiny widget for jstree with a focus on extensibility and close connection to the javascript library. Most useful for selecting files or browsing directory trees. The library [shinyTree](https://github.com/shinyTree/shinyTree) provides a more feature-rich wrapper to jstree.

Creating a widget:
```
shinyFileTree(system.file(package="shinyFileTree"), 
              is_directory = TRUE,
              plugins = c("checkbox"),
              multiple = TRUE,
              opts = shinyFileTreeOpts(icons = TRUE)
)
```

Demo:
```
shiny::runApp(system.file("shinyapp", package="shinyFileTree"))
```
![Screenshot 2019-04-12 14 27 49](https://user-images.githubusercontent.com/516060/56058356-2b21eb00-5d2f-11e9-9aae-84f676e64cf8.png)

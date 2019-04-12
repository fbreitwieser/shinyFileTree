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
![Screenshot 2019-04-12 14 07 47](https://user-images.githubusercontent.com/516060/56057257-5ce58280-5d2c-11e9-8dbe-9fc65c3a69b3.png)


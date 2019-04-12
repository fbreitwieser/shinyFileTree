# shinyFileTree

R/Shiny widget for jstree. 

![Screenshot 2019-04-12 14 07 47](https://user-images.githubusercontent.com/516060/56057257-5ce58280-5d2c-11e9-8dbe-9fc65c3a69b3.png)


Creating a widget:
```
shinyFileTree(system.file(package="shinyFileTree"), 
              is_directory = TRUE,
              opts = shinyFileTreeOpts(themes.checkbox = TRUE, multiple = TRUE)
)
```

Demo:
```
shiny::runApp(system.file("shinyapp", package="shinyFileTree"))
```

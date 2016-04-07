
get_list_from_directory <- function(my_dir) {
  all_dirs <- list.dirs(my_dir, recursive = FALSE, full.names=TRUE)
  all_dirs_short <- sub(".*/","",all_dirs)
  all_files <- list.files(my_dir)
  all_files <- all_files[!all_files %in% all_dirs_short]
  if (length(all_files) == 0 && length(all_dirs) == 0)
    return()
  
  c(
    lapply(all_dirs,function(x)
      list(text=sub(".*/","",x),
           type='directory',
           children=get_list_from_directory(x))),
    lapply(all_files,function(x) list(text=x,type='file')))

}

startsWith <- function(x,y) {
  stopifnot(length(y) == 1)
  grepl(sprintf("^%s",y),x)
}

get_list_from_directory_ajax <- function(my_dir,open_path) {
  all_dirs <- list.dirs(my_dir, recursive = FALSE, full.names=TRUE)
  all_files <- list.files(my_dir)
  all_files <- all_files[!all_files %in% sub(".*/","",all_dirs)]
  if (length(all_files) == 0 && length(all_dirs) == 0)
    return()
  
  if (startsWith(open_path,my_dir)) {
  c(
    lapply(all_dirs,function(x)
      list(text=sub(".*/","",x),
           children=get_list_from_directory_ajax(x,open_path))),
    lapply(all_files,function(x) list(text=x,type='file')))
  } else {
    c(
      lapply(all_dirs,function(x)
        list(text=sub(".*/","",x), children="loading ...")),
      lapply(all_files,function(x) list(text=x,type='file')))
  }

}


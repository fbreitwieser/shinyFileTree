
get_list_from_directory <- function(my_dir, pattern = NULL, hide_empty_dirs = FALSE, state = NULL) {
  all_dirs <- list.dirs(my_dir, recursive = FALSE, full.names=TRUE)
  all_dirs_short <- sub(".*/","",all_dirs)
  all_files <- list.files(my_dir, pattern = pattern)
  all_files <- all_files[!all_files %in% all_dirs_short]
  
  if (length(all_files) == 0 && length(all_dirs) == 0)
    return()
 
  dir_res <- lapply(all_dirs,function(x) {
      children <- get_list_from_directory(x, pattern, hide_empty_dirs, state)
      if (hide_empty_dirs && (is.null(children) || length(children) == 0))
        return(NULL)
      list(text = basename(x),
           type = 'directory',
           state = state,
           children = children)
      }) 
  child_res <- lapply(all_files,function(x) list(text = x, type = 'file'))
  
  c(dir_res[!sapply(dir_res,is.null)], child_res)
}

is_empty <- function(x) {
  is.null(x) | (is.list(x) && x$type == "directory" && is.null(x$children) && length(x) == 2)
}

prune_empty_directories <- function(x) {
  stop("Function not working")
  x <- Filter(Negate(is_empty), x)
  lapply(x, function(y) if (is.list(y)) prune_empty_directories(y) else y)
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


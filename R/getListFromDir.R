
get_list_from_directory <- function(my_dir, pattern = NULL, 
                                    hide_empty_dirs = FALSE, 
                                    hide_files = FALSE,
                                    state = NULL, max_depth = NULL) {
  all_dirs <- list.dirs(my_dir, recursive = FALSE, full.names=TRUE)
  all_dirs_short <- sub(".*/","",all_dirs)
  all_files <- list.files(my_dir, pattern = pattern)
  all_files <- all_files[!all_files %in% all_dirs_short]
  
  if (length(all_files) == 0 && length(all_dirs) == 0)
    return()
 
  dir_res <- lapply(all_dirs,function(x) {
    name <- basename(x)  
    if (is.null(max_depth) || max_depth >= 1) {
      if (!is.null(max_depth))
        max_depth <- max_depth - 1
      
      children <- get_list_from_directory(x, pattern, 
                                          hide_empty_dirs=hide_empty_dirs, 
                                          hide_files=hide_files,
                                          state=state, max_depth = max_depth)
      if (hide_empty_dirs && (is.null(children) || length(children) == 0))
        return(NULL)
      if (!is.null(attr(children,"dirname", exact = T))) {
        name <- sprintf("%s (%s)",name, attr(children,"dirname", exact = T))
        attr(children,"dirname") <- NULL
      }
      if (!is.null(max_depth) && max_depth == 0) {
        children <- NULL
      }
    } else {
      children <- NULL
    }
    
    
    list(text = name,
         type = 'directory',
         state = state,
         children = children)
  }) 
  
  dir_res <- dir_res[!sapply(dir_res,is.null)]
  if (isTRUE(hide_files)) {
    n_dirs <- ifelse(length(all_dirs)==1, "1 folder", paste(length(all_dirs),"folders"))
    n_files <- ifelse(length(all_files)==1, "1 file", paste(length(all_files),"files"))
    if (length(all_files) > 0 && length(all_dirs) > 0) {
      attr(dir_res, "dirname") <- sprintf("%s, %s", n_dirs, n_files)  
    } else if (length(all_dirs) > 0) {
      attr(dir_res, "dirname") <- n_dirs
    } else if (length(all_files) > 0) {
      attr(dir_res, "dirname") <- n_files
    }
    
    dir_res
  } else {
    child_res <- lapply(all_files,function(x) list(text = x, type = 'file'))
    c(dir_res, child_res)
  }
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



noNULLs <- function(l) {
    l[!sapply(l, is.null)]
}

add_s <- function(n) {
  ifelse(n > 1, "s", "")
}

dir_desc <- function(n_dirs, n_files) {
  msg <- ifelse(n_dirs > 0, sprintf("%s folder%s", n_dirs, add_s(n_dirs)), "")
  if (n_files > 0) {
    file_msg <- sprintf("%s file%s", n_files, add_s(n_files))
    if (n_dirs > 0) { 
      msg <- paste0(msg, ", ", file_msg) 
    } else {
      msg <- file_msg
    }
  }
  msg
}

#' Get a file and directory list for ShinyFileTree
#' @export
get_list_from_directory <- function(my_dir, pattern = NULL, 
                                    hide_empty_dirs = FALSE, 
                                    show_hidden_files = FALSE,
                                    show_dir_info = FALSE,
                                    state = NULL, 
                                    simplify = FALSE,
                                    max_depth = 10) {
  all_dirs <- list.dirs(my_dir, recursive = FALSE, full.names=TRUE)
  all_files <- list.files(my_dir, pattern = pattern, full.names = TRUE)
  if (!isTRUE(show_hidden_files)) {
    all_dirs <- all_dirs[!grepl("/\\.", all_dirs)]
    all_files <- all_files[!grepl("/\\.", all_files)]
  }
  all_files <- all_files[!all_files %in% all_dirs]
  
  if (length(all_files) == 0 && length(all_dirs) == 0)
    return()
 
  all_dirs <- lapply(all_dirs,function(x) {
    name <- basename(x)  
    if (is.null(max_depth) || max_depth >= 1) {
      if (!is.null(max_depth))
        max_depth <- max_depth - 1
      
      children <- get_list_from_directory(x, pattern, 
                                          hide_empty_dirs=hide_empty_dirs, 
                                          show_hidden_files=show_hidden_files,
                                          show_dir_info=show_dir_info,
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
    
    if (!isTRUE(simplify)) {
    noNULLs(list(text = basename(name),
         type = 'directory',
         state = state,
         children = children))
    } else {
      c(x, children)
    }
  }) 
  
  #all_dirs <- all_dirs[!sapply(all_dirs,is.null)]
  if (isTRUE(simplify)) {
    all_dirs <- unlist(all_dirs)
  } else {
    all_files <- lapply(basename(all_files),function(x) list(text = x, type = 'file'))
  }

  res <- c(all_dirs, all_files)
  if (isTRUE(show_dir_info)) {
    msg <- dir_desc(length(all_dirs), length(all_files))
    attr(res, "dirname") <- msg
  }
  res
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


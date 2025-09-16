#===================================================================================
# Filename : init.R
# Use      : Convenient functions
# Author   : Tomas Sou
# Created  : 2025-08-29
# Updated  : 2025-09-12
#===================================================================================
# Notes
# na
#===================================================================================
# Updates
# na
#===================================================================================
#' Generate source label
#'
#' Generate a source label with file path and run time.
#' In interactive sessions, this function uses `rstudioapi` to get the file path.
#' It is designed to work in a script file in RStudio when running interactively.
#' It will return empty when running in the console.
#'
#' @param span <num> Number of lines: either 1 or 2
#' @param omit [optional] <chr> Text to omit from the label
#' @returns A label with source file path and run time
#' @export
#' @examples
#' label_src(1)
label_src = function(span=2,omit=""){
  loc_src = getwd()
  if(interactive()) loc_src = rstudioapi::getActiveDocumentContext()$path |> dirname()
  fname_src = knitr::current_input() |> gsub(".rmarkdown",".qmd",x=_)
  if(interactive()) fname_src = rstudioapi::getActiveDocumentContext()$path |> basename()
  fpath_src  = file.path(loc_src,fname_src)
  tz = paste0("Run: ",format(Sys.time(),usetz=T))
  lab1 = paste0("Source:",fpath_src,"\n",tz) |> gsub(omit,"",x=_)
  lab2 = paste0("Source:",loc_src,"/\n",fname_src,"\n",tz) |> gsub(omit,"",x=_)
  out = lab1
  if(span==2) out = lab2
  return(out)
}

#===================================================================================
# library(patchwork)

#' Add source label to ggplot
#'
#' Generate and add a source label with file path and run time to a ggplot object.
#'
#' @param plt A ggplot object
#' @param span <num> Number of lines: either 1 or 2
#' @param size <num> Text size
#' @param col <chr> Colour of the text
#' @param lab [optional] <chr> Custom label to use instead of the default
#' @param omit [optional] <chr> Text to omit from the label
#' @returns A ggplot object with the added label
#' @export
ggsrc = function(plt,span=2,size=8,col="grey55",lab=NULL,omit=""){
  lab1 = label_src(1) |> gsub(omit,"",x=_)
  lab2 = label_src(2) |> gsub(omit,"",x=_)
  lab3 = lab1
  if(span==2) lab3 = lab2
  if(!is.null(lab)) lab3 = lab
  out = patchwork::wrap_elements(plt) +
    patchwork::plot_annotation(
      caption = lab3,
      theme = theme(plot.caption = element_text(colour=col,size=size))
    )
  return(out)
}

#===================================================================================
#' Copy to destination
#'
#' Copy file to destination and rename if desired.
#'
#' @param fpath File path of the source file
#' @param tag [optional] <chr> Tag to the filename
#' @param des Destination folder
#' @export
fc = function(fpath,tag="-",des="/home/souto1/Documents/"){
  # Copy
  fname = basename(fpath)
  fstem = tools::file_path_sans_ext(fname)
  fext = tools::file_ext(fname)
  file.copy(fpath,des,overwrite=T)
  # Rename
  today = format(Sys.time(),"%y%m%d")
  fname_to = paste0(fstem,tag,today,".",fext)
  fpath1 = file.path(des,fname)
  fpath2 = file.path(des,fname_to)
  file.rename(fpath1,fpath2)
}

#===================================================================================
# library(flextable)

#' flextable wrapper
#'
#' Sugar function for default flextable output.
#'
#' @param d A data frame
#' @param fnote [optional] <chr> Footnote
#' @param ttl [optional] <chr> Title
#' @returns A flextable object
#' @export
#' @examples
#' mtcars |> ft()
ft = function(d,fnote=NULL,ttl=NULL){
  out = d %>%
    flextable::flextable() |>
    flextable::autofit() |>
    flextable::colformat_double(digits=3) |>
    flextable::add_footer_lines(fnote) |>
    flextable::add_header_lines(ttl)
  return(out)
}

#===================================================================================
#' kable wrapper
#'
#' Sugar function for default kable output.
#'
#' @param d A data frame
#' @param fnote [optional] <chr> Footnote
#' @param cap [optional] <chr> Caption
#' @returns A kable object
#' @export
#' @examples
#' mtcars |> kbl2()
kbl2 = function(d,fnote=NULL,cap=NULL){
  d %>%
    kableExtra::kbl(caption=cap,digits=3) |>
    kableExtra::kable_classic(full_width=F) |>
    kableExtra::footnote(fnote,general_title="")
}

#===================================================================================
#' Set colour scales
#'
#' Set colour scales for the desired number of colours.
#'
#' @param n <num> Number of colours to output
#' @param show <lgl> `TRUE` to show the output colours
#' @returns Hex code of colours that can be used for plotting
#' @export
#' @examples
#' hcln(6,FALSE)
#' hcln(8,TRUE)
hcln = function(n,show=FALSE){
  hues = seq(15, 375, length=n+1)
  out = hcl(h=hues, c=100, l=65)[1:n]
  if(show) scales::show_col(out)
  return(out)
}

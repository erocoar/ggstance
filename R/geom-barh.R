#' Bars, rectangles with bases on y-axis
#'
#' Horizontal version of \code{\link[ggplot2]{geom_bar}()}.
#' @inheritParams ggplot2::geom_bar
#' @inheritParams ggplot2::geom_point
#' @export
geom_barh <- function(mapping = NULL, data = NULL,
                      stat = "counth", position = "stackv",
                      ...,
                      width = NULL,
                      binwidth = NULL,
                      na.rm = FALSE,
                      show.legend = NA,
                      inherit.aes = TRUE) {

  if (!is.null(binwidth)) {
    warning("`geom_barh()` no longer has a `binwidth` parameter. ",
      "Please use `geom_histogramh()` instead.", call. = "FALSE")
    return(geom_histogramh(mapping = mapping, data = data,
      position = position, width = width, binwidth = binwidth, ...,
      na.rm = na.rm, show.legend = show.legend, inherit.aes = inherit.aes))
  }

  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomBarh,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      width = width,
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname ggstance-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomBarh <- ggproto("GeomBarh", GeomRect,
  required_aes = c("x", "y"),

  setup_data = function(data, params) {
    data$width <- data$width %||%
      params$width %||% (resolution(data$y, FALSE) * 0.9)
    transform(data,
      xmin = pmin(x, 0), xmax = pmax(x, 0),
      ymin = y - width / 2, ymax = y + width / 2, width = NULL
    )
  },

  draw_panel = function(self, data, panel_params, coord, width = NULL) {
    # Hack to ensure that width is detected as a parameter
    ggproto_parent(GeomRect, self)$draw_panel(data, panel_params, coord)
  }
)

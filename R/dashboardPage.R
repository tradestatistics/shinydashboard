#' Dashboard page
#'
#' This creates a dashboard page for use in a Shiny app.
#'
#' @param header A header created by \code{dashboardHeader}.
#' @param sidebar A sidebar created by \code{dashboardSidebar}.
#' @param body A body created by \code{dashboardBody}.
#' @param title A title to display in the browser's title bar. If no value is
#'   provided, it will try to extract the title from the \code{dashboardHeader}.
#' @param skin A color theme. One of \code{"blue"}, \code{"black"},
#'   \code{"purple"}, \code{"green"}, \code{"red"}, or \code{"yellow"}.
#'   Light themes are allowed if using a theme other than the shinydashboard theme.
#' @param theme CSS files to be used in place of the shinydashboard AdminLTE
#'   theme. Typically, this will be \code{c("AdminLTE.css", "_all-skins.css")}.
#'   CSS files should be placed in \code{www/}.
#' @param sidebar_mini If \code{TRUE}, enables the mini sidebar when the sidebar
#'   is collapsed.
#'
#' @seealso \code{\link{dashboardHeader}}, \code{\link{dashboardSidebar}},
#'   \code{\link{dashboardBody}}.
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#' # Basic dashboard page template
#' library(shiny)
#' shinyApp(
#'   ui = dashboardPage(
#'     dashboardHeader(),
#'     dashboardSidebar(),
#'     dashboardBody(),
#'     title = "Dashboard example"
#'   ),
#'   server = function(input, output) { }
#' )
#' }
#' @export
dashboardPage <- function(header, sidebar, body, title = NULL,
  skin = c("blue", "black", "purple", "green", "red", "yellow"),
  theme = NULL,
  sidebar_mini = FALSE) {

  tagAssert(header, type = "header", class = "main-header")
  tagAssert(sidebar, type = "aside", class = "main-sidebar")
  tagAssert(body, type = "div", class = "content-wrapper")
  skins <- c("blue", "black", "purple", "green", "red", "yellow")
  if (!is.null(theme)) skins <- c(skins, paste0(skins, "-light"))
  skin <- match.arg(skin, skins)

  extractTitle <- function(header) {
    x <- header$children[[2]]
    if (x$name == "span" &&
        !is.null(x$attribs$class) &&
        x$attribs$class == "logo" &&
        length(x$children) != 0)
    {
      x$children[[1]]
    } else {
      ""
    }
  }

  title <- title %OR% extractTitle(header)

  theme <- if (!is.null(theme)) {
    tagList(
      lapply(theme, function(css) {
        tags$head(tags$link(rel="stylesheet", type="text/css", href = css))
      })
    )
  }

  content <- div(class = "wrapper",
    if (!is.null(theme)) theme,
    header,
    sidebar,
    body
  )

  # if the sidebar has the attribute `data-collapsed = "true"`, it means that
  # the user set the `collapsed` argument of `dashboardSidebar` to TRUE
  collapsed <- findAttribute(sidebar, "data-collapsed", "true")

  addDeps(
    tags$body(
      # the "sidebar-collapse" class on the body means that the sidebar should
      # the collapsed (AdminLTE code)
      # "sidebar-mini" class on the body enables the mini collapsed sidebar
      class = paste0("skin-", skin, if (collapsed) " sidebar-collapse",
                     if (sidebar_mini) " sidebar-mini"),
      style = "min-height: 611px;",
      shiny::bootstrapPage(content, title = title)
    ),
    include_adminLTE_css = is.null(theme)
  )
}

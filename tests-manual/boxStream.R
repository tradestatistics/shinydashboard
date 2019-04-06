library(shiny)
library(shinydashboard)

ui <- dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    dashboardBody(
        valueBoxOutput("value_box"),
        infoBoxOutput("info_box"),
        infoBox("Title", 45, "Subtitle", icon = icon("bar-chart"), inputId = "testbox"),
        valueBox(inputId = "someid", 45, "Subtitle", icon = icon("dashboard")),
        valueBox(45, "Subtitle", "green", icon = icon("r-project"), inputId = "singlebox")
    ),
    title = "Test Streaming"
)

server <- function(input, output, session) {
  value <- reactiveVal(45)
  output$value_box <- renderValueBox({
      valueBox(value(), "Subtitle", icon = icon("dashboard"))
  })
  output$info_box <- renderInfoBox({
      infoBox("Title", value(), "Subtitle", icon = icon("bar-chart"))
  })
    observe({
        invalidateLater(3000)
        isolate(value(value() + 1))
        print(paste("Updated value:", value()))
        updateBoxValues(
          session,
          someid = value(),
          testbox = value()
        )
        updateBoxValue(session, "singlebox", value() - 45)
        ## Errors
        # updateBoxValues(session, 12)
        ## Warning: Error in updateBoxValues: All arguments must be named.
        ## Please specify inputId and value pairs as inputId = value.
    })
}

# Run the application
shinyApp(ui = ui, server = server)

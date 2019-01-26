library(shiny)
library(ggplot2)  # for the diamonds dataset

library(DT)

markup<-read_rds('highmarkHosp')


ui <- fluidPage(
  title = "Examples of DataTables",
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.dataset === "markup"',
        checkboxGroupInput("show_vars", "Columns in markup to show:",
                           names(markup), selected = names(markup))
   
      )
    ),
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel("markup", DT::dataTableOutput("mytable1"))
      )
    )
  )
)

server <- function(input, output) {
  
  # choose columns to display
  markup2 = markup[sample(nrow(markup), 100), ]
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(markup2[, input$show_vars, drop = FALSE])
  })
  
  # sorted columns are colored now because CSS are attached to them
  output$mytable2 <- DT::renderDataTable({
    DT::datatable(markup, options = list(orderClasses = TRUE))
  })
  
  # customize the length drop-down menu; display 5 rows per page by default
  output$mytable3 <- DT::renderDataTable({
    DT::datatable(markup, options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
  })
  
}

shinyApp(ui, server)

highmarkup_tab <-tabItem(
    tabName = "highMarkup",
    fluidRow(
      
      box( 
        width=12,
        
  
  title = "Top 100 High Charge to Cost Ratio Hospitals in USA",
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.dataset === "markup"',
        checkboxGroupInput("show_vars", "sorting Variables:",
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
)
)

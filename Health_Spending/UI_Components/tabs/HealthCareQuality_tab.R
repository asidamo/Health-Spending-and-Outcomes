HealthCareQuality_tab<-tabItem(
  tabName = "HealthcareQI",
  fluidRow(
    
    box( 
      width=12,
      
     
        # select input
        # Select variable for y-axis
        column(6,    selectInput(inputId = "QI_y", 
                                 label = "Y-axis:",
                                 choices = colnames(healthcareQI)[4:8],
                                 selected=colnames(healthcareQI)[4])),
        
        
     
        # Show a plot of the generated distribution
        mainPanel(
          width=12,
          plotlyOutput("QI_barPlot",height = '400px')
        )
      )
    )
  )

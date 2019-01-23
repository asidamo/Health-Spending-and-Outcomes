HCareUtilization_tab<-tabItem(
  tabName = "HCareUtilization",
  
  
  fluidRow(
    
    box( 
      width=12,
      
      
        
        
        column(3,           numericInput('util_Year','Selected Year',
                                         min(utilization$Year),max(utilization$Year),value=2011))
        
        ,
        
        
        # Select variable for y-axis
        
        column(6, selectInput(inputId = "util_y",
                              label="y-axis",
                              choices = colnames(utilization)[4:8],
                              selected = colnames(utilization)[7]))
        ,
        
     
            # Show a plot of the generated distribution
        mainPanel(
          width=12,
          plotlyOutput("barPlot",height = '400px')
          
        )
      )
    )
  )

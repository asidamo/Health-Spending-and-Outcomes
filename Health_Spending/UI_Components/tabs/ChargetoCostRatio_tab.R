ChargetoCostRatio_tab<-tabItem(
  tabName = "CCR",
  
  fluidRow(
    
    box( 
      width=12,
      
    
        column(6, sliderInput(inputId = "ratio",
                              label = "Value of Ratios",
                              min(ccr_df$AverageCCR),max(ccr_df$AverageCCR),
                              value=c(0,2) )),
        
        # select input
        # Select variable for y-axis
        column(3,selectInput(inputId = "ccr_y", 
                             label = "Charge to Cost Ratio:",
                             choices = 'AverageCCR' ))
        ,
       
        
        
        # Show a plot scatter plot for States hospitals charge to cost ratios
        mainPanel(
          width=12,
          plotlyOutput("scatterPlot",height = '500px')
          
        )
      )
    )
  )


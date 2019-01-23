HospitalPrices_tab<-tabItem(
  tabName = "HospitalPrices",
  fluidRow(
    
    box( 
      width=12,
      
     
        # select input
        # Select variable for y-axis
        column(6,selectInput(inputId = "hospitalCharges_y", 
                             label = "Y-axis:",
                             choices = colnames(hospitalPrices)[2:5],
                             selected=colnames(hospitalPrices)[1]))
        ,
    
        
        
        
        
        # Show a plot bar plot for States hospitals charge to cost ratios
        mainPanel(
          width=12,
          plotlyOutput("hospitalCharges_barPlot",height = '400px')
          
        )
      )
    )
  )

HealthCareResources_tab<-tabItem(
  tabName = "HCareResources",
  fluidRow(
    
    box( 
      width=12,
      
    
        
        column(6,selectInput('hresources_var',"y_axis",
                             choices = hresourcevars,
                             selected= hresourcevars[2]))
        ,
    
        
        
        
        
        
        # Show a plot of the generated distribution
        mainPanel(
          width=12,
          plotlyOutput("hresources_barPlot",height = '400px')
        )
      )
    )
  )

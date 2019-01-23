NHEPERCAPITA_tab<-tabItem(
  tabName = "NHEperCapita",
  fluidRow(
    box(width = 10,
    

                      
                      column(4,                sliderInput('NHEpercapita_year','Years',
                                                        min(healthExp$year),max(healthExp$year),value=c(2000,2016))),

                     
                     # Outputs
                     mainPanel(
                       width = 12,
                                plotlyOutput(outputId = "NHEPercapita_lineplot")
                                
                     )
      )
    )    
  )
  



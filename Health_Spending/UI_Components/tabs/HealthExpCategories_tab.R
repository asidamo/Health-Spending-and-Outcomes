HealthExpCategories_tab<-tabItem(
  tabName = "HealthExpCat",
  fluidRow(
    
    box( 
      width=12,
      

        
        column(4, checkboxGroupInput(inputId = "HealthExpCat_country",
                                     label = "CountryName",
                                     choices = HECcountries,
                                     selected = HECcountries[1]) ),
        
        # select input
        # Select variable for y-axis
        column(4,  selectInput(inputId = "HealthExpCat_y", 
                               label = "Y-axis:",
                               choices = colnames(HealthExpCat)[3:7],
                               selected =colnames(HealthExpCat)[3])),
       
        
        column(6,sliderInput("HealthExpCat_year", "Years",
                             min(HealthExpCat$year), max(HealthExpCat$year),
                             value = c(2000, 2016))
        ),
        
        
        
        # Show a plot of the generated distribution
        mainPanel(
          width=12,
          plotlyOutput("HealthExpCat_linePlot",height = '400px')
          
        )
      )
    )
  )





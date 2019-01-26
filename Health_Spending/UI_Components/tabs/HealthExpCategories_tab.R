HealthExpCategories_tab<-tabItem(
  tabName = "HealthExpCat",
  fluidRow(
    
    box( 
      width=12,
      
        column(3, height='10px',checkboxGroupInput(inputId = "HealthExpCat_country",
                                     label = "Country Name",
                                     choices = HECcountries,
                                     selected = HECcountries[6])),
        
        # select input
        # Select variable for y-axis
        column(4,height='10px',  selectInput(inputId = "HealthExpCat_y", 
                               label = "Spending Categories:",
                               choices = colnames(HealthExpCat)[3:8],
                               selected =colnames(HealthExpCat)[7])),
       
        
        column(5,sliderInput("HealthExpCat_year", "Years",
                             min(HealthExpCat$year),max(HealthExpCat$year),
                             value = c(2000, 2016),sep= "",step = 1)),
        
        
        
        # Show a plot of the generated distribution
        mainPanel(
          width=12,
          plotlyOutput("HealthExpCat_linePlot",height = '375px')
          
        )
      )
    )
  )





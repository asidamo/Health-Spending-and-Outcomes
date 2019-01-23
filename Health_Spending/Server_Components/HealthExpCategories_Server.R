
HealthExpCategories_Server<-function(input,output,Session){
  
    output$HealthExpCat_linePlot <- renderPlotly({ 
      
      
     HealthExpCat<-HealthExpCat%>%
          filter(country %in% input$HealthExpCat_country,year>=input$HealthExpCat_year[1] & year<=input$HealthExpCat_year[2])
        
        
        if (input$HealthExpCat_y=='PerCapitaPharmaExp'){
          title_var='Per Capita Pharmaceutical Spending Trend USA vs OECD Countries'
        } else {
          title_var='Share of Health Expenditure by categories USA vs OECD Countries'
        }
        
        if (input$HealthExpCat_y=='PerCapitaPharmaExp'){
          ylabel='Pharmaceutical Spending in $US'
        } else {
          ylabel='percentage share of NHE'
        }
        
        
        p<-ggplot(HealthExpCat,aes_string(x='year',y=input$HealthExpCat_y,col= HealthExpCat$country))+
          geom_line(size=2)+
          labs(title=title_var,x='year',y=ylabel)+
          theme(plot.title = element_text(face='bold',hjust = 0.5))
        
        # convert the plot to interactive with plotly
        ggplotly(p)
        
      } )
    
  }

HealthExpCategories_Server<-function(input,output,Session){
  
    output$HealthExpCat_linePlot <- renderPlotly({ 
      
      
     HealthExpCat<-HealthExpCat%>%
          filter(country %in% input$HealthExpCat_country,year>=input$HealthExpCat_year[1] & year<=input$HealthExpCat_year[2])
        
     if (input$HealthExpCat_y=='percapitaHealthExp'){
       title_var='Per Capita Health Spending Trend USA vs OECD Countries'
        
        }else if (input$HealthExpCat_y=='PerCapitaPharmaExp'){
          title_var='Per Capita Pharmaceutical Spending Trend USA vs OECD Countries'
        } else if (input$HealthExpCat_y=='CurativeRehabCare') {
          title_var='Share of Curative and Rehabilitative Care in Health Spending'
        }else if (input$HealthExpCat_y=='PreventiveCare'){
          title_var='Share of Preventive Care in Health Spending'
        }else if (input$HealthExpCat_y=='Medicalgoods'){
          title_var='Share of Medical Goods in Health Spending'
          }else {
          title_var='Share of Administrative Cost in Health Spending'
        }
        
        
     if (input$HealthExpCat_y=='percapitaHealthExp'){
       ylabel='Health Spending in dollars' 
        }else if (input$HealthExpCat_y=='PerCapitaPharmaExp'){
          ylabel='Pharmaceutical Spending in dollars'
        } else {
          ylabel='percentage of total health spending'
        }
        
        
        p<-ggplot(HealthExpCat,aes_string(x='year',y=input$HealthExpCat_y,col= HealthExpCat$country))+
          geom_line(size=2)+
          labs(title=title_var,x='year',y=ylabel,colour='')+
          theme(plot.title = element_text(face='bold',hjust = 0.5))
        
        # convert the plot to interactive with plotly
        ggplotly(p)
        
      } )
    
  }
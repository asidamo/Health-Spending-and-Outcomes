HealthCareQuality_Server<-function(input,output,Session){
  # Define server logic required to draw bar plot
  
  output$QI_barPlot <- renderPlotly({ 
    
    
    healthcareQuality_df<-healthcareQI%>%
     select_('Country','Periods',QI_y=input$QI_y) %>%
      filter(!is.na(QI_y))
    
    
    if(input$QI_y=='WAITGEAP'){
      title_var='Waiting time more than 4 weeks to see a specialist'
    } else if (input$QI_y=='RHPTIPAT'){
      title_var='Patients Reported Enough time during Consultation'
    }else if (input$QI_y=='COSKCOST'){
      title_var='Consultation skipped due to costs'
    } else if (input$QI_y=='MTSKCOST'){
      title_var='Medical tests, treatment or follow-up skipped due to costs'
    } else {
      title_var='Prescribed medicines skipped due to costs'
    }
    
    
    # add text output that defines the Indicators used 
    
    p<-ggplot(healthcareQuality_df, aes(Country)) +   
      geom_bar(aes(y=QI_y,fill =QI_y), stat="identity") +
      guides(fill=FALSE,color=FALSE) +
      theme(axis.text.x = element_text(angle=45, vjust=0.6,size = 13,face='bold'))+
      labs(title=title_var,x='',y='rate per 100 patients') +
      theme(plot.title = element_text(face='bold',hjust = 0.5))
    
    ggplotly(p)
  } )
}

  
  
  
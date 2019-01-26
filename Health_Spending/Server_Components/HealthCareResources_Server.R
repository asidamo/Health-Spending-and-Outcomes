HealthCareResources_Server<-function(input,output,Session){
  # Define server logic required to draw bar plot
  
  output$hresources_barPlot <- renderPlotly({ 
    
    
    HealthResources<-HealthResources%>%
      filter(var %in% input$hresources_var)
    
    
    if(input$hresources_var=='CT Scanners'){
      title_var=paste(input$hresources_var,'Per million population in 2015')
    } else if  (input$hresources_var=='MRI'){
      title_var=paste(input$hresources_var,'Per 1 000 population in 2015')
    } else {
      title_var=paste(input$hresources_var,'Density per 1 000 population (head counts) in 2015')
    }
    
    
    if(input$hresources_var=='CT Scanners') {
      col_var='#C62F4B'
    }else if (input$hresources_var=='MRI'){
      col_var="#09557F"
    } else if (input$hresources_var=='Active Physcians'){
      col_var="#79c36a"
    }else {
      col_var="#D6604D"
      
    }
    
    
    # add text output that defines the Indicators used 
    
    p<- ggplot(HealthResources, aes(x=Country)) +   
      geom_bar(aes(y=Value),fill = col_var, stat="identity") +
      guides(fill=FALSE,color=FALSE) +
      theme(axis.text.x = element_text(angle=90, vjust=0.6,size = 13,face='bold'))+
      labs(title=title_var,x='',y=paste('number of',input$hresources_var)) +
      theme(plot.title = element_text(face='bold',hjust = 0.5))
    
    ggplotly(p)
    
  } )
}
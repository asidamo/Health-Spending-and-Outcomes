HospitalPrices_Server<-function(input,output,Session){
  # Define server logic required to draw bar plot
  
  output$hospitalCharges_barPlot <- renderPlotly({ 
    
    
    if(input$hospitalCharges_y=='AveragePricePerAppendectomy'){
      title_var='Average Price per Appendectomy in 2016'
    } else if (input$hospitalCharges_y=='AveragePricePerCaesareanSection'){
      title_var='Average Price per Caesarean Section in 2016'
    }else if (input$hospitalCharges_y=='PricePerNormalDelivery in 2016'){
      title_var='Price per Normal Delivery in 2016'
    } else {
      title_var='Average Price per MRI Exam in 2016'
    }
    
    
    p<-ggplot(data=hospitalPrices,aes_string(x='Country'))+
      geom_bar(aes_string(y=input$hospitalCharges_y,fill='Country'),stat="identity") +
      guides(fill=FALSE,color=FALSE) +
      theme(axis.text.x = element_text(angle=0, vjust=0.6,size = 12))+
      labs(title=title_var,x='',y='Average Charge in $')+
      theme(plot.title = element_text(face='bold',hjust = 0.5))
    
    # convert the plot to interactive with plotly
    ggplotly(p)
    
  } )
  
}
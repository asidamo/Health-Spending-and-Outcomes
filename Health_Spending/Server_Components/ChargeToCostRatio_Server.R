ChargeToCostRatio_Server<-function(input,output,Session){
  # Define server logic required to draw scatter plot
  
  output$scatterPlot <- renderPlotly({ 
    
    data<-ccr_df%>%
      filter(AverageCCR>=input$ratio[1] & AverageCCR<=input$ratio[2],STATE!='Total' )
    
    
    p<-ggplot(data=data,aes_string(x='STATE',y=input$ccr_y,col= 'STATE'))+
      geom_point(size=data$AverageCCR)+
      guides(fill=FALSE,color=FALSE)+
      theme(axis.text.x = element_text(angle=90, vjust=0.6,size = 12))+
      labs(title='Hospital Markups By States in USA 2016',x='',y='Average Charge to cost ratio')+
      theme(plot.title = element_text(face='bold',hjust = 0.5))
    
    # convert the plot to interactive with plotly
    ggplotly(p)
    
  } )
}
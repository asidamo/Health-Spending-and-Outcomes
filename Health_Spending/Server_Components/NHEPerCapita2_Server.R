
NHEPerCapita2_Server<-function(input,output,Session){
  output$NHEPercapita_lineplot <- renderPlotly({
  
   healthExp<-healthExp%>%
    filter(country=='USA' ,year>=input$NHEpercapita_year[1] & year<=input$NHEpercapita_year[2])
  
  
        # create plot from filtered data
        p<-ggplot(healthExp,aes(x = year, y = percapitaHealthExp,col=country)) +
          geom_line(color = 'red',size=2) +
          geom_line(aes(y=OECDAverage),color='blue',size=2)+
          theme(text = element_text(size=10),axis.text.x = element_text(angle = 45, hjust = 1)) +
          ggtitle('Per Capita Health Spending  USA vs OECD Average Trend')+
          theme(plot.title = element_text(face='bold',hjust = 0.5))
        
        ggplotly(p)
  
  
  })
}
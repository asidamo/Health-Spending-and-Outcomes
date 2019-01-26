HCareUtilization_Server<-function(input,output,Session){
  # Define server logic required to draw bar plot
  
    output$barPlot <- renderPlotly({ 
      
      barplotdata<-utilization%>%
        filter(Year %in% input$util_Year)%>%
        select_('Country','Year',util_y=input$util_y) %>%
        filter(!is.na(util_y))
    
        
      

      
         
      if (input$util_y=='BreastCancerScreening'){
        ylabel=utilmeasures[1]
      } else if ( input$util_y=='CurativeCareAverageLengthofStay'){
        ylabel=utilmeasures[2]
      } else if(input$util_y=='CaesareanSection'){
        ylabel="procedures per 1000 live births"
      } else if (input$util_y=='Doctorsconsultations'){
        ylabel=utilmeasures[4]
      } else {
        ylabel=utilmeasures[5]
        
      }
      
      
      if (input$util_y=='BreastCancerScreening'){
        title_var='Breast Cancer Screening'
      } else if ( input$util_y=='CurativeCareAverageLengthofStay'){
        title_var='Curative Care Average Length of Stay'
      } else if(input$util_y=='CaesareanSection'){
        title_var='Caesarean Section'
      } else if (input$util_y=='Doctorsconsultations'){
        title_var='Doctors consultations (in all settings)'
      } else {
        title_var="MRI Exams, total"
      }
      
      
      # plot here ggplot 
      
      p<- ggplot(barplotdata, aes(x=Country)) +   
        geom_bar(aes(y=util_y,fill=Country),stat="identity") +
        guides(fill=FALSE,color=FALSE) +
        theme(axis.text.x = element_text(angle=90, vjust=0.6,size = 13,face='bold'))+
        labs(title=title_var,x='',y=ylabel)+
        theme(plot.title = element_text(face='bold',hjust = 0.5))
      
    # convert to plotly  
      ggplotly(p)
      
    } )
  }
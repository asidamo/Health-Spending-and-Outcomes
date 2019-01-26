HighMarkupHospitals_Server<-function(input,output,Session){
  # Define server logic required to draw bar plot
  
  output$mytable1<-renderDataTable({
  # choose columns to display
  markup2 = markup[sample(nrow(markup), 100), ]
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(markup2[, input$show_vars, drop = FALSE])
  })
  
  })
}

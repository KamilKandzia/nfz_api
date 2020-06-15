# Module server function
oneDivision_server <- function(input, output, session, Suggestions, clicks,Id049, dose, daterange1, NFZdivision, dictType) {
  
  ns = session$ns
  
  server_legend<- reactive({input$legends}) 
  server_label<- reactive({input$labels}) 
  
  observeEvent(input$analyseOneDivision,{
    
      req(Suggestions())
      
      load("dfEmpty.RData")
      
      foreach(k=Suggestions()) %do%{
        
        NFZdivision<-concatString(NFZdivision())
        total<-searchNFZ(Id049(), NFZdivision, "province", k, daterange1(), dose(), dictType, "provisions",total)
    }
    
    total1<-total
    
    ##RENDER TABLE
    output$tableOneDivision <- renderDT(
      total, option = list(lengthChange = FALSE, scrollX = TRUE)
    )
    
    
    ##################
    for(i in c(1:nrow(total))){
      total[i,"label"]<-paste(total$`medicine-product`[i]," ",total$dose[i])
    }
    
    pieee<-total[,c("label", "quantity")]
    colnames(pieee) <- c("name", "value")
    
    stat<-aggregate(. ~ name, data = pieee, FUN = sum);

    
    renderPieChart(div_id = "pieChartOneDivisionDose", data = stat,show.legend = as.logical(server_legend()), show.label = as.logical(server_label()))
    
    ####################
    for(i in c(1:nrow(total1))){
      total1[i,"label"]<-paste(total1$`medicine-product`[i])
    }
    
    pieee<-total1[,c("label", "quantity")]
    colnames(pieee) <- c("name", "value")
    
    stat<-aggregate(. ~ name, data = pieee, FUN = sum);
    
    renderPieChart(div_id = "pieChartOneDivisionWithoutDose", data = stat,show.legend = as.logical(server_legend()), show.label = as.logical(server_label()))
    
    
    
    output$vbox <- renderbs4ValueBox({
      bs4ValueBox(
        value = pieee[which.max(pieee$value),1],
        subtitle = paste0("The highest sales: ",max(pieee$value)),
        status = "primary",
        icon = "shopping-cart")
    })
  })
  
}
# Module server function
ageGroup_server <- function(input, output, session, Suggestions, agegroupButton,Id049, dose, daterange1, dictType) {
  
  ns = session$ns
  
  server_legend<- reactive({input$legends_group}) 
  server_label<- reactive({input$labels_group}) 
  
  observeEvent(input$ageGroupButton,{
    
    req(Suggestions())
    load("dfEmpty.RData")
    
    withProgress(message = 'Making API GET content', value = 0, {
      
      foreach(k=Suggestions()) %do%{
        
        for(i in c(1:7)){
          
          incProgress(1/(length(Suggestions())*7), detail = "Age group request")
          
          AgeGroup<-concatString(i)
          
          total<-searchNFZ(Id049(), AgeGroup, "ageGroup", k, daterange1(), dose(), dictType, "provisions", total, i)
        }
      }  
      
    })
    
    ##END OF FOR
    
    for(i in c(1:nrow(total))){
      total[i,"Pack*Quantity"]<-(as.numeric( sub("\\D*(\\d+).*", "\\1", total$pack[i]))*total$quantity[i])
    }
    
    
    output$tbl1<- renderDT(
      total, options = list(lengthChange = FALSE, scrollX = TRUE)
    )
    
    total1<-dplyr::select(total, "medicine-product", "Pack*Quantity","AgeGroup")
    
    output$plt1<- renderPlot({
      
      total1[1] <- lapply(total1[1], as.factor)
      total1[3] <- lapply(total1[3], as.factor)
      
      ggplot(total1, aes(x=AgeGroup, y=`Pack*Quantity`, fill=total1$`medicine-product`)) +
        geom_bar(stat="identity", position="dodge") +
        scale_fill_discrete(name="Medicine product", labels=levels(total1$`medicine-product`))+theme(legend.position="bottom")
    })
    
    
    #renderBarChart
    
    colnam<-unique(total1$`medicine-product`)
    rownam<-unique(total1$AgeGroup)
    
    barChartData<-barChartSelect(colnam, rownam, total1)

    renderBarChart(div_id = "testAge1", grid_left = '1%', direction = "vertical",
                   data = barChartData,axis.x.name = "Age group",font.size.axis.y = 12,font.size.axis.x = 12,axis.y.name = "Pack*Quantity",show.legend = as.logical(server_legend()))
    
    #renderPieChart
    
    by_cyl<-total[,c(1,ncol(total))]
    
    market_global <- aggregate(`Pack*Quantity` ~ `medicine-product`, data = by_cyl, FUN = sum);
    
    pieee<-as.data.frame(market_global)
    colnames(pieee) <- c("name", "value")
    
    renderPieChart(div_id = "testAge", data = pieee,show.legend = as.logical(server_legend()), show.label = as.logical(server_label()))
  })
  
  
  
}
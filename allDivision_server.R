# Module server function
allDivision_server <- function(input, output, session, Suggestions, allSuggestion,Id049, dose, daterange1, dictType) {
  
  ns = session$ns
  
  server_legend<- reactive({input$legends_all}) 
  server_label<- reactive({input$labels_all}) 
  
  
  observeEvent(input$analyseAllDivision,{
    #Suggestion field could not be empty
    req(Suggestions())
    
    load("dfEmpty.RData")
    
    withProgress(message = 'Making API GET content', value = 0, {
    
      foreach(k=Suggestions()) %do%{
        
        for(i in c(1:16)){
          incProgress(1/(length(Suggestions())*16), detail = "NFZ division")
          
          NFZdivision<-concatString(i)
          total<-searchNFZ(Id049(), NFZdivision, "province", k, daterange1(), dose(), dictType, "provisions", total, i)
        }
      }
    })
    
    ########
    for(i in c(1:nrow(total))){
      total[i,"label"]<-paste(total$`medicine-product`[i]," ",total$dose[i])
    }
    
    pieee<-total[,c("label", "quantity")]
    colnames(pieee) <- c("name", "value")
    
    pieee<-aggregate(value~name, data = pieee, FUN = sum)
    
    
    renderPieChart(div_id = "pieChartAllDivisionWithDose", data = pieee, show.legend = as.logical(server_legend()), show.label = as.logical(server_label()))
    ##########
    
    for(i in c(1:nrow(total))){
      total[i,"Pack*Quantity"]<-(as.numeric( sub("\\D*(\\d+).*", "\\1", total$pack[i]))*total$quantity[i])
    }
    
    
    output$tbl <- renderDT(
      total, options = list(lengthChange = FALSE, scrollX = TRUE))
    
    total1<-dplyr::select(total, "medicine-product", "Pack*Quantity","NFZdivision")
    
    output$barChartGGPLOTallDivision <- renderPlot({
      
      total1[1] <- lapply(total1[1], as.factor)
      total1[3] <- lapply(total1[3], as.factor)
      
      ggplot(total1, aes(x=NFZdivision, y=`Pack*Quantity`, fill=total1$`medicine-product`)) +
        geom_bar(stat="identity", position="dodge") +
        scale_fill_discrete(name="Medicine product", labels=levels(total1$`medicine-product`))+theme(legend.position="bottom")
    })
    
    
    #renderBarChart
    
    colnam<-unique(total1$`medicine-product`)
    rownam<-unique(total1$NFZdivision)
    
    barChartData<-barChartSelect(colnam, rownam, total1)
    
    renderBarChart(div_id = "barChartE2ChartallDivision", grid_left = '1%', direction = "vertical",
                   data = barChartData,axis.x.name = "NFZ division",font.size.axis.y = 12,font.size.axis.x = 12,axis.y.name = "Pack*Quantity",show.legend = as.logical(server_legend()))
    
    #renderPieChart
    by_cyl<-total[,c(1,ncol(total))]
    
    market_global <- aggregate(`Pack*Quantity` ~ `medicine-product`, data = by_cyl, FUN = sum);
    
    pieee<-as.data.frame(market_global)
    colnames(pieee) <- c("name", "value")
    renderPieChart(div_id = "pieChartAllDivisionWithoutDose", data = pieee,show.legend = as.logical(server_legend()), show.label = as.logical(server_label()))
    
    #renderBoxes
    output$vboxAllDivHighest <- renderbs4ValueBox({
      bs4ValueBox(
        value = pieee[which.max(pieee$value),1],
        subtitle = paste0("The highest sales: ",max(pieee$value)),
        status = "primary",
        icon = "cart-plus")
    })
    
    output$vboxAllDivLowest <- renderbs4ValueBox({
      bs4ValueBox(
        value = pieee[which.min(pieee$value),1],
        subtitle = paste0("The highest sales: ",min(pieee$value)),
        status = "danger",
        icon = "shopping-cart")
    })
    
  })
  
  
}
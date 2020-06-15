# Module server function
yearlyProvision_server <- function(input, output, session, Suggestions, allSuggestion,Id049, dose, daterange1, dictType) {
  
  ns = session$ns
  
  server_legend<- reactive({input$legends_year}) 
  server_label<- reactive({input$labels_year}) 
  
  
  observeEvent(input$analyseYearly,{
    
    req(Suggestions())
    
    load("YearlyProvisionEmpty.RData")
    
    withProgress(message = 'Making API GET content', value = 0, {
    
      foreach(k=Suggestions()) %do%{
        
        for(i in c(1:16)){
          incProgress(1/(length(Suggestions())*16), detail = "NFZ division")
          
          NFZdivision<-concatString(i)
          req_parsed<-searchNFZ(Id049(), NFZdivision, "province", k, daterange1(), dose(), dictType, "yearly-provisions", total=NULL, i)
          req_parsed$data[,"NFZdivision"]<-i
          req_parsed$data[,"Product"]<-k
          keks<-rbind(keks, req_parsed$data)
          }
      }
    })

    output$tbl_yearly <- renderDT(
      keks, options = list(lengthChange = FALSE, scrollX = TRUE)
    )
    

    #renderBarChart: Quantity
    XD<-agreggateTableYearlyProvisions(keks, "quantity")

    renderBarChart(div_id = "test1_yearly", grid_left = '1%', direction = "vertical",
                    data = XD,axis.x.name = "year",axis.y.name = "quantity",show.legend = as.logical(server_legend()))
  
    ############################ Table
    XD[nrow(XD) + 1,]=round((XD[2,]-XD[1,])/XD[1,]*100, digits=2)
    rownames(XD)[3] <-"Change in % by year"

    XDE<-XD
    
    output$tbl_yearly_values <- renderDT(
      XDE, options = list(lengthChange = FALSE, scrollX = TRUE))
    
    output$vbox_year <- renderbs4ValueBox({
      bs4ValueBox(
        value = colnames(XD[which.max(XDE[3,])]),
        subtitle = paste0("The highest sales year by year %: ", round(max(XDE[3,]), digits=2)),
        status = "primary",
        icon = "shopping-cart")})
    
    #renderBarChart: Refund
    XD<-agreggateTableYearlyProvisions(keks, "refund")
    
    renderBarChart(div_id = "test_yearly", grid_left = '1%', direction = "vertical",
                   data = XD,axis.x.name = "year",axis.y.name = "refund",show.legend = as.logical(server_legend()))
    
    ##############################
    
    total1<-dplyr::select(keks, "year", "quantity","NFZdivision","Product")
    
    total2017<-total1[total1$year==2017,2:4]
    total2018<-total1[total1$year==2018,2:4]
       
    output$plt_yearly2017 <- renderPlot({
         
        total2017[2] <- lapply(total2017[2], as.factor)
        total2017[3] <- lapply(total2017[3], as.factor)
         
         ggplot(total2017, aes(x=NFZdivision, y=`quantity`, fill=`Product`)) +
           geom_bar(stat="identity", position="dodge") +
           scale_fill_discrete(name="Medicine product", labels=levels(total2017$`Product`))+theme(legend.position="bottom")
       })
    
    output$plt_yearly2018 <- renderPlot({
      
      total2018[2] <- lapply(total2018[2], as.factor)
      total2018[3] <- lapply(total2018[3], as.factor)
      
      ggplot(total2018, aes(x=NFZdivision, y=`quantity`, fill=`Product`)) +
        geom_bar(stat="identity", position="dodge") +
        scale_fill_discrete(name="Medicine product", labels=levels(total2018$`Product`))+theme(legend.position="bottom")
    })
    
      
  #   ##PIE PLOT
  #   
  #   by_cyl<-total[,c(1,ncol(total))]
  #   
  #   market_global <- aggregate(`Pack*Quantity` ~ `medicine-product`, data = by_cyl, FUN = sum);
  #   
  #   pieee<-as.data.frame(market_global)
  #   colnames(pieee) <- c("name", "value")
  #   renderPieChart(div_id = "test_yearly", data = pieee,show.legend = as.logical(server_legend()), show.label = as.logical(server_label()))
  })
  
  
}
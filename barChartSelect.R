barChartSelect = function(colnam, rownam, total1){
  
  market_global <- aggregate(`Pack*Quantity` ~ ., data = total1, FUN = sum);
  
  barChartData<-setNames(data.frame(matrix(ncol = length(colnam), nrow = length(rownam))), colnam)
  
  barChartData[is.na(barChartData)] <- 0
  
  foreach(i=colnam) %do%{
    
    foreach(k=rownam) %do%{
      
      if(length(market_global[which(market_global[,1]==i & market_global[,2]==k),3])>0){
        barChartData[k,i]=market_global[which(market_global[,1]==i & market_global[,2]==k),3]}
      
    }
  }
  
  return(barChartData)
}
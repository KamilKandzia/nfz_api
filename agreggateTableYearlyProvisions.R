agreggateTableYearlyProvisions = function(inputTable, by_name){
  
  colnam<-unique(inputTable$`Product`)
  rownam<-unique(inputTable$`year`)
  
  if(by_name=="quantity"){
    market_global <- aggregate(quantity~Product+year, data = inputTable, FUN = sum)
  }else{
    market_global <- aggregate(refund~Product+year, data = inputTable, FUN = sum) 
  }
  
  outputTable<-setNames(data.frame(matrix(ncol = length(colnam), nrow = length(rownam))), colnam)
  row.names(outputTable)<-rownam
  
  outputTable[is.na(outputTable)] <- 0
  
  foreach(i=colnam) %do%{
    
    foreach(k=rownam) %do%{
      
      if(length(market_global[which(market_global[,1]==i & market_global[,2]==k),3])>0){
        outputTable[`k`,`i`]=market_global[which(market_global[,1]==i & market_global[,2]==k),3]}
      
    }
  }
  
  outputTable<-outputTable[2017:2018,]
  
  outputTable<-as.data.frame(outputTable)
  row.names(outputTable)<-rownam
  colnames(outputTable)<-colnam

  return(outputTable)
}

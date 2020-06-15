searchNFZ = function(Id049, NFZdivision, groupPaste, k, daterange1, dose, dictType, typeOperation, total=NULL, i=NULL){
  
  exec1<-paste0("https://api.nfz.gov.pl/app-stat-api-ra/", typeOperation, "?", groupPaste, "=", NFZdivision,"&dateFrom=", as.character(daterange1[[1]]),"&dateTo=",as.character(daterange1[[2]]),"&", as.character(dictType$get(Id049)), "=",k,"&page=1&limit=25&format=json&api-version=1.0")
  exec1<-URLencode(exec1)
  req_parsed<-fromJSON(content(GET(exec1), "text"))
  
  print(req_parsed)
  
  if(!is.null(req_parsed$data$sums$quantity)){
      
      if((req_parsed$data$sums$quantity)>0){
        xxx<-modTable(req_parsed, dose)
        xxx[,as.character(dictType$get(groupPaste))]<-i
        total<-rbind(total, xxx)}
    
  }else{
    total<-req_parsed
  }

  return(total)
}
modTable = function(req_parsed, dose){
  
  xxx<-req_parsed$data$data[,-1]
  
  if (dose!= ""){
    pos<-which(xxx[,4]==dose)
    xxx<-xxx[pos,]
  }
  
  return(xxx)
}
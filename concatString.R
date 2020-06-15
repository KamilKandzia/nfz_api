concatString = function(i){
  
  if(as.numeric(i)<=9){
    NFZdivision<-paste0("0", i)
  }else{
    NFZdivision<-paste0(i)
  }
  
  return(NFZdivision)
}
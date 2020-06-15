myFunction = function(currentFib, currentChoise){
  
  exec1<-paste0("https://api.nfz.gov.pl/app-stat-api-ra/",currentChoise(),"?name=", currentFib(), "&page=1&limit=25&format=json&api-version=1.0")
  exec1<-URLencode(exec1)
  
  req_parsed<-fromJSON(content(GET(exec1), "text"))
  
  return(req_parsed)
}
  
server <- function(input, output, session) {
  
  
  useSweetAlert()
  
  server_sugg<- reactive({input$Suggestions})  
  server_ageBttn<- reactive({input$agegroupButton}) 
  server_divBttn<- reactive({input$clicks}) 
  server_choice<- reactive({input$Id049}) 
  server_data<- reactive({input$daterange1}) 
  server_dose<- reactive({input$dose}) 
  server_NFZdivision<- reactive({input$NFZdivision})
  server_all<- reactive({input$allSuggestion}) 
  currentFib<- reactive({input$nameMedicineSubstance})

  
  dictType <- dict(list("active-substances" = "activeSubstance", "medicine-products" = "medicineProduct", "province"="NFZdivision", "ageGroup"="AgeGroup"))
  
  output$ui <- renderUI({
    if (is.null(input$nameMedicineSubstance))
      return()
    
    req_parsed<-myFunction(currentFib, server_choice)
    
    pickerInput("Suggestions", "Suggestions for Medicine or Active Substance",
                choices = req_parsed$data,
                multiple = TRUE,
                selected = req_parsed$data[1],
                choicesOpt = list(
                  content = stringr::str_replace_all(stringr::str_wrap(req_parsed$data, width = 23), "\\n", "<br>")),
                options = list(
                  `actions-box` = TRUE, size = 25, `selected-text-format` = "count > 3"))
   })
  
  ageGroup <- callModule(ageGroup_server, "ageGroup1", Suggestions=server_sugg, agegroupButton=server_ageBttn, Id049=server_choice, dose=server_dose, daterange1=server_data, dictType)
  
  oneDivision <- callModule(oneDivision_server, "oneDivision1", Suggestions=server_sugg, clicks=server_divBttn, Id049=server_choice, dose=server_dose, daterange1=server_data, NFZdivision=server_NFZdivision, dictType)
  
  allDivision <- callModule(allDivision_server, "allDivision1", Suggestions=server_sugg, allSuggestion=server_all, Id049=server_choice, dose=server_dose, daterange1=server_data, dictType)
  
  yearlyProvision <- callModule(yearlyProvision_server, "yearlyProvision1", Suggestions=server_sugg, allSuggestion=server_all, Id049=server_choice, dose=server_dose, daterange1=server_data, dictType)
  
  monthlyProvision <- callModule(monthlyProvision_server, "monthlyProvision1", Suggestions=server_sugg, allSuggestion=server_all, Id049=server_choice, dose=server_dose, daterange1=server_data, dictType)
}
monthlyProvision <- function(id, label = "monthlyProvision1") {
  # Create a namespace function using the provided id
  ns <- NS(id)
  
  bs4TabItem(
    tabName = "monthlyProvisionSidebar",
    fluidRow(
      bs4Card(width = 12, title = "Analysing by NFZ division",
              bs4Dash::column(width = 12,
                              p("Among the available functionalities of the NFZ API, it is possible to compare year-to-year sales of a product based on active substance or product name. Due to the availability of 2017-2018, it is only possible to compare these two years.")
              ),status = "navy",closable = TRUE)),
    
    fluidRow(
      dropdown(
        
        tags$h3("List of Inputs for renderPieChart and renderBarPlot"),
        tags$p("Unfortunately these renders do not support reactivity (dynamic update). To make changes you need to click Analyse button after switching toggle"),
        
        pickerInput(inputId = ns("legends_month"),
                    label = "Show legend",
                    choices = c(TRUE, FALSE),
                    selected =TRUE,
                    options = list(`style` = "btn-info")),
        
        pickerInput(inputId = ns("labels_month"),
                    label = "Show labels",
                    choices = c(TRUE, FALSE),
                    selected = TRUE,
                    options = list(`style` = "btn-info")),
        
        style = "unite", icon = icon("gear"),
        status = "primary", width = "300px",
        animate = animateOptions(
          enter = animations$fading_entrances$fadeInLeftBig,
          exit = animations$fading_exits$fadeOutRightBig
        )),
      actionBttn(
        inputId = ns("analyseMonthly"),
        label = "Analyse month provision", 
        style = "bordered",
        color = "primary",
        icon = icon("chart-pie")
      )
    ),
    
    #####FIRST QUERY
    fluidRow(
      bs4Card(width = 12,
              title = "Table from query",
              bs4Dash::column(
                width = 12,
                align = "center",
                DTOutput(ns("tbl_monthly"))),status = "navy")),
    
    fluidRow(
      
      loadEChartsLibrary(),
      
      
      bs4Card(width = 12, maximizable = TRUE,
              title = "Quantity per month",
              bs4Dash::column(
                width = 12,
                align = "center",
                tags$div(id="test1_monthly", style="width:90%;height:400px;"),
                deliverChart(div_id = ns("test1_monthly"))),status = "navy")),
    
    
    fluidRow(
      loadEChartsLibrary(),
      bs4Card(width = 12, maximizable = TRUE,
              title = "Refund per month",
              bs4Dash::column(
                width = 12,
                align = "center",
                tags$div(id="test_monthly", style="width:90%;height:400px;"),
                deliverChart(div_id = ns("test_monthly"))),status = "navy")),
    
    fluidRow(
      bs4Card(width = 12, maximizable = TRUE,
              title = "Chart for 2017",
              bs4Dash::column(
                width = 12,
                align = "center",
                plotOutput(ns("plt_monthly2017"))),status = "navy")),
    
    fluidRow(
      bs4Card(width = 12, maximizable = TRUE,
              title = "Chart for 2018",
              bs4Dash::column(
                width = 12,
                align = "center",
                plotOutput(ns("plt_monthly2018"))),status = "navy")),
    
    fluidRow(
      bs4Card(width = 12,
              title = "Table from query and values",
              bs4Dash::column(
                width = 12,
                align = "center",
                DTOutput(ns("tbl_monthly_values"))),status = "navy")),
    
    fluidRow(
      bs4ValueBoxOutput(ns("vbox_month")))
    
  )
  
}
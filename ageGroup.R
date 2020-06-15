ageGroup <- function(id, label = "ageGroup1") {
  # Create a namespace function using the provided id
  ns <- NS(id)
  
  bs4TabItem(tabName = "agegroup",
  
    fluidRow(
      bs4Box(width = 12,
             title = "Age group",
             bs4Dash::column(width = 12,
                             h6("Grouping on the basis of eight age groups available in the NFZ API (the last one is eliminated because it means undefined age)"))
            )),
    
    fluidRow(
      dropdown(
        
        tags$h3("List of Input for renderPieChart and renderBarPlot"),
        tags$p("Unfortunately these renders do not support reactivity (dynamic update)."),
        
        pickerInput(inputId = ns("legends_group"),
                    label = "Show legend",
                    choices = c(TRUE, FALSE),
                    selected =TRUE,
                    options = list(`style` = "btn-info")),
        
        pickerInput(inputId = ns("labels_group"),
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
        inputId = ns("ageGroupButton"),
        label = "Analyse by age group", 
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
               DTOutput(ns("tbl1"))
             ),status = "navy")),
    
    fluidRow(
      loadEChartsLibrary(),
      bs4Card(width = 12,  maximizable = TRUE,
             title = "Global Market - Poland by all NFZ division",
             bs4Dash::column(
               width = 12, 
               #align = "center",
               tags$div(id="testAge", style="width:80%;height:400px;"),
               deliverChart(div_id = ns("testAge"))),status = "navy")),
    
    fluidRow(
      bs4Card(width = 12,  maximizable = TRUE,
             title = "For 'Analyse all division' chart",
             bs4Dash::column(
               width = 12,
               #align = "center",
  
               plotOutput(ns("plt1"))),status = "navy")),
    
    fluidRow(
  
      loadEChartsLibrary(),
      bs4Card(width = 12,  maximizable = TRUE,
             title = "For 'Analyse all division' chart",
             bs4Dash::column(
               width = 12,
               #align = "center",
               tags$div(id="testAge1", style="width:95%;height:900px;"),
               deliverChart(div_id = ns("testAge1"))),status = "navy"))
  )
}
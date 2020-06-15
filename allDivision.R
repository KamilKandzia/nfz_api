allDivision <- function(id, label = "allDivision1") {
  # Create a namespace function using the provided id
  ns <- NS(id)
  
  bs4TabItem(
    tabName = "allDivisionSidebar",
    fluidRow(
      bs4Card(width = 12, title = "Analysing by NFZ division",
              bs4Dash::column(width = 12,
                              p("In this tab, you can analyse sales by NFZ division. Just choose from right sidebar NFZ division and click the appropriate button.")
              ),status = "navy",closable = TRUE)),
    
    fluidRow(
      dropdown(
        
        tags$h3("List of Input for renderPieChart and renderBarPlot"),
        tags$p("Unfortunately these renders do not support reactivity (dynamic update)."),
        
        pickerInput(inputId = ns("legends_all"),
                    label = "Show legend",
                    choices = c(TRUE, FALSE),
                    selected =TRUE,
                    options = list(`style` = "btn-info")),
        
        pickerInput(inputId = ns("labels_all"),
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
        inputId = ns("analyseAllDivision"),
        label = "Analyse all division", 
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
               DTOutput(ns("tbl"))),status = "navy")),
    
    fluidRow(
      loadEChartsLibrary(),
      bs4Card(width = 12, maximizable = TRUE,
             title = "Global Market - Poland by all NFZ division without dose separation",
             bs4Dash::column(
               width = 12,
               #align = "center",
               tags$div(id="pieChartAllDivisionWithoutDose", style="width:95%;height:400px;"),
               deliverChart(div_id = ns("pieChartAllDivisionWithoutDose"))),status = "navy")),
    
    fluidRow(
      loadEChartsLibrary(),
      bs4Card(width = 12, maximizable = TRUE,
              title = "Global Market - Poland by all NFZ division with dose separation",
              bs4Dash::column(
                width = 12,
                #align = "center",
                tags$div(id="pieChartAllDivisionWithDose", style="width:95%;height:400px;"),
                deliverChart(div_id = ns("pieChartAllDivisionWithDose"))),status = "navy")),
    
    fluidRow(
      bs4Card(width = 12, maximizable = TRUE,
             title = "For 'Analyse all division' chart - ggplot2",
             bs4Dash::column(
               width = 12,
               #align = "center",
               plotOutput(ns("barChartGGPLOTallDivision"))),status = "navy")),
    
    fluidRow(
      loadEChartsLibrary(),
      bs4Card(width = 12, maximizable = TRUE,
             title = "For 'Analyse all division' chart - ECharts2Shiny",
             bs4Dash::column(
               width = 12,
               #align = "center",
               tags$div(id="barChartE2ChartallDivision", style="width:80%;height:400px;"),
               deliverChart(div_id = ns("barChartE2ChartallDivision"))),status = "navy")),
    
    fluidRow(
      bs4ValueBoxOutput(ns("vboxAllDivHighest")),
      bs4ValueBoxOutput(ns("vboxAllDivLowest")))
  )
  
}
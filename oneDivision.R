oneDivision <- function(id, label = "oneDivision1") {
  # Create a namespace function using the provided id
  ns <- NS(id)
  
  bs4TabItem(
    tabName = "oneDivisionSidebar",
    fluidRow(
      bs4Card(width = 12, title = "Analysing by NFZ division",
             bs4Dash::column(width = 12,
              p("In this tab, you can analyse sales by NFZ division. Just choose from right sidebar NFZ division and click the appropriate button."),
              p("In some cases, there may appear many products with the same pill per pack and dose amount, but they differ with the EAN code.")
              ),status = "navy",closable = TRUE)),
    
    fluidRow(
      dropdown(
        
        tags$h3("List of Inputs"),
        tags$p("Unfortunately renderPieChart does not support reactivity (dynamic update)."),
        
        pickerInput(inputId = ns("legends"),
                    label = "Show legend",
                    choices = c(TRUE, FALSE),
                    selected =TRUE,
                    options = list(`style` = "btn-info")),
        
        pickerInput(inputId = ns("labels"),
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
        inputId = ns("analyseOneDivision"),
        label = "Analyse one division", 
        style = "bordered",
        color = "primary",
        icon = icon("chart-pie")
      )
    ),
    
    #####FIRST QUERY
    fluidRow(
      #bs4Box
      bs4Card(width = 12, title = "Table results",
             bs4Dash::column(
               width = 12,
               align = "center",
               DTOutput(ns("tableOneDivision"))),
               status = "navy")),
    
    fluidRow(
      loadEChartsLibrary(),
      bs4Card(width = 12, maximizable = TRUE,
             title = "Sale of product for a given branch of the NFZ",
             bs4Dash::column(
               width = 12,
               align = "center",
               tags$div(id="pieChartOneDivisionDose", style="width:95%;height:400px;"),
               deliverChart(div_id = ns("pieChartOneDivisionDose"))), status = "navy")),
    
    fluidRow(
      loadEChartsLibrary(),
      bs4Card(width = 12, maximizable = TRUE,
              title = "Sale of product for a given branch of the NFZ without segmentation on the dose",
              bs4Dash::column(
                width = 12,
                align = "center",
                tags$div(id="pieChartOneDivisionWithoutDose", style="width:95%;height:400px;"),
                deliverChart(div_id = ns("pieChartOneDivisionWithoutDose"))), status = "navy"
      )),
    
    fluidRow(
      bs4ValueBoxOutput(ns("vbox")))
    )
    
}
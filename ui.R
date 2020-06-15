library(shiny)
library(httr)
library(plyr)
library(dplyr)
library(jsonlite)
library(shinyWidgets)
library(DT)
library(ggplot2)
library(conflicted)
require(reshape2)
library(bs4Dash)
library(ECharts2Shiny)
library(foreach)

library(collections)

source("pasteFunction.R")
source("modTable.R")
source("concatString.R")
source("searchNFZ.R")
source("barChartSelect.R")

source("agreggateTableYearlyProvisions.R")
source("agreggateTableMonthlyProvisions.R")

source("ageGroup.R")
source("ageGroup_server.R")

source("oneDivision.R")
source("oneDivision_server.R")

source("allDivision.R")
source("allDivision_server.R")

source("yearlyProvision.R")
source("yearlyProvision_server.R")

source("monthlyProvision.R")
source("monthlyProvision_server.R")

ui <-bs4DashPage(
    navbar = bs4DashNavbar(),
    
    sidebar = bs4DashSidebar(title = "NFZ API - Example", status = "navy", brandColor = "navy",expand_on_hover = FALSE,
                             bs4SidebarMenu(child_indent=FALSE,
                               
                               bs4SidebarHeader("Analysis"),
                               
                               bs4SidebarMenuItem(
                                 "One division NFZ",
                                 tabName = "oneDivisionSidebar",
                                 icon = "file-prescription"),
                               
                               bs4SidebarMenuItem(
                                 "All NFZ division",
                                 tabName = "allDivisionSidebar",
                                 icon = "file-prescription"),
                               
                               bs4SidebarMenuItem(
                                 "Yearly provision",
                                 tabName = "yearlyProvisionSidebar",
                                 icon = "file-prescription"),
                               
                               bs4SidebarMenuItem(
                                 "Monthly provision",
                                 tabName = "monthlyProvisionSidebar",
                                 icon = "file-prescription"),
                               
                               bs4SidebarMenuItem(
                                 "Age group",
                                 tabName = "agegroup",
                                 icon = "calendar-alt"),
                               
                               bs4SidebarHeader("Project"),
                               
                               bs4SidebarMenuItem(
                                 "Inside the project",
                                 tabName = "inside",
                                 icon = "notes-medical"),
                             
                                bs4SidebarMenuItem(
                                   "Instruction",
                                   tabName = "instruction",
                                   icon = "table",
                                   selected = TRUE)
                              ),
                              skin = "light"),
    
    
    
    controlbar = dashboardControlbar(
                              selectInput("NFZdivision", "NFZ division: ", c(1:16)),
                              dateRangeInput("daterange1", "dateFrom : dateTo",
                                             start = "2017-01-01",
                                             min = "2017-01-01",
                                             end   = "2018-12-31",
                                             max = "2018-12-31"),

                              awesomeRadio(
                                inputId = "Id049",
                                label = "Find by",
                                choices = c("active-substances", "medicine-products"),
                                selected = "active-substances",
                                checkbox = TRUE
                              ),


                              textInput("nameMedicineSubstance","Type Medicine product or active substance"),
                              uiOutput("ui"),
                              textInput("dose","[NOT OBLIGATORY] Dose eg. 40 mg"),
                              #actionButton("clicks", label = "Analyse one NFZ division",width ="100%"),
                              tags$br(),
                              #actionButton("allSuggestion", label = "Analyse all NFZ division", width = "100%"),
                              #actionButton("agegroupButton", label = "Analyse by age group", width = "100%"),
                              skin = "light"
                              ),
    
    footer = bs4DashFooter(actionButton(inputId='ab1', label="GitHub Profile", 
                                        icon = icon("github"), 
                                        onclick ="window.open('https://github.com/KamilKandzia', '_blank')"),
                           actionButton(inputId='ab1', label="LinkedIn Profile", 
                                        icon = icon("linkedin"), 
                                        onclick ="window.open('https://www.linkedin.com/in/kamil-kandzia', '_blank')"),copyrights = "Kamil Kandzia"),
    title = "NFZ API",

    body = bs4DashBody(

      bs4TabItems(
        
        bs4TabItem(tabName = "instruction",
          fluidRow(
            bs4Card(width = 12,
                    title = "How to use website", status = "navy",
                    bs4Dash::column(
                      width = 12,
                      #align = "center",
                      p("The website allows for comprehensive data analysis. In particular, the emphasis was placed on sales for given branches of the NFZ. Additionally, the possibility of a year-to-year analysis was introduced, as well as with the division into age groups according to the attributes within the NFZ API."),
                      p("In the left sidebar, there are links to the relevant tabs, while on the right side there is a product search engine by active substance or product name. By default, the first item in the Suggestion field (this is the resulting product or active substance within the dictionary method)."),
                      p("The choice of dates applies only for 2017 and 2018, as only such data are made available by the government services. The NFZ division field is used for 'One division NFZ'."),
                      p("The additional attribute Dose allows selecting only products with a specific dose."),
                      tags$a(href="https://api.nfz.gov.pl/app-stat-api-ra/", "More information about NFZ API")
                    )),
            
            bs4TabCard(
              id = "tabcard",
              title = "Analysis", status = "navy", width=12,closable = FALSE,
              bs4TabPanel(
                tabName = "One division NFZ",
                active = TRUE,
                p("Analysis of one NFZ branch is available for many products. Within this functionality, two charts are displayed, each of them concerning the sale of specific products in a given area. The first one takes the label with the dose, while the second one shows the aggregated data."),
                p("Just choose from right sidebar NFZ division and click appropriate button on the tab to make analysis"),
                p("In some cases there may appear many products with same pill per pack and dose amount, but the differ with the EAN code")
              ),
              bs4TabPanel(
                tabName = "All NFZ divisions",
                active = FALSE,
                p("In this tab you can analyse sales by NFZ division. Just choose from right sidebar NFZ diivision and click appropriate button")
              ),
              bs4TabPanel(
                tabName = "Yearly provision",
                active = FALSE,
                p("Among the available functionalities of the NFZ API, it is possible to compare year-to-year sales of a product based on active substance or product name. Due to the availability of 2017-2018, it is only possible to compare these two years.")
              ),
              bs4TabPanel(
                tabName = "Age group",
                active = FALSE,
                p("Grouping on the basis of eight age groups available in the NFZ API (the last one is eliminated because it means undefined age)")
              )))),
        
        bs4TabItem(tabName = "inside",
                   fluidRow(
                     bs4Box(width = 12, title = "Inside the project",
                            bs4Dash::column(
                              width = 12,
                              p("The site was created using Shiny and the bs4Dash (which is being developed to adapt to Bootstrap 4 in the Shiny environment)."),
                              p("For connecting to the NFZ server httr and jsonlite were used, which uses query/response using text in JSON format."),
                              p("The tables were rendered using DT, alerts using shinyWidgets. Pie&Bar charts by ECharts2Shiny, ggplot2 (geom_bar+scale_fill_discrete) was also used."),
                            )))),
        
        yearlyProvision("yearlyProvision1"),
        monthlyProvision("monthlyProvision1"),
        allDivision("allDivision1"),
        oneDivision("oneDivision1"),
        ageGroup("ageGroup1") 
                  
         )
      )
    )
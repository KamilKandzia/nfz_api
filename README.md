# NFZ_API https://api.nfz.gov.pl/app-stat-api-ra/
# Analysis of the NFZ dataset https://kamil-kandzia.shinyapps.io/nfz_api/
The application was created in shiny (R) environment using bs4dash (one of the implementation of bootstrap 4). 

Using the NFZ data under the "API Statystyki NFZ - Refundacja Apteczna" (eng. NFZ Statistics API - Pharmaceutical Refund), 5 different data analysis scenarios are presented.

**Analysis of one NFZ branch**

**Analysis of all NFZ branches (16)**

**Data analysis year-on-year**

**Analysis of data month to month**

**Analysis based on age groups**

# How to start the application?
You need to have installed Rstudio with R enviroment. For the bs4Dash library it is recommended to install from the GitHub source (https://github.com/RinteRface/bs4Dash), as the version may differ from the one on CRAN.

# How to use the application?
The Sidebar on the left allows you to select one of five possible data analysis options. There is also an instruction and general information about the project.

The Sidebar on the right allows you to choose your medicines by name or active substance. Due to the data limit of one query of 25 items, only as many items are shown. The list is dynamically updated and the first item is selected by default for analysis. It is possible to select multiple drugs as well as active substances.

**Please note that products may be under many active substances despite their usual name.** For example, Mesopral (esomeprazolum magneticum) belongs to the group of esomeprazolums and the name (esomeprazolum) of the active substance appears on the package.

**The data are available from 2017-01-01 to 2018-12-31.**

A choice of drugs with a given dose is also available, but the available tables allow for analysis with and without a dose.

**Charts**

Each of the analysis tabs has a gear wheel and the Analyse button. You can use the gear to enable and disable the legend and labels for renderPieChart/renderBarChart (ECharts2Shiny). Since these charts do not generate in a reactive way, you have to click Analyse again. Please note that the options are different for each of the tabs, and modifications from each tab are necessary.

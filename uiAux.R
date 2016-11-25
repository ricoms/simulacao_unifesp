library(shiny)
library(shinydashboard)

dashboardPage(
  skin = "yellow",
  
  #Título da dashboard
  dashboardHeader(title = "Bootstrap Analyzer"),
  
  #Abas da dashboard
  dashboardSidebar(
    sidebarMenu(
      id = "menu",
      menuItem("About", tabName = "about"),
      menuItem("App", tabName = "app"),

      #Elaborando painel caso seja selecionado App
      conditionalPanel(
        condition = "input.menu == 'app'",
        below = "about",
        fluidRow(
          column(
            width = 12,
            box(
              title = "Selection",
              width = 12,
              background = "orange",
              "Choose right values to start."
            ),
            
            uiOutput("options1"),
            uiOutput("options2"),
            
            box(
              actionButton("go","Start", width = "60px"),
              background = "orange"
            )
            
          )#endcolumn
        )#endfluidrow
        
      )#endconditional
    )#endsidebarmenu
  ),#endsidebar
  
  #Dashboard body
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "app",
        uiOutput("desc"),
        uiOutput("painel"),
        uiOutput("analise"),
        uiOutput("results")
      ),
      tabItem(
        tabName = "about",
        h2("Projeto: Bootstrap analyzer"),
        p("Orientadora: Prof. Dra. Camila Bertini Martins"),
        p("Alunos: Alexandre Hild Aono (92169) & Ricardo Manhães Savii (92482)")
      )
    )#enditems
  )#enddashbody
  
  
)#end dashboard
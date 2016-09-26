## ui.R ##
library(shinydashboard)
library(rhandsontable)

ui <- dashboardPage(skin = "yellow",
  dashboardHeader(title = "Bootstrap analyzer"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("App", tabName = "app", icon = icon("home"))
    )
  ),
  
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "www/css", href = "custom.css")
    ),
    
    tabItems(
      
      ########################
      # Conteúdo da Página App
      tabItem(tabName = "app",
              
        ########################
        # Painel principal - App
        fluidRow(
          box(title = "Entrada dos dados", status = "primary", collapsible = TRUE, width = 12,
              checkboxInput(inputId = 'subir_arquivo',
                            label = 'Importar arquivo?'
              ),
              fluidRow(
                column(12,
                       wellPanel(
                         rHandsontableOutput("hot_table")
                       )
                )
              )
          )
        ),
        # Fim de Painel Principal - App
        ########################
        
        ########################
        # Painel para importação de arquivo
        conditionalPanel(
          condition = "input.subir_arquivo == true",
          fluidRow(
            column(4,
                   checkboxInput(inputId = 'header',
                                 label = 'Cabeçalho',
                                 TRUE),
                   radioButtons(inputId = 'sep',
                                label = 'Separador',
                                choices = c('virgula'=',',
                                            'ponto e virgula'=';',
                                            'tabulação'='\t'),
                                selected = ','),
                   radioButtons(inputId = 'quote',
                                label = 'Citaçao',
                                choices = c('sem'='',
                                            'aspas duplas'='"',
                                            'aspas simples'="'"),
                                selected = '"')
            ),
            column(8,
                   fileInput('arquivo', 'Escolher arquivo .csv ou .txt',
                             multiple = FALSE,
                             accept = c('text/csv',
                                        'text/comma-separated-values',
                                        'text/tab-separated-values',
                                        'text/plain',
                                        '.csv',
                                        '.tsv',
                                        '.txt'
                             )
                   ),
                   actionButton("botao_arquivo", "Importar arquivo"),
                   tags$hr(),
                   tags$p("Escreva suas entradas em um arquivo .csv ou .txt."),
                   tags$p("Cada linha de seu arquivo será considerada como uma observação multivariada.")
            )
          )
        )
        # Fim de Painel para importação de arquivo
        ########################
      )
      # Fim de TabItem "app"
      ########################
    )
    # Fim de TabItems
    ########################
  )
  # Fim de Dashboard body
  ########################
)
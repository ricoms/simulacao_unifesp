library(shiny)
library(rhandsontable)
library(boot)
library(RVAideMemoire)

source('./data_examples_app.R', local=TRUE)

server <- function(input, output) {
  
  #Selecionar medida resumo
  output$options1 <- renderUI({
    selectInput("options1", "Values", c("Mean","Proportion"), selected=NULL)
  })
  
  #Selecionar nível de significância
  output$options2 <- renderUI({
    selectInput("options2", "Level of significance", c(99,95,90), selected=NULL)
  })
  
  #Abas sendo criadas
  output$desc <- renderUI({
    if(input$go){
      box(title = "Meta-analysis", width = 12, solidHeader = TRUE, status = "primary",
          "Select your type of input for building your analysis."
      )
    }
  })
  
  output$painel <- renderUI({
    if(input$go){
      tabBox(
        title = "Input data",
        id = "ttabs",
        width = 12,
        height = "320px",
        tabPanel("Manual Input",
                 wellPanel(
                   rHandsontableOutput("hot_table")
                 )
        ),
        tabPanel("Import",
                 fluidRow(
                   column(
                     4,
                     checkboxInput(inputId = "header", label = "Cabeçalho", TRUE),
                     radioButtons(inputId = "sep", label = "Separador", choices = c('virgula'=',', 'ponto e virgula'=';','tabulação'='\t'), selected = ","),
                     radioButtons(inputId = "quote", label = "Citação", choices = c('sem'='', 'aspas duplas'='"','aspas simples'="'"),selected = '"')
                   ),
                   column(
                     8,
                     fileInput("arquivo", "Escolher arquivo .csv ou .txt",accept=c('text/csv', 'text/comma-separated-values','text/tab-separated-values','text/plain','.csv','.tsv','.txt')),
                     actionButton("botao_arquivo", "Importar arquivo"),
                     tags$hr(),
                     tags$p("Escreva suas entradas em um arquivo .csv ou .txt."),
                     tags$p("Cada linha de seu arquivo será considerada como uma observação multivariada.")
                   )
                   
                 )#endfluidrow
                 
        )#endtabpanel
      )#endtabbox
    }
  })
  
  output$analise <- renderUI({
    if(input$go){
        box(
        actionButton("anal","Analyse", width = "150px"),
        background = "light-blue",
        width = 2
      )
    }
  })
  
  # configurações do usuário para upload de arquivo
  header <- reactive({
    input$header
  })
  sep <- reactive({
    input$sep
  })
  quote <- reactive({
    input$quote
  })
  alpha <- reactive({
    input$alpha
  })
  
  # values será o espelho da rHandsonTable no programa
  values <- reactiveValues(data = df_prop)
  
  # permite a edição direto na tabela rHandsonTable
  observe ({
    if(!is.null(input$hot))
      values$data <- hot_to_r(input$hot)
  })
  
  # permite a importação à partir de um arquivo
  observeEvent (input$botao_arquivo, {
    inFile <- input$arquivo
    if (is.null(inFile))
      return(NULL)
    values$data <- read.table(inFile$datapath, header = header(), sep = sep(), quote = quote())
  })
  
  # Representa/renderiza a rHandsonTable
  output$hot_table <- renderRHandsontable({
    rhandsontable(values$data, rowHeaders = FALSE,
                  useTypes = FALSE, colHeaders = TRUE) %>%
      hot_table(highlightCol = TRUE, highlightRow = TRUE,
                allowRowEdit=TRUE) %>%
      hot_cols(columnSorting = TRUE, allowInvalid = TRUE)
  })
  
  # Permite realizar o download da tabela visualizada
  output$downloadData <- downloadHandler(
    filename = function() { 
      paste('data-', Sys.Date(), '.csv', sep='') 
    },
    content = function(file) {
      write.csv(values$data, file, row.names = FALSE)
    }
  )
  
  # dados é a variável final que será levada para análise
  dados <- reactiveValues(data = df_prop)
  
  # dados só é atualizado quando botão plot (Submeter) é apertado
  observeEvent(input$run, {
    dados$data <- values$data
  })
  
  
  # Obtendo dados
  teste1 <- renderPrint({dados$data$eventos})
  teste2 <- renderPrint({dados$data$n})
  teste <- renderPrint({"Hello"})
  
  output$results <- renderUI({
    if(input$go){
      if(input$anal){
        #Pode-se começar a análise

        
        #Passo 2: Qual Método será utilizado
        if(q == 1){
          #valueBox()
        }
        
      }
    }
  })
  
  
}#endfunction
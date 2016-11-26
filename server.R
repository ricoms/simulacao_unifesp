## server.R ##

library(shiny)
library(rhandsontable)
library(boot)
library(meta)

source('source_files/data_examples_app.R', local=TRUE)

server <- function(input, output) {
  #Selecionar medida resumo
  output$options1 <- renderUI({
    selectInput(inputId = "options1", label = "Effect Sizes",
                choices = c("Mean"='df_med1',"Proportion"='df_prop'),
                selected=NULL)
  })
  
  #Selecionar nível de significância
  output$options2 <- renderUI({
    numericInput(inputId = "options2", label = "Level of significance",
                 value = 0.95, min = 0.00, max = 1,
                 width = 100, step = 0.01)
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
                   rHandsontableOutput("hot_table"),
                   tags$hr(),
                   column(width = 4,
                          downloadButton('downloadData', 'Save data as .csv')
                   )
                 )
        ),
        tabPanel("Import",
                 fluidRow(
                   column(
                     4,
                     checkboxInput(inputId = "header", label = "Cabeçalho", TRUE),
                     radioButtons(inputId = "sep", label = "Separador",
                                  choices = c('virgula'=',', 'ponto e virgula'=';','tabulação'='\t'), selected = ","),
                     radioButtons(inputId = "quote", label = "Citação",
                                  choices = c('sem'='', 'aspas duplas'='"','aspas simples'="'"),selected = '"')
                   ),
                   column(
                     8,
                     fileInput("arquivo", "Escolher arquivo .csv ou .txt",
                               accept=c('text/csv','text/comma-separated-values',
                                        'text/tab-separated-values','text/plain','.csv','.tsv','.txt')),
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
  
  output$results <- renderUI({
    if(input$analyse){
      tabBox(
        title = "Results",
        id = "tresults",
        width = 12,
        height = "400px",
        tabPanel("Forest Plot",
                wellPanel(
                    plotOutput("forest"),
                    tags$hr(),
                    column(width = 4,
                           downloadButton('downloadForest', 'Save forest as pdf')
                    )
                )
        ),
        tabPanel("Teste Q boot result",
                wellPanel(
                  plotOutput("boot"),
                  tags$hr(),
                  column(width = 4,
                         downloadButton('downloadBoot', 'Save boot as pdf')
                  )
                )
        )
      )
    }
  })
  
  output$analise <- renderUI({
    if(input$go){
      box(
        actionButton("analyse","Analyse", width = "150px"),
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
  
  # values será o espelho da rHandsonTable na memória do programa
  values <- reactiveValues(data = df_prop)
  observeEvent (input$go, {
    values$data <- get(input$options1)
  })
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
  observeEvent(input$go, {
    dados$data <- values$data
  })
  
  # eff irá guardar o effect-size escolhido pelo usuário
  eff <- reactiveValues(data = "oi")
  observeEvent (input$go, {
    eff$data <- input$options1
  })
  
  ################################################
  # Cálculo do objeto meta
  ################################################
  meta <- reactive({
    source('source_files/define_meta_app.R', local=TRUE)
    if (eff$data %in% names(compute_meta)) {
      meta <- do.call(compute_meta[[eff$data]], arg_meta[[eff$data]])
    } else {
      NULL
    }
  })
  
  ################################################
  # Renderização do forest plot
  ################################################
  plotForest <- function(){
    meta <- meta()
    if (!is.null(meta)) {
     forest(meta, studlab = paste(dados$data$Estudos),
            comb.random=TRUE, comb.fixed=TRUE)
    } else {
      NULL
    }
  }
  output$forest <- renderPlot ({
    plotForest()
  })
  # Permite realizar o download da figura Forest
  output$downloadForest <- downloadHandler(
    filename <- function() {
      paste('forest_', Sys.Date(), '.pdf', sep='')
    },
    content <- function(FILE=NULL) {
      pdf(file=FILE)
      plotForest()
      dev.off()
    }
  )
  
  ################################################
  # aplicar o boot nas estatísticas de objeto 'meta'
  ################################################
  plotBoot <- function(){
    meta <- meta()
    
    
  }
  
  ################################################
  # retornar plot(boot(data = amostra, statistic = amostra.mean, R = 1000))
  ################################################
  output$boot <- renderPlot ({
    plotBoot()
  })
  # Permite realizar o download da figura Boot
  output$downloadBoot <- downloadHandler(
    filename <- function() {
      paste('boot_', Sys.Date(), '.pdf', sep='')
    },
    content <- function(FILE=NULL) {
      pdf(file=FILE)
      plotForest()
      dev.off()
    }
  )
}
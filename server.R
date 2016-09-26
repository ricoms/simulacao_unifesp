## server.R ##

library(shiny)
library(rhandsontable)
library(boot)

source('source_files/data_examples_app.R', local=TRUE)

server <- function(input, output) {
  
  # definições feitas pelo usuário na aplicação
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
  values <- reactiveValues(data = df1)
  
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
  
  # dados é a variável final que será levada até o plot
  dados <- reactiveValues(data = df1)
  
  # dados só é atualizado quando botão plot (Submeter) é apertado
  observeEvent(input$plot, {
    dados$data <- values$data
  })
  
  # Representa/renderiza a rHandsonTable
  output$hot_table <- renderRHandsontable({
    rhandsontable(values$data, rowHeaders = NULL) %>%
      hot_table(highlightCol = TRUE, highlightRow = TRUE, allowRowEdit=TRUE) %>%
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
}
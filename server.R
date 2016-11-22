## server.R ##

library(shiny)
library(rhandsontable)
library(boot)
library(meta)

source('source_files/data_examples_app.R', local=TRUE)

server <- function(input, output) {
  
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
  dados <- reactiveValues(data = df1)
  
  # dados só é atualizado quando botão plot (Submeter) é apertado
  observeEvent(input$run, {
    dados$data <- values$data
  })
  
  ################################################
  # Cálculo do objeto meta
  ################################################
  meta <- reactive({
    source('define_meta_app.R', local=TRUE)
    if (modelo$data %in% names(compute_meta)) {
      meta <- do.call(compute_meta[[modelo$data]], arg_meta[[modelo$data]])
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
      if (1-pchisq(meta$Q, meta$df.Q) > alpha()) { # if p-value > alpha só apresenta fixed effect model
        forest(meta, studlab = paste(dados$data$Estudos),
               comb.random=FALSE, comb.fixed=TRUE)
      } else {
        forest(meta, studlab = paste(dados$data$Estudos),
               comb.random=TRUE, comb.fixed=FALSE)
      }
    } else {
      frame()
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
  
  
  ################################################
  # retornar plot(boot(data = amostra, statistic = amostra.mean, R = 1000))
  ################################################
  
}
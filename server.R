options(shiny.sanitize.errors = FALSE)

load("Data/DAT.RData")

shinyServer(function(input, output, session) {
  p <- reactiveValues()
  
  observe({
      msg <- gsub(".*ipInfo", paste(date(), "ipInfo"), input$log)
      if (nchar(msg) > 20) {
        write(msg, "www/visitors.txt", append  = TRUE)
      }  
  })
  
  
  ## Source input and output;
  source("RScript/input.R",  local = TRUE)
  source("RScript/jsFun.R", local = TRUE)
  source("RScript/output.R", local = TRUE)
  
})

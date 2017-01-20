library(rCharts)

shinyUI(bootstrapPage(
  # Add custom CSS & Javascript;
  tagList(
    tags$head(
      tags$style("hr {margin: 5px 0;}"),
      tags$script(src="jquery-ui.js"),
      tags$script(src="app.js"),
      tags$link(rel="stylesheet", type="text/css",href="style.css")
    )
  ),
  
  img(id = "control", src = "control.png"),
  
  div(class = "Input", 
      HTML("<div class='drag'></div>"),
      uiOutput("uiFylke"),
      uiOutput("uiYear"),
      uiOutput("uiSubject"),
      uiOutput("uiChart"), 
      HTML("<hr></hr>"),
      uiOutput("uiLegend"),
      textInput(inputId = "log", label = "")),
  
  div(class = "control", 
      uiOutput("uiMapType")),
  
  div(class = "Output", 
      HTML("<div class='drag'></div>"),
      showOutput("fig", lib = "highcharts")),
  
  showOutput("myMap", "leaflet")
  
))

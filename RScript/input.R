output$uiFylke <- renderUI({
  Items <- c("akershus-fylke", "aust-agder-fylke", "buskerud-fylke", "finnmark-fylke", "hedmark-fylke", "hordaland-fylke", 
             "moere-og-romsdal-fylke", "nordland-fylke", "nord-troendelag-fylke", "oestfold-fylke", "oppland-fylke", "oslo-fylke",           
             "rogaland-fylke", "soer-troendelag-fylke", "sogn-og-fjordane-fylke", "telemark-fylke", "troms-fylke", "vest-agder-fylke",
             "vestfold-fylke")
  names(Items) <- c("Akershus", "Aust-Agder", "Buskerud", "Finnmark", "Hedmark", "Hordaland", 
                    "Møre og Romsdal", "Nordland", "Nord-Trøndelag", "Østfold", "Oppland", "Oslo",           
                    "Rogaland", "Sør-Trøndelag", "Sogn og Fjordane", "Telemark", "Troms", "Vest-Agder",
                    "Vestfold")
  selectInput(inputId = "fylke", 
              label   = "County", 
              multiple = TRUE,
              selected = "oslo-fylke",
              choices = Items)
})
    

output$uiYear <- renderUI({
  Items <- c(2014, 2015)
  selectInput(inputId = "year", 
              label   = "Year", 
              multiple = TRUE,
              selected = 2014,
              choices = Items)
})

output$uiSubject <- renderUI({
  Items <- c("Engelsk", "Lesing", "Regning")
  selectInput(inputId = "subject", 
              label   = "Subject", 
              multiple = TRUE,
              selected = "Engelsk",
              choices = Items)
})


output$uiChart <- renderUI({
  checkboxInput(inputId = "chart", 
                label   = "Satistical report", 
                value   = FALSE)
})

output$uiLegend <- renderUI({
  if (!is.null(p$color_ls)) {
    inn <- "<div id='legend'>"
    print(p$color_ls)
    # 10*p$score[i]/100 + 3
    for (i in seq(2, length(p$color_ls), length.out = 5)) {
      inn = paste(inn,  "<li><span style='background:" , p$color_ls[i] ,
                  "; height:", 2*round(p$scoreUni[i]/10 + 3) , 
                  "px; width:", 2*round(p$scoreUni[i]/10 + 3), 
                  "px; '></span>" , p$scoreUni[i] , "</li><hr>", sep = "")
    }
    inn <- paste(inn, "</div>")
    HTML(inn)
  }
})

output$uiMapType <- renderUI({
  radioButtons(inputId = "mapType", 
               label   = "",
               c("Open street" = "openstreet", 
                 "Open cycle"  = "opencycle", 
                 "ESRI image"  = "statllite"))
})
   


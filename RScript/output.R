observe({
  if (!is.null(input$chart)) {
    if (input$chart) {
      output$fig <- renderChart({
        ## Highchart basic;
        H <- Highcharts$new()
        H$addParams(dom = "fig")
        H$chart(type = "column", zoomType = "xy", width=1000, height = 600, spacingTop = 10, inverted = TRUE)
        H$subtitle(text = " ", style = list(fontSize = "14px", color = "black"))
        H$exporting(enabled = TRUE)
        H$legend(enabled = FALSE)
        H$data(p$dat$score)
        H$xAxis(tickLength = 0, 
                categories = p$dat$Skole,
                title      = list(text = "Skole"))
        H
      })
    }
  }
})


observe({
  if (!is.null(input$fylke)) {
    output$myMap <- renderMap({
      m <- Leaflet$new()
      m$addParams(width="100%", height=1000, layerOpts = list(maxZoom = 18))
      
      if (input$mapType == "openstreet") {
        m$addParams(urlTemplate= 'http://{s}.tile.openstreetmap.de/tiles/osmde/{z}/{x}/{y}.png')
      } else if (input$mapType == "statllite") {
        m$addParams(urlTemplate= 'http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}')
      } else if (input$mapType == "opencycle") {
        m$addParams(urlTemplate= 'http://{s}.tile3.opencyclemap.org/landscape/{z}/{x}/{y}.png')
      }
      
      ## Fylke
      dat <- DAT[which(DAT$Fylke %in% input$fylke), ]
      
      ## Year
      id <- 1:6
      for (yr in input$year) {
          id <- c(id, grep(yr, names(dat)))
      }
      dat <- dat[, id]

      ## Subject
      id <- 1:6
      for (s in input$subject) {
        id <- c(id, grep(s, names(dat)))
      }
      dat <- dat[, id]
      

      if (is.data.frame(dat[, -c(1:6)]) ) {
        dat$score <- round(rowMeans(dat[, -c(1:6)], na.rm = TRUE),1)
      } else {
        dat$score <- dat[, -c(1:6)]
      }

        
      
      dat <- dat[which(!is.na(dat$Lon) & !is.na(dat$Lat) & !is.na(dat$score)), ]
      print(dat)
      
      lon <- mean(dat$Lon)
      lat <- mean(dat$Lat)
      
      m$addParams(bounds = list(c(lat-.07,lon-.1), c(lat+.03,lon+.0)))
      
      ## Build GeoJSON list;
      Dat <- list()
      scoreUni <- sort(unique(round(dat$score)))
      color_ls <-   colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan", "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))(length(scoreUni))
      for (i in 1:nrow(dat)) {
        geoList <- list(type = "Feature", 
                        geometry = list(type = "Point", coordinates = c(dat$Lon[i], dat$Lat[i])),
                        properties = list(color = "black", 
                                          fillColor = color_ls[which(scoreUni == round(dat$score[i]))],
                                          fillOpacity = .8,
                                          radius = 10*dat$score[i]/100 + 3,
                                          popup = paste(paste(c("School", "Address", "Score"), dat[i, c("Skole", "Address", "score")], sep = ": "), collapse = "<br>")
                        ))
        Dat[[length(Dat)+1L]] <- geoList
      }
  
      p$dat <- dat[rev(order(dat$score)), ]
      p$scoreUni <- scoreUni
      p$color_ls <- color_ls
      
      
      m$geoJson(Dat, onEachFeature = jsOnEachFeature,
                style = jsStyle, pointToLayer =jsPointToLayer)
      m
    })
  }
})


setwd("/srv")
file_ls <- list.files(path = "hd/NasjonalePrøver5/Data", pattern = ".html", recursive = TRUE, full.names = TRUE)
load("hd/NasjonalePrøver5/Data/SkoleGeo.RData")

DAT$Engelsk2014 <- DAT$Engelsk2015 <- 
DAT$Lesing2014  <- DAT$Lesing2015 <-
DAT$Regning2014 <- DAT$Regning2015 <- NA

for (i in 1:length(file_ls)) {
  if (exists("XML")) rm(XML)
  ## htmlParse(getURL("hd/NasjonalePrøver5/Data/akershus-fylke/algarheim-skole.html"), encoding = "UTF-8")
  XML <- htmlParse(getURL(file_ls[i], encoding = "UTF-8"))
  
  ## Figure data
  xmlScript <- xpathApply(XML, "//script[contains(., 'showDiagram')]")
  if (length(xmlScript) == 4) {
    ## 2 Engelsk
    xmlEngelsk <- gsub("^.*?, '|',.*$", "", gsub("\\", "", xmlValue(xmlScript[[2]]), fixed = TRUE))
    if (grepl("chartType", xmlEngelsk)) {
      jsonEngelsk <- fromJSON(xmlEngelsk)
      for (n in 1: length(jsonEngelsk$categories)) {
        id <- jsonEngelsk$categories[[n]]$id
        if (id == "2014-2015") {
          v1 <- jsonEngelsk$series[[1]]$data[[n]]$verdi
          if (!is.null(v1)) {DAT$Engelsk14[i] <- v1}
        }
        if (id == "2015-2016") {
          v2 <- jsonEngelsk$series[[1]]$data[[n]]$verdi
          if (!is.null(v2)) {DAT$Engelsk15[i] <- v2}
        }
      }
    }
    
    ## 3 Lesing
    xmlLesing <- gsub("^.*?, '|',.*$", "", gsub("\\", "", xmlValue(xmlScript[[3]]), fixed = TRUE))
    if (grepl("chartType", xmlLesing)) {
      jsonLesing <- fromJSON(xmlLesing)
      for (n in 1: length(jsonLesing$categories)) {
        id <- jsonLesing$categories[[n]]$id
        if (id == "2014-2015") {
          v1 <- jsonLesing$series[[1]]$data[[n]]$verdi
          if (!is.null(v1)) {DAT$Lesing14[i] <- v1}
        }
        if (id == "2015-2016") {
          v2 <- jsonLesing$series[[1]]$data[[n]]$verdi
          if (!is.null(v2)) {DAT$Lesing15[i] <- v2}
        }
      }
      
    }
    
    ## 4 Regning
    xmlRegning <- gsub("^.*?, '|',.*$", "", gsub("\\", "", xmlValue(xmlScript[[4]]), fixed = TRUE))
    if (grepl("chartType", xmlRegning)) {
      jsonRegning <- fromJSON(xmlRegning)
      for (n in 1: length(jsonRegning$categories)) {
        id <- jsonRegning$categories[[n]]$id
        if (id == "2014-2015") {
          v1 <- jsonRegning$series[[1]]$data[[n]]$verdi
          if (!is.null(v1)) {DAT$Regning14[i] <- v1}
        }
        if (id == "2015-2016") {
          v2 <- jsonRegning$series[[1]]$data[[n]]$verdi
          if (!is.null(v2)) {DAT$Regning15[i] <- v2}
        }
      }
    }
  }
  print(i)
}
save(DAT, file = "hd/NasjonalePrøver5/Data/DAT.RData")

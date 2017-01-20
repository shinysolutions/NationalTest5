setwd("/srv")
file_ls <- list.files(path = "hd/NasjonalePrøver5/Data",recursive = TRUE, full.names = TRUE)
DAT <- data.frame(Fylke = rep(NA, length(file_ls)), Kommuner = NA, Skole = NA, Address = NA)

for (i in 1:length(file_ls)) {
  if (exists("XML")) rm(XML)
  ## htmlParse(getURL("hd/NasjonalePrøver5/Data/akershus-fylke/algarheim-skole.html"), encoding = "UTF-8")
  XML <- htmlParse(getURL(file_ls[i], encoding = "UTF-8"))
  
  xmlSkole <- xpathApply(XML, "//span[@class='enhetsnavn']")
  xmlAddress <- xpathApply(XML, "//div[@class='adressekolonne block']/div/div")
  xmlKommuner <- xpathApply(XML, "//div[@class='skoleeierkolonne block']/div/span[2]")
  
  skole <- gsub("^ *| *$", "", gsub("\n *|  *", " ", xmlValue(xmlSkole[[1]]))) 
  address <- gsub("^ *| *$", "", gsub("\n *|  *", " ", paste (xmlValue(xmlAddress[[1]]), xmlValue(xmlAddress[[2]]))))
  kommuner <- gsub(" kommune skoleeier", "", gsub("\n *|  *", " ", xmlValue(xmlKommuner[[1]])))
  
  fylk <- regmatches(file_ls[i], regexec("Data/(.*?)/", file_ls[i]))[[1]][2]
  
  DAT$Fylke[i] <- fylk
  DAT$Kommuner[i] <- kommuner
  DAT$Skole[i] <- skole
  DAT$Address[i] <- address
  
  
#   ## Figure data
#   xmlScript <- xpathApply(XML, "//script[contains(., 'showDiagram')]")
#   x <- gsub("\\", "", xmlValue(xmlScript[[1]]), fixed = TRUE)
#   y <- gsub("^.*?, '|',.*$", "", x)
#   z <- fromJSON(y)
  
  print(i)

}


## Geocoding
DAT[, c("Lon", "Lat")] <- NA
googleMap <- "http://maps.googleapis.com/maps/api/geocode/xml?sensor=false&address="
for (i in 1:nrow(DAT)) { 
  url <- paste(googleMap, paste(paste(DAT$Address[i], DAT$Skole[i], DAT$Kommuner[i], sep= " "), "Norway", sep = " "), sep = "")
  url <- gsub(" ", "%20", url)
  if (exists("xml")) {rm(xml)}
  xml <- getURL(url); Sys.sleep(.5)
  if (exists("xml")) {
    DAT[i, 'Lon'] <- as.numeric(regmatches(xml, regexec("<lng>(.+?)</lng>", xml))[[1]][2])
    DAT[i, 'Lat'] <- as.numeric(regmatches(xml, regexec("<lat>(.+?)</lat>", xml))[[1]][2])
    print(i)
  }

}

save(DAT, file = "hd/NasjonalePrøver5/Data/SkoleGeo.RData")





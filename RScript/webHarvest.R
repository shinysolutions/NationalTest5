library(XML)
library(RCurl)
library(RJSONIO)

## Fylker ##
udir <- "https://skoleporten.udir.no"
Norge <- "https://skoleporten.udir.no/rapportvisning/grunnskole/laeringsresultater/nasjonale-proever-5-trinn/nasjonalt?enhetsid=00&vurderingsomrade=11&underomrade=50&skoletype=0&skoletypemenuid=0&sammenstilling=1"
HTM <- getURL(Norge)
XML <- htmlParse(HTM, encoding = "UTF-8")
XML <- xpathApply(XML, "//li[@class='container fylker']/ul[1]/li/a[@href]")

n <- 0
for (f in 1:length(XML)) {
  urlF <- xmlAttrs(XML[[f]], "href")[2]
  fylk <- regmatches(urlF, regexec("trinn/(.*?)\\?", urlF))[[1]][2]
  dir_target <- paste("/srv/hd/NasjonalePrøver5/Data/", fylk, sep = "")
  if (!dir.exists(dir_target)) { dir.create(dir_target)}
  htm <- getURL(paste(udir, urlF, sep = ""))
  xml <- htmlParse(htm, encoding = "UTF-8")
  xml <- xpathApply(xml, "//li[@class='container']/ul[@class='linkGroup'][2]/li/a")
  m <- 0
  for (s in 1:length(xml)) {
    url <- paste(udir, xmlAttrs(xml[[s]], "href")[2], sep = "")
    skole <- regmatches(url, regexec("trinn/(.*?)\\?", url))[[1]][2]
    download.file(url = url, destfile = paste(dir_target, "/", skole, ".html", sep = ""), quiet = TRUE)
    n <- n + 1; m <- m + 1
    print(paste(n, m, fylk, skole, sep = ": "))
  }
}


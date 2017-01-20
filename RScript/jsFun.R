jsOnEachFeature <- '#! function(feature, layer){
  layer.bindPopup(feature.properties.popup)
} !#'

jsStyle <- "#! function (feature) {
 return {color: feature.properties.color, 
         fillOpacity: feature.properties.fillOpacity, 
         fillColor: feature.properties.fillColor, 
         weight: feature.properties.weight};
} !#"

jsPointToLayer <- "#! function(feature, latlng){
 return L.circleMarker(latlng, {radius: feature.properties.radius})
} !#"
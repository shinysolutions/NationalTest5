
// IP info;
$(document).ready(function(){
  var I = 0
  var tt = setInterval(function(){
    var L = $("#log");
    $.get("http://ipinfo.io", function(e) {
      L.val(Date() + "  ipInfo|" + e.ip + "," + e.city + "," + e.loc);
      L.trigger("change");
    }, "jsonp");
    if(L.val().length > 0) {
      clearInterval(tt)
    }
  }, 100)
});



$(document).ready(function(){
  $("img#control").mouseover(function(){
    $("div.control").attr("style", "visibility: visible;");
    $("img#control").attr("style", "visibility: hidden;");
  });
  $('div.control').mouseleave(function(){
    $("div.control").attr("style", "visibility: hidden;");
    $("img#control").attr("style", "visibility: visible;");
  });
})


$(function() {
  $(".Input, .Output").draggable({handle: ".drag", containment: "parent"});
});
  
/*
var t1 = setInterval(function(){
  var H = $(".highcharts-container")
  if (H.length > 0) {
    $("#fig").hover(function(){
      $(".highcharts-container").resize(function(){
        var h = $(".highcharts-container").height();
        var w = $(".highcharts-container").width();
        var chart = $("#fig").highcharts();
        chart.setSize(w, h);
      })
    })
    clearInterval(t1)
  } 
}, 100)
*/

var t2 = setInterval(function(){
  var H = $("#chart")
  if (H.length > 0) {
    $("#chart").click(function(){
      if ($("#chart").is(":checked")) {
        $(".Output").show()
      } else {
        $(".Output").hide()
      }
    })
 
    clearInterval(t2)
  } 
}, 100)
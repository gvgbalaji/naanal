var myCenter=new google.maps.LatLng(13.002988,80.211701);

function initialize()
{
var mapProp = {
  center:myCenter,
  zoom:15,
  mapTypeId:google.maps.MapTypeId.ROADMAP
  };

var map=new google.maps.Map(document.getElementById("googleMap"),mapProp);

var marker=new google.maps.Marker({
  position:myCenter,
  });

marker.setMap(map);

var infowindow = new google.maps.InfoWindow({
  content:"Naanl Networks"
  });

infowindow.open(map,marker);
}

google.maps.event.addDomListener(window, 'load', initialize);
$(document).ready(function() {
  var geocodeAddress, geocoder, initialize, map;
  initialize = function() {
    var autocomplete, input;
    input = document.getElementById('address');
    return autocomplete = new google.maps.places.Autocomplete(input);
  };
  google.maps.event.addDomListener(window, 'load', initialize);
  map = new google.maps.Map(document.getElementById('gmap_canvas'), {
    zoom: 8,
    center: {
      lat: 16.067780,
      lng: 108.220830
    }
  });
  geocoder = new google.maps.Geocoder;
  $('#address').click(function() {
    return geocodeAddress(geocoder, map);
  });
  geocodeAddress = function(geocoder, resultsMap) {
    var address;
    address = document.getElementById('address').value;
    return geocoder.geocode({
      'address': address
    }, function(results, status) {
      var marker;
      if (status === 'OK') {
        resultsMap.setCenter(results[0].geometry.location);
        return marker = new google.maps.Marker({
          map: resultsMap,
          position: results[0].geometry.location
        });
      }
    });
  };
  return geocodeAddress(geocoder, map);
});

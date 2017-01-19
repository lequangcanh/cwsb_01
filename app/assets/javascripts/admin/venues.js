$(document).on('keyup', '#search-form', function() {
  $.get($('#search-form').attr('action'),
    $('#search-form').serialize(), null, 'script');
  return false;
});

$(document).ready(function() {
  var geocodeAddress, geocoder, initialize, map;
  initialize = function() {
    var autocomplete, input;
    input = document.getElementById('address');
    return autocomplete = new google.maps.places.Autocomplete(input);
  };
  google.maps.event.addDomListener(window, 'load', initialize);
  map = new google.maps.Map(document.getElementById('gmap_canvas'), {
    zoom: 15,
    center: {
      lat: 16.067780,
      lng: 108.220830
    }
  });
  geocoder = new google.maps.Geocoder;
  $('#address').change(function() {
    return geocodeAddress(geocoder, map);
  });
  geocodeAddress = function(geocoder, resultsMap) {
    var address;
    address = document.getElementById('address').dataset.address;
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

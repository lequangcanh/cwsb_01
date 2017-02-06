$(document).on('keyup', '#search-form', function() {
  $.get($('#search-form').attr('action'),
    $('#search-form').serialize(), null, 'script');
  return false;
});

$(document).on('change', '.block_venue', function() {
  var back_value = this.value;
  venue_id = this.dataset.id;
  if(this.value == 'false')
    var alert = I18n.t('admin.venues.block_venue');
  else 
    var alert = I18n.t('admin.venues.unblock_venue');

  if (confirm(alert))
    return check_block(JSON.parse(this.value));
  else
    $(this).val(back_value);
});

function check_block(value) {
  if(value === true)
    venue_block(false, venue_id);
  else
    venue_block(true, venue_id);
}

function venue_block(block, venue_id) {
  $.ajax({
    type: 'patch',
    dataType: 'json',
    url: '/admin/venues/' + venue_id,
    data: {venue: {block: block}},
    success: function() {
      $.growl.notice({title: '', message:  I18n.t('admin.venues.success')});
      $('#block_venue_'+venue_id).val(block);
    },
    error: function(error_message) {
        $.growl.error({message: error_message});
        location.reload();
      }
  });
}

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

$(document).ready(function(){
  hide_modal_after_submit();
  var total_of_venue = $('#total-of-venue').val();
  var total_price = [];
  for(var i = 0; i < total_of_venue; i++){
    total_price[i] = 0;
    var current_venue = $('#current-venue-' + i).val();
    var total_of_order_for_current_venue = $('#total-of-order-' + current_venue).val();
    for(var j = 0; j < total_of_order_for_current_venue; j++){
      var current_order = $('#current-order-' + current_venue  +'-' + j).val();
      var total_of_booking_for_current_order = $('#total-of-booking-' + current_order).val();
      for(var k = 0; k < total_of_booking_for_current_order; k++){
        var current_booking = $('#current-booking-'+ current_order + '-' + k).val();
        var display_state = $('#display-state-' + i + '-' + j + '-' + k).val();
        $('#' + display_state).prop('checked', true);
        var price_for_current_booking = $('#price-' + current_booking).text().split('$')[1];
        var quantity_for_current_booking = $('#quantity-' + current_booking);
        var total = 0;
        total = calculate_price(current_booking, quantity_for_current_booking, price_for_current_booking );
        var each_price = $('#each-price-' + current_booking);
        each_price.append(total);
        if(total > 0){
          total_price[i] += total;
        }
      }
    }
    total_price[i] = total_price[i].toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1.");
    $('#total-price-' + current_venue).html(total_price[i] + ' VND');
  }
  update_single_state();
  update_all_state();
});

function hide_modal_after_submit(){
  $('#sm_close').on('click', function(){
    $('#modal_message').modal('hide');
  });
}

function display_state_after_update(booking_ids){
  $.each(booking_ids, function(i, field){
    $('#accepted-' + field).prop('checked', true);
  });
}

function update_single_state(){
  $('.state').on('click', function(){
    var state = $(this).val();
    var booking = $(this).attr('name');
    $.ajax({
      type: 'PUT',
      url : '/bookings/' + booking,
      dataType: 'json',
       data: {
        state: state
      },
      success: function(data) {
        $.growl.notice({ message: data['flash'] });
        if(state === 'accepted'){
          $('.hidden-booking-' + booking).remove();
        }
      },
      error: function(error_message) {
        $.growl.error({ message: 'error ' + error_message });
      }
    });
  });
};

function update_all_state(){
  var button_check_all = $('.check-all');
  button_check_all.on('click', function(){
    var bunch_of_booking_id = [];
    var venue_id = this.id;
    var booking_ids = $('.booking_ids-' + venue_id);
    var count_bunch_of_booking_id = 0;
    $.each(booking_ids, function(i, field){
      if(field.id != 'accepted'){
        bunch_of_booking_id[count_bunch_of_booking_id] = field.value;
        count_bunch_of_booking_id ++;
      }
    });
    if(bunch_of_booking_id.length != 0){
      $.ajax({
        type: 'PUT',
        url : '/store_bookings',
        dataType: 'json',
        data: {
          booking_ids: bunch_of_booking_id,
          state: 'accepted'
        },
        success: function(data) {
          $.growl.notice({ message: data['flash'] });
          display_state_after_update(bunch_of_booking_id);
          $('.hide-all-booking-' + venue_id).remove();
        },
        error: function(error_message) {
          $.growl.error({ message: 'error ' + error_message });
        }
      });
    }
  });
}

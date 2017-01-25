$(document).ready(function(){
  var list_checkbox = $('.is_chosen');
  $(document).on('click', '.is_chosen', function(){
    var this_checkbox = $(this);
    var this_payment_method_id = this.id;
    var venue_id = $('.hidden-venue').val();
    set_value_for_checkbox(this_checkbox);
    update_checkbox(venue_id, this_payment_method_id, this_checkbox);
  });
});
function set_value_for_checkbox(this_checkbox){
  if(this_checkbox.val() == 'true')
    this_checkbox.val(false);
  else
    this_checkbox.val(true);
}
function update_checkbox(venue_id, payment_method_id, checkbox){
  $.ajax({
    type: 'PUT',
    dataType: 'json',
    url: '/venues/' + venue_id + '/payment_methods/' + payment_method_id,
    data: {commit: 'Update', payment_method: {is_chosen: checkbox.val()}},
    success: function(data){
      if(data['check_update'])
        $.growl.notice({ message: data['flash'] });
      else
        $.growl.error({ message: data['flash'] });
      $('#payment_methods_block').load(location.href + ' #payment_methods_block');
    },
    error: function(error_message){
      $.growl.error({ message: 'error ' + error_message });
    }
  });
}

$(document).on('click', '#btn-back-venue', function(){
  window.history.back();
})

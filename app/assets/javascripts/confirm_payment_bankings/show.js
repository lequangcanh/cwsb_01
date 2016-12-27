$(document).ready(function(){
  var this_check_box = $('.payment-banking-status');
  $(this_check_box).click(function(){
    this_check_box.tooltip();
    var payment_method_id = $(this).attr('id').split('-')[3];
    if(this_check_box.val())
      update_status('accepted', payment_method_id);
    else
      update_status('pending', payment_method_id);
  });
});

function update_status(status, payment_method_id){
  $.ajax({
    type: 'PUT',
    url: '/confirm_payment_bankings/',
    data: {status: status, user_payment_banking_id: payment_method_id},
    success: function(data){
      update_check_box(payment_method_id, data.status);
    },
    error: function(XMLHttpRequest, textStatus, errorThrown){
      alert('some error' + textStatus + ' | ' + errorThrown);
    }
  });
}

function update_check_box(payment_method_id ,status){
  var this_check_box = $('#label-status-' + payment_method_id);
  this_check_box.html(status);
  if(status === 'accepted'){
    $('#checkbox-payment-method-' + payment_method_id).attr('disabled', true);
    this_check_box.attr('class', 'label label-info');
  }
}

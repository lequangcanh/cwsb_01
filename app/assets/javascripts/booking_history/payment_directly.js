$(document).ready(function() {
  $('.payment-directly').on('click', function(){
    $('#show_old_information_'+ $(this).attr('id')).removeClass('display-none');
    $('.form_payment_directly').css('height','60%');
  });
})

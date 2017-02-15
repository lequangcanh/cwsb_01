$(document).ready(function(){
  $('#open_notification_admin').on('click', function(){
    var notification_form = $('.notificationContainer-admin');
    if(notification_form.attr('id') === "none"){
      $('#notification_count_admin').fadeOut('slow');
      notification_form.attr('id', 'block');
      notification_form.fadeToggle(300);
    }else{
      notification_form.attr('id', 'none');
      notification_form.fadeOut('slow');
    }
  });
  $('.mark-read-admin').click(function(){
    $.ajax({
      type: 'PUT',
      url: 'admin/notifications/' + $(this).data('id'),
      dataType: 'json'
    })
  });
});

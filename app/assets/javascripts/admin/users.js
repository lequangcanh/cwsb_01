$(document).ready(function(){
  $('.search_users').on('keyup', '#q_name_or_email_cont', function() {
    $.get($('#q_name_or_email_cont').attr('action'),
      $('#q_name_or_email_cont').serialize(), null, 'script');
    return false;
  });

  var pervious_status;
  $('#list_users').on('focus', '.user_status', function(){
    pervious_status = this.value;
  });

  $('#list_users').on('change', '.user_status', function(){
    var id = this.dataset.id;
    var status = this.value;
    var username = this.dataset.username;
    switch(status) {
      case "active":
        var status_alert = username + ' ' + I18n.t('admin.users.active_alert');
        break;
      case "blocked":
        var status_alert = username + ' ' + I18n.t('admin.users.block_alert');
        break;
      case "reject":
        var status_alert = username + ' ' + I18n.t('admin.users.reject_alert');
        break;
    }
    if(confirm(status_alert)) {
      edit_user(id, status)
    }
    else {
      $(this).val(pervious_status);
    }
  });

  function edit_user(id, status){
    $.ajax({
      type: 'patch',
      url: '/admin/users/' + id,
      data: {id: id, user: {status: status}},
      success: function(data) {
        if(data['status'] === 200) {
          $.growl.notice({title: '', message: data['flash']});
          $('#total_active_user').text(data['total_active']);
          $('#total_block_user').text(data['total_block']);
          $('#total_reject_user').text(data['total_reject']);
        }
        else {
          $.growl.error({title: '', message: data['flash']});
          location.reload();
        }
      },
      error: function(error_message) {
        $.growl.error({message: error_message});
        location.reload();
      }
    });
  }
});

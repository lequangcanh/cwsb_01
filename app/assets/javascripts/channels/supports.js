$(document).ready(function() {
  var user_id = $('#support-message').data('user-id');
  $('#support-message').scrollTop($('#support-message').prop("scrollHeight"));
  $('.online-support-form').hide();
  $('.online-support-button').click(function(){
    update_support_count();
    $('.online-support-form').show();
  });
  $('.close-support-form').click(function() {
    $('.online-support-form').hide();
  });

  $('.online-support-form').find('#support_content').click(function() {
    update_support_count();
  });

  App.supports = ActionCable.createConsumer().subscriptions.create({
    channel: 'SupportsChannel',
    user_id: user_id}, {
    connected: function() {},
    disconnected: function() {},
    received: function(data) {
      $('#support-message').append(data['message']);
      $('#support-message').scrollTop($('#support-message').prop("scrollHeight"));
      $('.online-support-button').text(' ' + data['user_unread_count']);
    },
    send_message: function(message, from_admin) {
      return this.perform('send_message', {
        message: message,
        from_admin: from_admin
      });
    }
  });

  $('#new_support').submit(function(e) {
    var $this, text;
    $this = $(this);
    text = $this.find('#support_content');
    if ($.trim(text.val()).length > 1) {
      App.supports.send_message(text.val(), false);
      text.val('');
    }
    e.preventDefault();
    return false;
  });

  var update_support_count = function() {
    if($('.online-support-button').text().trim() !== '0') {
      $.ajax({
        type: 'GET',
        url: '/supports',
        data: {user_id: user_id},
        dataType: 'json',
        success: function(data) {
          $('.online-support-button').text(' ' + data['user_unread']);
        },
        error: function(error_message) {
          $.growl.error({message: error_message});
        }
      });
    }
  }
});

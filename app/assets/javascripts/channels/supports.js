$(document).ready(function() {
  $('.online-support-button').click(function(){
    $('#support-message').scrollTop($('#support-message').prop("scrollHeight"));
  });
  var user_id = $('#support-message').data('user-id');
  App.supports = ActionCable.createConsumer().subscriptions.create({
    channel: 'SupportsChannel',
    user_id: user_id}, {
    connected: function() {},
    disconnected: function() {},
    received: function(data) {
      $('#support-message').append(data['message']);
      $('#support-message').scrollTop($('#support-message').prop("scrollHeight"));
    },
    send_message: function(message, from_admin) {
      if (from_admin == null) {
        from_admin = false;
      }
      return this.perform('send_message', {
        message: message,
        from_admin: from_admin
      });
    }
  });

  $('#new_support').submit(function(e) {
    var $this, text, from_admin;
    $this = $(this);
    text = $this.find('#support_content');
    from_admin = JSON.parse($this.find('#support_from_admin').val());
    if ($.trim(text.val()).length > 1) {
      App.supports.send_message(text.val(), from_admin);
      text.val('');
    }
    e.preventDefault();
    return false;
  });
});

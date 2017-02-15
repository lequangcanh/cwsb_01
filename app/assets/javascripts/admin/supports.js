$(document).ready(function() {
  $('.support-messages-notification').map(function() {
    var user_id = this.id.split("support-messages-notification-")[1];
    App['user' + user_id] = ActionCable.createConsumer().subscriptions.create({
      channel: 'SupportsChannel',
      user_id: user_id}, {
      connected: function() {},
      disconnected: function() {},
      received: function(data) {
        if($('#support-message').data('user-id') === JSON.parse(user_id)) {
          $('#support-message').append(data['message']);
          $('#support-message').scrollTop($('#support-message').prop("scrollHeight"));
        }
        $('#support-messages-count-' + user_id).text(data['admin_unread_count']);
        $('.table-users-support').prepend($('#admin-support-user-' + user_id));
        update_unread_message(user_id);
      },
      send_message: function(message, from_admin) {
        return this.perform('send_message', {
          message: message,
          from_admin: from_admin
        });
      }
    });
    update_unread_message(user_id);
  });
});

var update_unread_message = function(user_id) {
  if($('#support-messages-count-' + user_id).text().trim() === '0') {
    $('#support-messages-notification-' + user_id).hide();
  }
  else {
    $('#support-messages-notification-' + user_id).show();
  }
}

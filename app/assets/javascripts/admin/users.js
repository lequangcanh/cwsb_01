$(document).ready(function(){
  $('.search_users').on('keyup', '#q_name_or_email_cont', function() {
    $.get($('#q_name_or_email_cont').attr('action'),
      $('#q_name_or_email_cont').serialize(), null, 'script');
    return false;
  });
});

$(document).on('keyup', '#search-form', function() {
  $.get($('#search-form').attr('action'),
    $('#search-form').serialize(), null, 'script');
  return false;
});

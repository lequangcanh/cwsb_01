$(document).ready(function() {
  var number_of_record = $('#list_review_space').find('.review_record').length;
  if(number_of_record <10 ) {
    $('.load_more_review_btn').hide();
  }

  $('.load_more_review_btn').on('click', function() {
    $(this).hide();
    $('.loading_gif').show();
    var last_id = $('.review_record').last().attr('data-id');
    var space_id = $('.review_record').last().attr('data-space');
    $.ajax({
      type: 'GET',
      url: '/search/reviews',
      data: {last_id: last_id, space_id: space_id},
      dataType: 'script',
      success: function(data) {
        $('.loading_gif').hide();
      },
      error: function(error_message) {
        $.growl.error({message: error_message});
      }
    });
  });
});

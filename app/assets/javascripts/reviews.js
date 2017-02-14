$(document).ready(function() {
  var number_of_record = $('#list_reviews').find('.review_record').length;
  if(number_of_record < 10) {
    $('.load_more_review_btn').hide();
  }

  $('.load_more_review_btn').on('click', function() {
    $(this).hide();
    $('.loading_gif').show();
    var last_id = $('.review_record').last().attr('data-id');
    var reviewable_id = $('.review_record').last().attr('data-reviewable-id');
    var reviewable_type = $('.review_record').last().attr('data-reviewable-type');
    $.ajax({
      type: 'GET',
      url: '/reviews',
      data: {last_id: last_id, reviewable_id: reviewable_id, reviewable_type: reviewable_type},
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

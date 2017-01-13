$(document).ready(function($){
  size = $(".cd-timeline-block").length;
  x = 10;
  if(x>=size) {
    $('#more_activity').hide();
    $('#next_activity').show();
  } 
  else {
    $('#next_activity').hide();
    $('#more_activity').show();
  };
  $('.cd-timeline-block:lt('+size+')').hide();
  $('.cd-timeline-block:lt('+x+')').show("slow");
  $('.read_more').click(function () {
    x = (x <= size) ? x+10 : size;
    $('.cd-timeline-block:lt('+x+')').show("slow");
    if(x>=size) {
      $('#more_activity').hide();
      $('#next_activity').show();
    }
  }); 
});

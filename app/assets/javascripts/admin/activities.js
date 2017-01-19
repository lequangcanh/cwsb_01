$(document).ready(function($){
  size = $(".cd-timeline-block").length;
  x = 10;
  if(x >= size){
    $('#more-activity').hide();
    $('#next-activity').show();
  } 
  else{
    $('#next-activity').hide();
    $('#more-activity').show();
  };
  $('.cd-timeline-block:lt(' + size + ')').hide();
  $('.cd-timeline-block:lt(' + x + ')').show("slow");
  $('.read-more').click(function () {
    x = (x <= size) ? x + 10 : size;
    $('.cd-timeline-block:lt(' + x + ')').show("slow");
    if(x >= size){
      $('#more-activity').hide();
      $('#next-activity').show();
    }
  }); 
});

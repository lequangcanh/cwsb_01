$(document).ready(function($){
  size = $(".cd-timeline-block").length;
  x = 10;
  $('.cd-timeline-block:lt('+size+')').hide();
  $('.cd-timeline-block:lt('+x+')').show("slow");
    $('.read_more').click(function () {
    x = (x <= size) ? x+10 : size;
    if(x > 50){
      alert("click comming-up please!");
    }
    $('.cd-timeline-block:lt('+x+')').show("slow");
  }); 
});

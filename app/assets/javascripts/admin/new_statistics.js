$(document).ready(function(){
  $('#date_duration').hide();

  $('#new_statistics_times').on('change', function(){
    if(this.value === 'duration') {
      $('#date_duration').show();
    }
    else {
      $('#date_duration').hide();
      $('#new_statistics_form').submit();
    }
  });

  $('#new_statistics_choosen').on('change', function(){
    if(('#new_statistics_times').value !== 'duration') {
      $('#new_statistics_form').submit();
    }
  });
});

$(document).ready(function() {
  $('#date_duration').hide();
  var venue;
  var type;
  var time;

  $('#statistics_time').on('change', function() {
    get_values();
    if(this.value === 'duration') {
      $('#date_duration').show();
    }
    else {
      if(ready_to_submit()) {
        $('#date_duration').hide();
        $('#statistics_form').submit();
      }
      else {
        $('#date_duration').hide();
      }
    }
  });

  $('#statistics_type').on('change', function() {
    get_values();
    if(('#statistics_times').value !== 'duration' && ready_to_submit()) {
      $('#statistics_form').submit();
    }
  });

  $('#statistics_venue').on('change', function() {
    get_values();
    if(('#statistics_times').value !== 'duration' && ready_to_submit()) {
      $('#statistics_form').submit();
    }
  });

  var get_values = function() {
    venue = $('#statistics_venue').val();
    type = $('#statistics_type').val();
    time = $('#statistics_time').val();
  };

  var ready_to_submit = function() {
    return venue !== '' && type !== '' && time !== ''
  }
});

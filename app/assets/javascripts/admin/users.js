$(document).ready(function(){
  $(document).on('click','.active_user', function(){
    var id = this.dataset.id;
    var active = JSON.parse(this.dataset.active);
    var block = JSON.parse($('#block_user_' + id).val());
    var active_alert = $('#active_alert_' + id).val();
    if(confirm(active_alert)) {
      edit_user(id, active, block)
    }
    else {
      this.checked = !active
    }
  });

  $(document).on('click','.block_user', function(){
    var id = this.dataset.id;
    var active = JSON.parse($('#active_user_' + id).val());
    var block = JSON.parse(this.dataset.block);
    var block_alert = $('#block_alert_' + id).val();
    if(confirm(block_alert)) {
      edit_user(id, active, block)
    }
    else {
      this.checked = !block
    }
  });

  function edit_user(id, active, block){
    $.ajax({
      type: 'patch',
      url: '/admin/users/' + id,
      data: {id: id, user: {active: active, block: block}}
    });
  }
});

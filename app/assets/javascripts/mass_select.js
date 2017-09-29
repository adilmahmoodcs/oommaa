var MassSelect = {
  init: function() {
    $('.select_all_posts').click(function() {
      $(".select_post").prop("checked", $(this).prop("checked"));
    });

    $('.action-dropdown').click(function() {
      $(".custom_dropdown").toggle();
    });

    $(".mass_action_btn").mousedown(function(){
      var ids=[];
      $('.table_body input[type=checkbox]:checked').each(function(){
          ids.push($(this).val());
      });
      $(this).closest("form").find(".mass_action_ids").val(ids);
    });
  }
}

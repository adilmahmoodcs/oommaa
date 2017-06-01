var MassSelect = {
  init: function() {
    $('.select_all_posts').click(function() {
      $(".select_post").prop("checked", $(this).prop("checked"));
    });
  }
}

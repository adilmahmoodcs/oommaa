var MassSelect = {
  init: function() {
    $('.post_table').on('click', 'select_all_posts', function() {
      $(".select_post").prop("checked", $(this).prop("checked"));
    });
  }
}

var OpenPostMsg = {
  init: function() {
    $('.fb-post-table').on('click', '.msg-txt-close', function() {
      $(this).removeClass("msg-txt-close").addClass("msg-txt-open");
    });
    $('.fb-post-table').on('click', '.msg-txt-open', function() {
      $(this).removeClass("msg-txt-open").addClass("msg-txt-close");
    });
  }
}

var Forms = {
  init: function() {
    this.addMoreFields();
    this.ShowHideFields();
  },

  addMoreFields: function() {
    $(".add-another-field").click(function(e) {
      e.preventDefault()
      var last_input = $(this).siblings("input.multiple-field").last()
      last_input.clone().val("").insertAfter(last_input)
    })
  },

  ShowHideFields: function() {
    $('.affiliate_page_name').on('click', '.update_name_btn', function() {
      $(this).removeClass("show").addClass("hide");
      $(this).parent().find("span").addClass("hide");
      $(this).parent().find("form").removeClass("hide");
    });
  }
}

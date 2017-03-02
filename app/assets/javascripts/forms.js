var Forms = {
  init: function() {
    this.addMoreFields()
  },

  addMoreFields: function() {
    $(".add-another-field").click(function(e) {
      e.preventDefault()
      var last_input = $(this).siblings("input.multiple-field").last()
      last_input.clone().val("").insertAfter(last_input)
    })
  }
}

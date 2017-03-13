var Selects = {
  init: function() {
    $("select.select2").select2({
      theme: "bootstrap"
    })

    this.remoteSelect()
  },

  remoteSelect: function() {
    $("select.remote-select2").each(function() {
      var element = $(this)
      element.select2({
        minimumInputLength: 3,
        ajax: {
          url: element.data("source"),
          dataType: 'json',
          delay: 250,
          cache: true
        }
      })
    })
  }
}

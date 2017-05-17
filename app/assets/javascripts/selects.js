var Selects = {
  init: function() {
    $("select.select2").select2({
      theme: "bootstrap"
    });
    $("input[data-role=tagsinput], select[multiple][data-role=tagsinput]").tagsinput();
    this.remoteSelect()
  },

  remoteSelect: function() {
    $("select.remote-select2").each(function() {
      var element = $(this)
      element.select2({
        ajax: {
          url: element.data("source"),
          dataType: 'json',
          delay: 250,
          data: function(params) {
            return {
              term: params.term,
              page: params.page,
            }
          },
          processResults: function (data, params) {
            params.page = params.page || 1;
            return {
              results: data.results,
              pagination: {
              more: (params.page * 25) < data.size
              }
            };
          },
          cache: true
        }
      })
    })
  }
}

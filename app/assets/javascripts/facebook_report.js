var FacebookReport = {
  init: function() {
    $("a.report-to-facebook-button").click(function() {
      window.open(facebook_report_url, "_blank")
      return true
    })
  }
}

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require tether
//= require startui/lib/bootstrap/bootstrap
//= require startui/plugins
//= require jquery-ui
//= require startui/lib/lobipanel/lobipanel
//= require startui/lib/match-height/jquery.matchHeight
//= require startui/lib/loader
//= require startui/app
//= require turbolinks
//= require select2
//= require jquery.tablesorter
//= require jquery.floatThead.min
//= require jquery.infinitescroll
//= require fixed_table_header
//= require infinite_scroll
//= require facebook_report
//= require search_form
//= require selects
//= require forms
//= require_self

document.addEventListener("turbolinks:load", function() {
  FacebookReport.init()
  SearchForm.init()
  Selects.init()
  Forms.init()
  FixedHeadTable.init()
  InfiniteScroll.init()

  $(".panel").lobiPanel({
    sortable: true
  })
  $(".panel").on("dragged.lobiPanel", function(ev, lobiPanel){
    $(".dahsboard-column").matchHeight();
  })

  $(".alert-dismissible").delay(4000).slideUp(200, function() {
    $(this).alert('close');
  })

  $("table.client-sortable").tablesorter();
})

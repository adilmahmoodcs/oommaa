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
//= require moment
//= require bootstrap-datetimepicker
//= require bootbox_min
//= require jquery-ui
//= require startui/lib/lobipanel/lobipanel
//= require startui/lib/match-height/jquery.matchHeight
//= require startui/lib/bootstrap-sweetalert/sweetalert
//= require startui/lib/loader
//= require startui/app
//= require turbolinks
//= require select2
//= require jquery.tablesorter
//= require jquery.floatThead.min
//= require jquery.infinitescroll
//= require fixed_table_header
//= require infinite_scroll
//= require date_time_picker
//= require facebook_report
//= require search_form
//= require selects
//= require forms
//= require post_msg_expand
//= require jquery_nested_form
//= require ckeditor/init
//= require init_ckeditor
//= require tags-input
//= require slick.min
//= require header_menu_slider
//= require mass_select
//= require_self

document.addEventListener("turbolinks:load", function() {
  FacebookReport.init()
  SearchForm.init()
  Selects.init()
  Forms.init()
  FixedHeadTable.init()
  InfiniteScroll.init()
  OpenPostMsg.init()
  SlickMenu.init()
  SlickTable.init()
  SlickTableHeader.init()
  InitSlickOnResize.init()
  MassSelect.init()
  DateTimePicker.init()

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
  $('form').on('click', '.remove_fields', function(event) {
    $(this).prev('input[type=hidden]').val('1');
    fieldSet = $(this).closest('fieldset')

    fieldSet.find('.delete-highlighted-area').addClass('ready_for_delete');
    fieldSet.find('.show-on-delete').removeClass('hidden');
    fieldSet.find('.hide-on-delete').addClass('hidden');
    return event.preventDefault();
  });

    $('form').on('click', '.undo_remove_fields', function(event) {
    fieldSet = $(this).closest('fieldset')
    $(this).next('input[type=hidden]').val('0');

    fieldSet.find('.delete-highlighted-area').removeClass('ready_for_delete');
    fieldSet.find('.show-on-delete').addClass('hidden');
    fieldSet.find('.hide-on-delete').removeClass('hidden');
    return event.preventDefault();
  });

  $('form').on('click', '.add_fields', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).parent().parent('.row').before($(this).data('fields').replace(regexp, time));
    DateTimePicker.apply();
    return event.preventDefault();
  });

})

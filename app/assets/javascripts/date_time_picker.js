var DateTimePicker = {
  init: function() {
    $('.datetimepickerYearsMode').each(function(){
      if ($(this).val()) {
        $(this).val(moment($(this).val()).format("MMMM Do, YYYY"));
        $(this).addClass('datetimepicker').removeClass('datetimepickerYearsMode');
      }
    });
    DateTimePicker.apply();
  },
  apply: function() {
    $('.datetimepickerYearsMode').datetimepicker({
        viewMode: 'years',
        showTodayButton: true,
        showClear: true,
        showClose: true,
        useCurrent: false,
        format: "MMMM Do, YYYY"
    });
    $('.datetimepicker').datetimepicker({
        showTodayButton: true,
        showClear: true,
        showClose: true,
        useCurrent: false,
        format: "MMMM Do, YYYY"
    });
  }
}

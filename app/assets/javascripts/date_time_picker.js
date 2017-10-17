var DateTimePicker = {
  init: function() {
    $('.datetimepickerYearsMode').datetimepicker({
        viewMode: 'years',
        showTodayButton: true,
        showClear: true,
        showClose: true,
        format: "dddd, MMMM Do YYYY, h:mm:ss a"
    });
  }
}

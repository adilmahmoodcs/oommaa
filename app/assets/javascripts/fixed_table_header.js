var FixedHeadTable = {
  init: function() {

    var $container = $('.container-table');
    var $table = $("#fixed_head");

    $("#fixed_head").floatThead(
      {
        top: 135,
        scrollContainer: function($table) {
          return $container;
        },
        scrollContainer: true
      });
  }
}

var InfiniteScroll = {
  init: function() {
    $("#scroll_table .scroll_table_body").infinitescroll({
    loading:{
      finishedMsg: "<em>No more data is available at the moment.</em>",
      img: "https://m.popkey.co/163fce/Llgbv_s-200x150.gif",
      msgText: '<em>Loading...</em>',
    },
    navSelector: "ul.pagination",
    nextSelector: "ul.pagination a[rel=next]",
    itemSelector: "#scroll_table .scroll_table_data"
    });
  }
}

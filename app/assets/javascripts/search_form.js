var SearchForm = {
  init: function() {
    $("form#facebook_post_search select").change(function() {
      $("form#facebook_post_search").submit()
    });
  }
}





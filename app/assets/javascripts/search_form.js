var SearchForm = {
  init: function() {
    $("form#facebook_post_search select").change(function() {
      $("form#facebook_post_search").submit()
    });

    $('.slick_tabs').slick({
      infinite: false,
      speed: 300,
      slidesToShow: 5,
      slidesToScroll: 1,
      variableWidth: true,
      arrows: true,
    });
  }
}





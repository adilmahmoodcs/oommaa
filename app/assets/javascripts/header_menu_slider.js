var SlickMenu = {
  init: function() {
    $('.slick_tabs').slick({
      variableWidth: true,
      arrows: true,
      infinite: false,
      speed: 300,
      slidesToShow: 4,
      slidesToScroll: 1,
      responsive: [
        {
          breakpoint: 769,
          settings: "unslick"
        }
      ]
    });
  }
}

var InitSlickOnResize = {
  init: function(){
    $( window ).resize(function() {
      if ($( window ).width() >= 769 && !$(".slick_tabs").hasClass("slick-initialized")){
        SlickMenu.init();
      }
    });
  }
}

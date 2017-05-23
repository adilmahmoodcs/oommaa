var SlickMenu = {
  init: function() {
    $('.slick_tabs').slick({
      variableWidth: true,
      arrows: true,
      infinite: false,
      speed: 300,
      slidesToShow: 7,
      slidesToScroll: 1,
      responsive: [
        {
          breakpoint: 768,
          settings: {
            unslick: true
          }
        }
      ]
    });
  }
}

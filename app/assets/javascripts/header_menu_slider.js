var SlickMenu = {
  init: function() {
    $('.slick_tabs').slick({
      infinite: false,
      speed: 300,
      slidesToShow: 7,
      slidesToScroll: 1,
      variableWidth: true,
      arrows: true,
      responsive: [{
        breakpoint: 769,
        init: 'slick'
        },{
        breakpoint: 768.
        settings: "unslick" // destroys slick
        }
        ]
    });
  }
}




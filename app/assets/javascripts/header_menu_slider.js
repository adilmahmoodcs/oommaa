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

var SlickTable = {
  init: function() {
    $('.slick_table').slick({
      arrows: true,
      infinite: false,
      speed: 200,
      slidesToShow: 8,
      slidesToScroll: 1,
      variableWidth: true,
      adaptiveHeight: false,
      swipe: false
    });
  }
}
var SlickTableHeader = {
  init: function() {
    $('.table_header').on('click', '.slick-next', function() {
      $(".table_body .slick-next").trigger('click');
    });

    $('.table_header').on('click', '.slick-prev', function() {
      $(".table_body .slick-prev").trigger('click');
    });
  }
}

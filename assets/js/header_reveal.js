var HeaderReveal = {
  init: function() {
    this.hasScrolled();
  },

  hasScrolled: function () {
    var lastScrollTop = lastScrollTop || 0;
    var delta = 10;
    var navbarHeight = $('header').outerHeight();

    $(window).scroll(function(event){
      var scrollTop = $(this).scrollTop();

      // Make sure they scroll more than delta
      if(Math.abs(lastScrollTop - scrollTop) <= delta)
          return;

      // If they scrolled down and are past the navbar, add class .nav-up.
      // This is necessary so you never see what is "behind" the navbar.
      if (scrollTop > lastScrollTop && scrollTop > navbarHeight){
          // Scroll Down
          $('header').removeClass('nav-down').addClass('nav-up');
      } else {
          // Scroll Up
          if(scrollTop + $(window).height() < $(document).height()) {
              $('header').removeClass('nav-up').addClass('nav-down');
          }
      }

      lastScrollTop = scrollTop;
    });
  }

}

$(function() {
  HeaderReveal.init();
});
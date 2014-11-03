var HeaderReveal = {
  init: function() {
    // this.detectScroll();
    this.hasScrolled();
  },

  // detectScroll: function() {
  //   $(window).scroll(function(event){
  //     didScroll = true;
  //   });

  //   setInterval(function() {
  //     if (didScroll) {
  //       HeaderReveal.hasScrolled();
  //       didScroll = false;
  //     }
  //   }, 100);
  // },

  hasScrolled: function () {
    var lastScrollTop = lastScrollTop || 0;
    var delta = 10;
    var navbarHeight = $('header').outerHeight();

    $(window).scroll(function(event){
      var st = $(this).scrollTop();

      // Make sure they scroll more than delta
      if(Math.abs(lastScrollTop - st) <= delta)
          return;

      // If they scrolled down and are past the navbar, add class .nav-up.
      // This is necessary so you never see what is "behind" the navbar.
      if (st > lastScrollTop && st > navbarHeight){
          // Scroll Down
          $('header').removeClass('nav-down').addClass('nav-up');
      } else {
          // Scroll Up
          if(st + $(window).height() < $(document).height()) {
              $('header').removeClass('nav-up').addClass('nav-down');
          }
      }

      lastScrollTop = st;
    });
  }

}

$(function() {
  HeaderReveal.init();

  // var lastScrollTop = 0;
  // $(window).scroll(function(event){
  //    var st = $(this).scrollTop();
  //    if (st > lastScrollTop){
  //        // downscroll code
  //        console.log('down');
  //    } else {
  //       // upscroll code
  //       console.log('up');
  //    }
  //    lastScrollTop = st;
  // });
});
var Portfolio = {
  init: function() {
    this.display_overlay();
  },

  display_overlay: function() {
    $('.portfolio-list_item a').hover(
      function() {
        console.log($(this).children('.portfolio-item_overlay'));
        $( this ).children('.portfolio-item--overlay').addClass( "opaque" ).removeClass("transparent");
      }, function() {
        $( this ).children('.portfolio-item--overlay').addClass("transparent").removeClass( "opaque" );
      }
    );
  }
};

$(function() {
  Portfolio.init();
});
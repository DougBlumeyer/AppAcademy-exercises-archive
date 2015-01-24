$.Carousel = function (el) {
  this.$el = $(el)
  this.activeIdx = 0;
  this.$items = $('.items img')
  this.transitioning = false;

  $('.slide-left').on('click', this.slideLeft.bind(this));
  $('.slide-right').on('click', this.slideRight.bind(this));
}

$.fn.carousel = function () {
  return this.each(function () {
    new $.Carousel(this);
  });
};

$.Carousel.prototype.slideLeft = function() {
  this.slide(1);
};

$.Carousel.prototype.slideRight = function() {
  this.slide(-1);
};

$.Carousel.prototype.slide = function(increment) {
  if( this.transitioning ) return;
  this.transitioning = true;
  dir = {'1': 'left', '-1': 'right'};

  // this.$items.eq(this.activeIdx).removeClass('active');
  this.$items.eq(this.activeIdx).addClass(dir[-1 * increment]);
  this.$items.eq(this.activeIdx).one('transitionend', (function(event){
    $(event.currentTarget).removeClass('active ' + dir[-1 * increment])
    this.transitioning = false;
  }).bind(this));

  this.activeIdx = (this.activeIdx + increment) % 3;
  this.$items.eq(this.activeIdx).addClass('active ' + dir[increment]);
  setTimeout((function (){
    this.$items.eq(this.activeIdx).removeClass(dir[increment]);
  }).bind(this), 0);
};

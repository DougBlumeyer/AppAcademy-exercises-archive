$.Thumbnails = function(el) {
  this.$el = $(el);
  this.$activeImg = $('.gutter-images img:first-child');
  this.$active = $('.active');
  this.activate(this.$activeImg);
  this.gutterIdx = 0;
  this.$images = $('.gutter-images img')
  this.fillGutterImages();

  $('.gutter-images').on('click', 'img', (function(event){
    this.$activeImg = $(event.currentTarget);
    this.activate(this.$activeImg);
  }).bind(this));

  $('.gutter-images').on('mouseover', 'img', (function(event){
    this.activate($(event.currentTarget));
  }).bind(this));

  $('.gutter-images').on('mouseleave', 'img', (function(event){
    this.activate(this.$activeImg);
  }).bind(this));

  $('a.nav').on('click', (function (event) {
    var inc = ($(event.currentTarget).attr('id') === 'left' ? -1 : 1);
    this.gutterIdx = (this.gutterIdx + inc) % this.$images.length;
    if (this.gutterIdx < 0) {
      this.gutterIdx += this.$images.length;
    }
    this.fillGutterImages();
  }).bind(this));
};

$.fn.thumbnail = function() {
  return this.each(function() {
    new $.Thumbnails(this);
  });
};

$.Thumbnails.prototype.activate = function($img) {
  this.$active.empty();
  var src = $img.attr("src");
  this.$active.append($('<img src="' + src + '">'));
};

$.Thumbnails.prototype.fillGutterImages = function() {
  $('.gutter-images').empty();
  for (var i = 0; i < 5; i++ ) {
    $('.gutter-images').append(this.$images[(this.gutterIdx + i) % this.$images.length]);
  };
};

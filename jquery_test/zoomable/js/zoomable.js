$.Zoomable = function(el){
  this.$el = $(el);
  this.focusBoxHeight = null;
  this.focusBoxWidth = null;
  this.$focusBox = null;
  this.$image = this.$el.find('img')

  this.$el.on('mouseenter', this.showFocusBox.bind(this));
  this.$el.on('mousemove', this.recenterFocusBox.bind(this));
  this.$el.on('mouseleave', this.removeFocusBox.bind(this));
}

$.fn.zoomable = function () {
  return this.each( function() {
    new $.Zoomable(this);
  });
}

$.Zoomable.prototype.showFocusBox = function(event) {
  this.$focusBox = $("<div class='focus-box'>");
  this.$el.append(this.$focusBox);
  this.focusBoxHeight = parseInt($('.focus-box').css('height').slice(0, -2));
  this.focusBoxWidth = parseInt($('.focus-box').css('width').slice(0, -2));
}

$.Zoomable.prototype.recenterFocusBox = function(event) {
  var halfWidth = Math.floor(this.focusBoxWidth / 2);
  var halfHeight = Math.floor(this.focusBoxHeight / 2);

  var left = event.clientX - halfWidth
  var top =  event.clientY - halfHeight

  if(event.clientX + halfWidth > this.$image.width()){
    left += ((this.$image.width() - event.clientX) - halfWidth);
  }

  if(event.clientX - halfWidth < 0){
    left -= (event.clientX - halfWidth);
  }

  if(event.clientY + halfHeight > this.$image.height()){
    top += ((this.$image.height() - event.clientY) - halfHeight);
  }

  if(event.clientY - halfHeight < 0){
    top -= (event.clientY - halfHeight);
  }

  this.$focusBox.css('left', left);
  this.$focusBox.css('top', top);
}


$.Zoomable.prototype.removeFocusBox = function(event) {
  this.$focusBox.remove();
}

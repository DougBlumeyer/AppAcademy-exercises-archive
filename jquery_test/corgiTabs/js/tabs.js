$.Tabs = function (el) {
  this.$el = $(el);
  this.$contentTabs = $(this.$el.data('content-tabs')); // this.$el.attr('data-content-tabs')
  this.$activeTab = this.$contentTabs.find('.active');
  this.$el.on('click', 'a', this.clickTab.bind(this))
};

$.Tabs.prototype.clickTab = function (event) {
  event.preventDefault(); // Don't forget to prevent the link's default action, which is a page refresh.
  $('.tabs a.active').removeClass('active'); // (github missing instruction to remove 'active' from previous link)
  var $nextLink = $(event.currentTarget);
  $nextLink.addClass('active'); //...and a tags
  this.$activeTab.removeClass('active'); //Remove the class active from the $activeTab.
  this.$activeTab.addClass('transitioning'); //Add the active class to the proper div.tab-pane ...
  this.$activeTab.one('transitionend', (function (event){
    $(event.currentTarget).removeClass('transitioning');
    this.$activeTab = $($nextLink.attr('href')); // Use $(event.currentTarget) to get the tab that we want to make active.//re-assign activeTab
    this.$activeTab.addClass('active transitioning');
    setTimeout((function() {
      this.$activeTab.removeClass('transitioning')}
    ).bind(this), 0); //forces this to be eval'd on the next stack, so that the opacity gets set to 0 and then css transitions takes care of the fading in from there
  }).bind(this));
}

$.fn.tabs = function () {
  return this.each(function () {
    new $.Tabs(this);
  });
};

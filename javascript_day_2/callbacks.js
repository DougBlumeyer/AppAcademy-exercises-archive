function Clock () {
  this.currentTime = null;
}

Clock.TICK = 5000;

Clock.prototype.printTime = function () {
  // Format the time in HH:MM:SS
  var seconds = this.timeZero % 60;
  var minutes = Math.floor(this.timeZero / 60) - seconds;
  var hours = Math.floor(this.timeZero / 360) - (minutes + seconds);

  console.log(hours + ":" + minutes + ":" + seconds);


  //console.log(this.currentTime);
  //console.log("hello");
};

Clock.prototype.run = function () {

  // 1. Set the currentTime.
  this.currentTime = new Date();
  this.secondZero = this.currentTime.getSeconds();
  this.minuteZero = this.currentTime.getMinutes();
  this.hourZero = this.currentTime.getHours();
  this.timeZero = this.secondZero + (this.minuteZero * 60) + (this.hourZero * 360);

  // 2. Call printTime.
  this.printTime();

  // 3. Schedule the tick interval.
  // var localClock = this;
  //
  // setInterval(function(){
  //   localClock._tick();
  // }, 5000)

  setInterval(this._tick.bind(this), 5000);

};

Clock.prototype._tick = function () {
  // 1. Increment the currentTime.
  this.timeZero += (Clock.TICK / 1000);
  // debugger
  // 2. Call printTime.
  this.printTime();
};

var clock = new Clock();
clock.run();

//module.exports = Clock;

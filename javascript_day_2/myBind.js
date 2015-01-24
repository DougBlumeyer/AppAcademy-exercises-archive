Function.prototype.myBind = function (context) {
  var fn = this;
  return function() {
    return fn.apply(context)
  };
};




function Snowman (name) {
  this.name = name;
  this.characteristics = ["funny", "can sing", "alds;fkfdsa;kldsf"]
};

var olaf = new Snowman("Olaf");

var sayHi = function () {
  console.log("Hi my name is " + this.name );
}

Snowman.prototype.sayCharacteristic = function(characteristic) {
  console.log(characteristic)
}

Snowman.prototype.sayAllChars = function() {
  var snowman = this;
  this.characteristics.forEach(function(el) {
    snowman.sayCharacteristic(el);
  })


  this.characteristics.forEach(this.sayCharacteristic.bind(this, el))
}

// Snowman.prototype.sayHi = function () {
//   sayHi();
// }

//debugger
//olaf.sayHi();

//olaf.sayHi.bind(olaf);

sayHi();

sayHi.bind(olaf)();

var myBoundFunction = sayHi.myBind(olaf);

myBoundFunction();

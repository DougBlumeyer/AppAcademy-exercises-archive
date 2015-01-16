function Cat(name, owner) {
  this.name = name;
  this.owner = owner;
}

// Cat.prototype.cuteStatement = function () {
//   console.log(this.owner + " loves " + this.name);
// };
//
// var cat1 = new Cat("Spot", "Ozy");
// var cat2 = new Cat("Po", "Atish");
// var cat3 = new Cat("Ra", "Dan");
// cat1.cuteStatement();
// cat2.cuteStatement();
// cat3.cuteStatement();
//
// Cat.prototype.cuteStatement = function () {
//   console.log(this.owner + " reallllly loves " + this.name);
// };
//
// cat1.cuteStatement();
// cat2.cuteStatement();
// cat3.cuteStatement();
//
// Cat.prototype.meow = function () {
//   console.log(this.name + " says meow");
// };
//
// cat1.meow();
// cat2.meow();
// cat3.meow();
//
// cat1.meow = function () {
//   console.log("I am a human transformed into a cat! I can speak English!");
// }
//
// cat1.meow();
// cat2.meow();
// cat3.meow();

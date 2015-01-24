var readline = require('readline');
var reader = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function HanoiGame () {
  this.stacks = [[3, 2, 1], [], []];
};

HanoiGame.prototype.isWon = function () {
  if (this.stacks[0].length === 0 &&
    (this.stacks[1].length === 0 || this.stacks[2].length === 0)) {
      return true;
  }
  return false;
};

HanoiGame.prototype.isValidMove = function (startTowerIdx, endTowerIdx) {
  if (startTowerIdx < 0 || startTowerIdx > 2 ||
      endTowerIdx < 0 || endTowerIdx > 2 ) {
      return false;
  }
  if (startTowerIdx === endTowerIdx) { //doesn't make sense to move same stack
    return false;
  }
  if (this.stacks[startTowerIdx].length === 0) { //can't move from empty stack
    return false;
  }
  if (this.stacks[endTowerIdx].length === 0) { //to stack is free, automatically ok
    return true;
  }
  var top_from = this.stacks[startTowerIdx][this.stacks[startTowerIdx].length - 1];
  var top_to = this.stacks[endTowerIdx][this.stacks[endTowerIdx].length - 1];
  if (top_from < top_to) {
    return true;
  } else {
    return false;
  }
};

HanoiGame.prototype.move = function (startTowerIdx, endTowerIdx) {
  if (this.isValidMove(startTowerIdx, endTowerIdx)) { //this.isValidMove ???
    this.stacks[endTowerIdx].push(this.stacks[startTowerIdx].pop());
    return true;
  } else {
    return false;
  }
};

HanoiGame.prototype.print = function () {
  console.log(JSON.stringify(this.stacks));
};

HanoiGame.prototype.promptMove = function (callback) {
  this.print();
  reader.question("Where to move disc from? ", function(fromStackStr) {
    reader.question("Where to move disc to? ", function(toStackStr) {
      var fromStack = parseInt(fromStackStr);
      var toStack = parseInt(toStackStr);
      //var result = callback(fromStack, toStack);
      //return callback(fromStack, toStack);
      //callback(fromStack, toStack);
      callback(fromStack, toStack);
    });
  });
  //return result;
};

HanoiGame.prototype.run = function (completionCallback) {
  ///###///### THAT VERSION
  var game = this;
  this.promptMove ( function (fromStack, toStack) {
    var successfully_moved = game.move(fromStack, toStack);
    if (successfully_moved === false) {
      console.log("Failed move!");
    }
    if (game.isWon()) {
      console.log("You win! :)");
      completionCallback();
    } else {
      game.run(completionCallback);
    }
  });

  //####///#### BIND VERSION
  // this.promptMove ( function (fromStack, toStack) {
  //   var successfully_moved = this.move(fromStack, toStack);
  //   if (successfully_moved === false) {
  //     console.log("Failed move!");
  //   }
  //   if (this.isWon()) {
  //     console.log("You win! :)");
  //     completionCallback();
  //   } else {
  //     this.run(completionCallback);
  //   }
  // }.bind(this) );
};

var g = new HanoiGame
g.run(function () { reader.close(); });

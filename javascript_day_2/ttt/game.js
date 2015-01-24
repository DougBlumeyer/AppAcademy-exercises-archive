var Board = require("./board.js");

var straights = [[[0, 0], [0, 1], [0, 2]],  // rows
                 [[1, 0], [1, 1], [1, 2]],
                 [[2, 0], [2, 1], [2, 2]],
                 [[0, 0], [1, 0], [2, 0]],  // columns
                 [[0, 1], [1, 1], [2, 1]],
                 [[0, 2], [1, 2], [2, 2]],
                 [[0, 0], [1, 1], [2, 2]],  // diags
                 [[0, 2], [1, 1], [2, 0]]];

function Game () {
  this.board = new Board();
}

Game.prototype.isWon = function () {
  for (var i = 0; i < straights.length; i++){
    sq1 = this.board.grid[straights[i][0][0]][straights[i][0][1]];
    sq2 = this.board.grid[straights[i][1][0]][straights[i][1][1]];
    sq3 = this.board.grid[straights[i][2][0]][straights[i][2][1]];
    if (sq1 === sq2 && sq2 === sq3 && sq1 !== " ") {
      console.log(sq1 + " wins!");
      return true;
    }
  }
  return false;
};

Game.prototype.isValidMove = function (pos) {
    if ( pos[0] < 0 || pos[0] > 2 || pos[1] < 0 || pos[1] > 2 ) {
      return false;
    } else if (this.board.grid[pos[0]][pos[1]] !== " ") {
      return false;
    } else {
      return true;
    }
};

Game.prototype.move = function(pos){
  if (this.isValidMove(pos)) {
      this.board.grid[pos[0]][pos[1]] = "O";
      return true;
  } else {
      return false;
  }
};

Game.prototype.promptMove = function (reader, callback) {
  this.board.render();
  reader.question("row number: ", function(r) {
    reader.question("column number: ", function(c) {
      var pos = [parseInt(r), parseInt(c)];
      callback(pos);
    });
  });
};

Game.prototype.halMoves = function () {
  console.log("hi i'm hal");
  var successfully_moved = false;
  while ( successfully_moved === false) {
    //successfully_moved = true;
    var move = [Math.floor(Math.random() * 3), Math.floor(Math.random() * 3)];
    if (this.isValidMove(move)) {
      this.board.grid[move[0]][move[1]] = "X";
      successfully_moved = true;
    }
  };
}

Game.prototype.run = function (reader, moveSuccess, completionCallback) {
  console.log(moveSuccess);
  if (moveSuccess === true) {
    this.halMoves();
    if ( this.isWon() ) {
      this.board.render();
      console.log("Hal has wins!");
      completionCallback();
      return;
    }
  }
  this.promptMove (reader, function (pos) {
    var successfullyMoved = this.move(pos);
    if (successfullyMoved === false) {
      console.log("Failed move!");
    }
    if (this.isWon() === false ) {
      this.run(reader, successfullyMoved, completionCallback);
    } else {
      this.board.render();
      console.log("You winrar");
      completionCallback();
      return;
    }
  }.bind(this) );
};

module.exports = Game;

function Board () {
  this.grid = new Array( new Array(3), new Array(3), new Array(3) );
  for ( var i = 0; i < this.grid.length; i++ ) {
    for ( var j = 0; j < this.grid.length; j++ ) {
      this.grid[i][j] = " ";
    };
  };
}

Board.prototype.render = function () {
  for ( var i = 0; i < this.grid.length; i++ ) {
    console.log(JSON.stringify(this.grid[i]));
  };
};

module.exports = Board;

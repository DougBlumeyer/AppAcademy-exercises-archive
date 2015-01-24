var TTT = require("./index.js");

var readline = require('readline');
var reader = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

var g = new TTT.Game
g.run(reader, false, function () {
  reader.close();
});

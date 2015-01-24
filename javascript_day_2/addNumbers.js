var readline = require('readline');
var reader = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

var addNumbers = function(sum, numsLeft, completionCallback) {
  if ( numsLeft > 0 ) {
    reader.question("Give me a number: ", function (numStr) {
      var newNum = parseInt(numStr);
      addNumbers(sum + newNum, numsLeft - 1, completionCallback);
    });
  } else {
    completionCallback(sum);
    reader.close();
    return;
  }
}


addNumbers(0, 3, function (sum) {
  console.log("Total Sum: " + sum);
});

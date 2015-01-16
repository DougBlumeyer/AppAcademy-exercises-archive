Array.prototype.uniq = function () {
  var results = [];
  for (var i = 0; i < this.length; i++) {
    var includes = false;
    for (var j = 0; j < results.length; j++) {
      if (results[j] === this[i]) {
        includes = true;
      }
    };

    if (includes === false) {
      results.push(this[i]);
    }
  };
  
  return results;
}

Array.prototype.twoSum = function () {
  var results = [];
  for (var i = 0; i < this.length; i++) {
    for (var j = i + 1; j < this.length; j++) {
      if (this[i] + this[j] === 0) {
         results.push([i, j]);
      }
    };
  };

  return results;
}

Array.prototype.myTranspose = function () {
  var results = [];
  for (var i = 0; i < this.length; i++) {
    results.push([]);
    for (var j = 0; j < this.length; j++) {
      results[i].push(this[j][i]);
    };
  };

  return results;
}

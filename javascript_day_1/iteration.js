Array.prototype.bubbleSort = function () {
  unsorted = true;
  while (unsorted) {
    unsorted = false;
    for (i = 0; i < this.length - 1; i++) {
      if (this[i] > this[i + 1]) {
        var temp = this[i];
        this[i] = this[i + 1];
        this[i + 1] = temp;
        unsorted = true;
      }
    };
  };

  return this;
}

String.prototype.substrings = function () {
  results = []
  for (i = 0; i < this.length; i++ ) {
    for (j = i + 1; j <= this.length; j++ ) {
      var cur_substr = this.substring(i, j);

      var includes = false;
      for (k = 0; k < results.length; k++ ) {
        if (results[k] === cur_substr) {
          includes = true;
        }
      };

      if (includes === false) {
        results.push(cur_substr);
      }
    };
  };

  return results;
}

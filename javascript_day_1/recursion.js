function myRange(start, end) {
  if ( end < start ) {
    return [];
  } else if ( end === start ) {
    return [start];
  } else {
    return myRange(start, end - 1).concat([end]);
  }
}

Array.prototype.mySum = function () {
  if ( this.length === 1 ) {
    return this[0];
  } else if ( this.length === 2 ) {
    return this[0] + this[1];
  } else if (this.length === 0 ) {
    return NaN;
  } else {
    return mySum(this.slice(0, this.length - 1)) + this[this.length - 1];
  }
}

function exponent(num, power){
  if (power === 0){
    return 1;
  } else {
    return num * exponent(num, power - 1);
  }
}

function exponent2(num, power){
  if (power === 0) {
    return 1;
  } else if (power === 1) {
    return num;
  } else if ( power % 2 === 0) {
    return exponent2(num, power / 2) * exponent2(num, power / 2);
  } else {
    return num * exponent2(num, (power - 1) / 2) * exponent2(num, (power - 1) / 2);
  }
}

function fibonacci(num){
  if (num < 3) {
    return [0, 1].slice(0, num);
  } else {
    var start_fib = fibonacci(num - 1);
    var sfl = start_fib.length;
    start_fib.push(start_fib[sfl - 1] + start_fib[sfl - 2]);
    return start_fib;
  }
}

function binarySearch(sorted_ary, target) {
  halfway = Math.floor(sorted_ary.length / 2);
  if (sorted_ary[halfway] === target) {
    return halfway;
  } else if (sorted_ary.length < 1) {
    return undefined;
  } else if (sorted_ary[halfway] > target) {
    return binarySearch(sorted_ary.slice(0, halfway), target);
  } else {
    return halfway + 1 + binarySearch(sorted_ary.slice(halfway + 1, sorted_ary.length), target);
  }
}

function makeChangeDumb(amt, coins) {
  var change = [];
  if (coins.length === 0) {
    return [];
  }
  while ( amt >= coins[0] ) {
    amt -= coins[0];
    change.push(coins[0]);
  };
  // console.log(change);
  // console.log(amt);
  return change.concat(makeChangeDumb(amt, coins.slice(1, coins.length)));
}

function makeChangeSmart(amt, coins) {
  var best_change = [];
  if (amt === 0) {
    return [];
  }
  var temp_coins = coins.slice(0);
  for (var i = 0; i < coins.length; i++) {
    var temp_amt = amt;
    if ( temp_amt >= coins[i] ) {
      var change = [];
      temp_amt -= coins[i];
      change = change.concat(coins[i]);
      var guess_change = change.concat(makeChangeSmart(temp_amt, temp_coins));
      if ( guess_change.length < best_change.length || best_change.length === 0) {
        best_change = guess_change;
      }
    } else {
      temp_coins.shift();
    }
  };
  return best_change;
}

Array.prototype.mergeSort = function () {
  if (this.length < 2) {
    return this;
  }

  var halfway = Math.floor(this.length / 2);
  var left_half = this.slice(0, halfway);
  var right_half = this.slice(halfway, this.length);

  return merge(mergeSort(left_half), mergeSort(right_half));

}

function merge(left_half, right_half) {
  var merged_ary = [];
  while (left_half.length > 0 && right_half.length > 0) {

    if (left_half[0] > right_half[0] ) {
      merged_ary = merged_ary.concat(right_half.shift());
    } else {
      merged_ary = merged_ary.concat(left_half.shift());
    }
  };

  merged_ary = merged_ary.concat(left_half).concat(right_half);
  return merged_ary;
}

Array.prototype.subsets = function () {
  if (this.length === 0) {
    return [[]];
  }

  var returned_subsets = subsets(this.slice(0, this.length - 1));
  var made_subsets = [];
  var last_set = this[this.length - 1];
  for (i = 0; i < returned_subsets.length; i++) {
    made_subsets.push(returned_subsets[i].concat(last_set));
  };
  return returned_subsets.concat(made_subsets);
}

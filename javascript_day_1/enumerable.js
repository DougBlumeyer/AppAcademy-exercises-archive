function myEach(ary, someFunction) {
  for (var i = 0; i < ary.length; i++ ) {
    someFunction(ary[i]);
  };
}

function logNumber(num) {
  console.log(num);
}

function myMap(ary, someFunction) {
  var results = [];
  var mapFunction = function(el) {
    results.push(someFunction(el));
  };
  myEach(ary, mapFunction);
  return results;
}

function myInject(ary, someFunction) {
  var results = null;
  var injectFunction = function(el) {
    results = someFunction(results, el);
    console.log(results);
  };
  myEach(ary, injectFunction);
  return results;
}

function multiplyByThree(num){
  return num * 3;
}

function addNum(sum, num){
  return sum + num;
}


// x.each do |y|
//   results << y.call(fucntion)
// end

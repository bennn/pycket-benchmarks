
if (typeof(print) === 'undefined') {
    print = console.log
}

function e(x) { return x; }
// convert to and from a string
//function e(x) { return ("" + x) - 0 }

var f = 0;
f = e;

function make_g1(pre, post) { return function(x) {
                                return post(f(pre(x)));
                               }; }
var g1 = make_g1(function(x) { return x;},
                 function(x) { return x;});

print("wrapped+check");
function benchmark(fun) {
  var milliseconds1 = Date.now();
  var result = fun();
  var milliseconds2 = Date.now();
  var timing = (milliseconds2 - milliseconds1).toString();
  if (timing.indexOf(".") === -1) {
    timing = timing + ".0";
  }
  print("RESULT-cpu: " + timing);
  print("RESULT-total: " + timing);
}


benchmark(function() {
  for (i = 0; i < 10000000; i++) {
    g1(i);
  }
})

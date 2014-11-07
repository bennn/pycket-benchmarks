
if (typeof(print) === 'undefined') {
    print = console.log
}

function loop(f) {
    for (i = 0; i < 100000000; i++) {
        f.weight;
    }
}

var fish = { weight : 1, color : "blue" };

print("direct");
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
  loop(fish);
})
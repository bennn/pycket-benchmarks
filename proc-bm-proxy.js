
if (typeof(print) === 'undefined') {
    print = console.log
}

function e(x) { return x; }
// convert to and from a string
//function e(x) { return ("" + x) - 0 }

var f = 0;
f = e;

var h0 = Proxy.createFunction({ },
                              function(x) { return f(x); },
                              function() { return 0; });

print("proxy");
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
    h0(i);
  }
})
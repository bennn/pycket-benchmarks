
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
milliseconds1 = Date.now();
loop(fish);
milliseconds2 = Date.now();
print(milliseconds2 - milliseconds1);

var proxy = Proxy.create({
    get: function(rcvr,name) { return fish[name];},
    set: function(rcvr,name,val) { fish[name] = val; return true; },
    has: function(name) { return name in fish; },
    delete : function(name) { return delete fish[name]; } },
                         Object.getPrototypeOf(fish));


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
  loop(proxy);
})

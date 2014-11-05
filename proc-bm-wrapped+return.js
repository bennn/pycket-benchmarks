
if (typeof(print) === 'undefined') {
    print = console.log
}

function e(x) { return x; }
// convert to and from a string
//function e(x) { return ("" + x) - 0 }

var f = 0;
f = e;

function g2(x) {
  return [f(x), function(y) { return y; } ];
}

print("wrapped+return");
milliseconds1 = Date.now();
for (i = 0; i < 10000000; i++) {
    var l = g2(i);
    l[1](l[0]);
}
milliseconds2 = Date.now();
print(milliseconds2 - milliseconds1);


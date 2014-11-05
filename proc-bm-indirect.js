
if (typeof(print) === 'undefined') {
    print = console.log
}

function e(x) { return x; }
// convert to and from a string
//function e(x) { return ("" + x) - 0 }
var f = 0;
f = e;

print("indirect");
milliseconds1 = Date.now();
for (i = 0; i < 10000000; i++) {
  f(i);
}
milliseconds2 = Date.now();
print(milliseconds2 - milliseconds1);


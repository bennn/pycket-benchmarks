
if (typeof(print) === 'undefined') {
    print = console.log
}

function e(x) { return x; }
// convert to and from a string
//function e(x) { return ("" + x) - 0 }

var f = 0;
f = e;

function g(x) { return f(x); }

print("wrapped");
milliseconds1 = Date.now();
for (i = 0; i < 10000000; i++) {
  g(i);
}
milliseconds2 = Date.now();
print(milliseconds2 - milliseconds1);


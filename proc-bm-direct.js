if (typeof(print) === 'undefined') {
    print = console.log
}

function e(x) { return x; }
// convert to and from a string
//function e(x) { return ("" + x) - 0 }

print("direct");
milliseconds1 = Date.now();
for (i = 0; i < 10000000; i++) {
  e(i);
}
milliseconds2 = Date.now();
print(milliseconds2 - milliseconds1);

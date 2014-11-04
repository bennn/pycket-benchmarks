
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

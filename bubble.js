var SIZE = 10000;

if (typeof(print) === 'undefined') {
    print = console.log
}

function make_vec(SIZE) {
    var vec = new Array(SIZE);
    for (i = 0; i < SIZE; i++)
        vec[i] = SIZE - i;
    return vec;
}

function bubble_sort(vec)
{
    var changed = true;
    var i, a, b;

    while (changed) {
        changed = false;

        for (i = 0; i < SIZE - 1; i++) {
            a = vec[i];
            b = vec[i+1];
            if (a > b) {
                vec[i] = b;
                vec[i+1] = a;
                changed = true;
            }
        }
    }
}

var vec = make_vec(SIZE);

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
  bubble_sort(vec);
})
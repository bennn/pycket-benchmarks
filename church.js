
if (typeof(print) === 'undefined') {
    print = console.log
}

var n_to_f = function(n) {
    if (n == 0)
        return function(f) { return function(x) { return x; }}
    else {
        var next = n_to_f(n-1);
        return function(f) { return function(x) { return f(next(f)(x)); }}
    }
}

var f_to_n = function(c) {
    return c(function(x) { return x + 1; })(0);
}

var c_star = function(n1){
    return function (n2) {
        return function(f) {
            return n1(n2(f));
        };
    };
}

var c_is_zero = function(c) {
    return c(function (x){ return false; })(true);
}

// taken from Wikipedia (but lifted out
// the definition of 'X')
var c_sub1 = function(n) {
    return function(f) {
        var X = function(g) { return function(h){ return h(g(f)); }; };
        return function(x) {
            return n(X)(function(u) { return x; })(function(u){ return u; });
        };
    };
}

var fact = function(n){
    if (c_is_zero(n))
        return function(f){ return  f; }
    else
        return c_star(n)(fact(c_sub1(n)));
}

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
  print(f_to_n(fact(n_to_f(9))));
})
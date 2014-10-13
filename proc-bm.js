
function e(x) { return x; }
// convert to and from a string
//function e(x) { return ("" + x) - 0 }

console.log("direct");
milliseconds1 = Date.now(); 
for (i = 0; i < 10000000; i++) {
  e(i);
}
milliseconds2 = Date.now(); 
console.log(milliseconds2 - milliseconds1);

var f = 0;
f = e;

console.log("indirect");
milliseconds1 = Date.now(); 
for (i = 0; i < 10000000; i++) {
  f(i);
}
milliseconds2 = Date.now(); 
console.log(milliseconds2 - milliseconds1);


function g(x) { return f(x); }

console.log("wrapped");
milliseconds1 = Date.now(); 
for (i = 0; i < 10000000; i++) {
  g(i);
}
milliseconds2 = Date.now(); 
console.log(milliseconds2 - milliseconds1);


function make_g1(pre, post) { return function(x) {
                                return post(f(pre(x)));
                               }; }
var g1 = make_g1(function(x) { return x;},
                 function(x) { return x;});

console.log("wrapped+check");
milliseconds1 = new Date().getTime(); 
for (i = 0; i < 10000000; i++) {
  g1(i);
}
milliseconds2 = new Date().getTime(); 
console.log(milliseconds2 - milliseconds1);


function g2(x) { 
  return [f(x), function(y) { return y; } ]; 
}

console.log("wrapped+return");
milliseconds1 = Date.now(); 
for (i = 0; i < 10000000; i++) {
    var l = g2(i);
    l[1](l[0]);
}
milliseconds2 = Date.now(); 
console.log(milliseconds2 - milliseconds1);


var h0 = Proxy.createFunction({ }, 
                              function(x) { return f(x); },
                              function() { return 0; }); 

console.log("proxy");
milliseconds1 = Date.now(); 
for (i = 0; i < 10000000; i++) {
    h0(i);
}
milliseconds2 = Date.now(); 
console.log(milliseconds2 - milliseconds1);

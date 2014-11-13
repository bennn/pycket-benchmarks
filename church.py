
import time

def number_to_function(n):
    if n == 0:
        return lambda f: lambda x: x
    pred = number_to_function(n - 1)
    def anon(f):
        fn = pred(f)
        return lambda x : f(fn(x))
    return anon

def function_to_number(c):
    return c(lambda x: x + 1)(0)

def times(n1):
    return lambda n2: lambda f: n1(n2(f))

def zero(c):
    return c(lambda x: False)(True)

def sub1(n):
    def anon1(f):
        X = lambda g: lambda h: h(g(f))
        return lambda x: n(X)(lambda u: x)(lambda u: u)
    return anon1

def fact(n):
    if zero(n):
        return lambda f: f
    return times(n)(fact(sub1(n)))


start = time.clock() * 1000
function_to_number(fact(number_to_function(9)))
delta = time.clock() * 1000 - start

print "RESULT-cpu: %s\nRESULT-total: %s" % (delta, delta)

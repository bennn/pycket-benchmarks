
import time
import types

class Proxy(object):
    def __init__(self, inner, refs={}, sets={}, call=None):
        object.__setattr__(self, "inner", inner)
        object.__setattr__(self, "refs", refs)
        object.__setattr__(self, "sets", sets)
        object.__setattr__(self, "call", call)

    def __getattribute__(self, name):
        check = object.__getattribute__(self, "refs").get(name, None)
        inner = object.__getattribute__(self, "inner")
        val   = getattr(inner, name)
        if check is None:
            return val
        return check(inner, val)

    def __call__(self, *args):
        inner = object.__getattribute__(self, "inner")
        check = object.__getattribute__(self, "call")
        if check is None:
            return inner(*args)
        new_args = check(*args)
        if len(new_args) == len(args):
            return inner(new_args)
        if len(new_args) == len(args) + 1:
            new_args, post = new_args[:-1], new_args[-1]
            return post(inner(*new_args))
        raise Exception("Bad handler")

    def __setattr__(self, name, val):
        inner = object.__getattribute__(self, "inner")
        check = object.__getattribute__(self, "sets").get(name, None)
        if check is None:
            return setattr(inner, name, val)
        new_val = check(inner, val)
        return setattr(inner, name, new_val)

def arrow(*args):
    from itertools import izip
    dom, cod = args[:-1], args[-1]
    def handler(*args):
        return [d(v) for d, v in izip(dom, args)] + [cod]
    return lambda f: Proxy(f, call=handler)

# Our contract primitives are functions which assert certain properties and
# otherwise act as the identity function.

# Lift a predicate to a contract. Uses the doc string for an error message
def lift(pred):
    def f(x):
        assert pred(x), pred.__doc__
        return x
    return f

@lift
def non_negative_int(x):
    """ Not a non-negative int """
    return isinstance(x, int) and x >= 0

@lift
def any_c(x):
    """ Not an object """
    return isinstance(x, object)

@lift
def bool_c(x):
    """ Not a boolean """
    return isinstance(x, bool)

church = arrow(arrow(any_c, any_c), arrow(any_c, any_c))

@arrow(non_negative_int, church)
def number_to_function(n):
    if n == 0:
        return lambda f: lambda x: x
    pred = number_to_function(n - 1)
    def anon(f):
        fn = pred(f)
        return lambda x : f(fn(x))
    return anon

@arrow(church, non_negative_int)
def function_to_number(c):
    return c(lambda x: x + 1)(0)

@arrow(church, arrow(church, church))
def times(n1):
    return lambda n2: lambda f: n1(n2(f))

@arrow(church, bool_c)
def zero(c):
    return c(lambda x: False)(True)

@arrow(church, church)
def sub1(n):
    def anon1(f):
        X = lambda g: lambda h: h(g(f))
        return lambda x: n(X)(lambda u: x)(lambda u: u)
    return anon1

@arrow(church, church)
def fact(n):
    if zero(n):
        return lambda f: f
    return times(n)(fact(sub1(n)))

start = time.clock() * 1000
function_to_number(fact(number_to_function(9)))
delta = time.clock() * 1000 - start

print "RESULT-cpu: %s\nRESULT-total: %s" % (delta, delta)

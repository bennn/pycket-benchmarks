
import time

def e(x):
    return x

f = 0
f = e

print "wrapped+check"

def make_g1(pre, post):
    return lambda x: post(f(pre(x)))

g1 = make_g1(lambda x: x, lambda x: x)

start = time.clock() * 1000
for i in xrange(10000000):
    g1(i)
delta = time.clock() * 1000 - start

print "RESULT-cpu: %s\nRESULT-total: %s" % (delta, delta)

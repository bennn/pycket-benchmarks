
import time

def e(x):
    return x

f = 0
f = e

def g2(x):
    return f(x), lambda y: y

print "wrapped+return"

start = time.clock() * 1000
for i in xrange(10000000):
    l, r = g2(i)
    r(l)
delta = start - time.clock() * 1000

print "RESULT-cpu: %s\nRESULT-total: %s" % (delta, delta)

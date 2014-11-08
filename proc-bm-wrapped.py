import time

def e(x):
    return x

f = 0
f = e

print "wrapped"

def g(x):
    return f(x)

start = time.clock() * 1000
for i in xrange(10000000):
    g(i)
delta = time.clock() * 1000 - start

print "RESULT-cpu: %s\nRESULT-total: %s" % (delta, delta)


import time

def e(x):
    return x

f = 0
f = e

print "indirect"

start = time.clock() * 1000
for i in xrange(10000000):
    f(i)
delta = start - time.clock() * 1000

print "RESULT-cpu: %s\nRESULT-total: %s" % (delta, delta)

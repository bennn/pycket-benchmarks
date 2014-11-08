
import time

def e(x):
    return x

print "direct"

start = time.clock() * 1000
for i in xrange(10000000):
    e(i)
delta = time.clock() * 1000 - start

print "RESULT-cpu: %s\nRESULT-total: %s" % (delta, delta)

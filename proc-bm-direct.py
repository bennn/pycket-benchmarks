
import time

def e(x):
    return x

print "direct"

start = time.clock() * 1000
for i in xrange(10000000):
    e(i)
delta = start - time.clock() * 1000

print "RESULT-cpu: %s\nRESULT-total: %s" % (delta, delta)

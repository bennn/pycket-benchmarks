
import time

def e(x):
    return x

f = 0
f = e

def g2(x):
    return f(x), lambda y: y

print "wrapped+return"

milliseconds1 = int(round(time.time() * 1000))
for i in xrange(10000000):
    l, r = g2(i)
    r(l)
milliseconds2 = int(round(time.time() * 1000))

print milliseconds2 - milliseconds1


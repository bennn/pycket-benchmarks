import time

def e(x):
    return x

f = 0
f = e

print "indirect"

milliseconds1 = int(round(time.time() * 1000))
for i in xrange(10000000):
    f(i)
milliseconds2 = int(round(time.time() * 1000))

print milliseconds2 - milliseconds1


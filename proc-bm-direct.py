
import time

def e(x):
    return x

print "direct"

milliseconds1 = int(round(time.time() * 1000))
for i in xrange(10000000):
    e(i)
milliseconds2 = int(round(time.time() * 1000))

print milliseconds2 - milliseconds1


import time

def e(x):
    return x

f = 0
f = e

print "wrapped"

def g(x):
    return f(x)

milliseconds1 = int(round(time.time() * 1000))
for i in xrange(10000000):
    g(i)
milliseconds2 = int(round(time.time() * 1000))

print milliseconds2 - milliseconds1


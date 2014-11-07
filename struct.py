
import time

N = 100000000

class Fish(object):
    def __init__(self, weight, color):
        self.weight = weight
        self.color  = color

def loop(f):
    start = time.clock() * 1000
    for i in xrange(N):
        f.weight
    delta = start - time.clock() * 1000

    print "RESULT-cpu: %s\nRESULT-total: %s" % (delta, delta)

fish = Fish(1, "blue")
print "direct"
loop(fish)


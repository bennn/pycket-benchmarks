
import time

N = 100000000

class Fish(object):
    def __init__(self, weight, color):
        self.weight = weight
        self.color  = color

def loop(f):
    milliseconds1 = int(round(time.time() * 1000))
    for i in xrange(N):
        f.weight
    milliseconds2 = int(round(time.time() * 1000))
    print milliseconds2 - milliseconds1

fish = Fish(1, "blue")
print "direct"
loop(fish)


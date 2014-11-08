
import time

SIZE = 10000

def make_vec(size):
    return [size - i for i in xrange(size)]

def bubble_sort(vec):
    changed = True
    size    = len(vec)

    while changed:
        changed = False
        for i in xrange(size - 1):
            a, b = vec[i], vec[i+1]
            if a > b:
                vec[i], vec[i+1] = b, a
                changed = True

vec = make_vec(SIZE)

start = time.clock() * 1000
bubble_sort(vec)
delta = time.clock() * 1000 - start

print "RESULT-cpu: %s\nRESULT-total: %s" % (delta, delta)

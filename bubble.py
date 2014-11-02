
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

milliseconds1 = int(round(time.time() * 1000))
bubble_sort(vec)
milliseconds2 = int(round(time.time() * 1000))

print milliseconds2 - milliseconds1

import time

SIZE = 10000

class ListProxy(object):

    def __init__(self, values):
        self.values = values

    def __getitem__(self, idx):
        return self.values[idx]

    def __setitem__(self, idx, value):
        self.values[idx] = value

    def __len__(self):
        return len(self.values)

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

vec = ListProxy(make_vec(SIZE))

milliseconds1 = int(round(time.time() * 1000))
bubble_sort(vec)
milliseconds2 = int(round(time.time() * 1000))

print milliseconds2 - milliseconds1

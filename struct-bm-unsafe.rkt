#lang racket/base
(require (only-in racket/unsafe/ops
                  unsafe-struct-ref
                  unsafe-struct*-ref))

(struct fish (weight color) #:mutable)

(define N 100000000)

'unsafe
(define (unsafe-loop f)
  (time
   (for ([i (in-range N)])
     (unsafe-struct-ref f 0))))

(unsafe-loop (fish 1 "blue"))


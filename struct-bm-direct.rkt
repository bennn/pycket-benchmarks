#lang racket/base

(struct fish (weight color) #:mutable)

(define N 100000000)

(define (loop f)
  (time
   (for ([i (in-range N)])
     (fish-weight f))))

'direct
(loop (fish 1 "blue"))


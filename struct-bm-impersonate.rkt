#lang racket/base

(struct fish (weight color) #:mutable)

(define N 100000000)

(define (loop f)
  (time
   (for ([i (in-range N)])
     (fish-weight f))))

'impersonate
(loop (impersonate-struct (fish 1 "blue")
                          fish-weight (lambda (f v) v)
                          set-fish-weight! (lambda (f v) v)))


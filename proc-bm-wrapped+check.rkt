#lang racket/base

(define-syntax-rule (check e) e)
#;
(define-syntax-rule (check e)
  (let ([v e])
    (unless (integer? v) (error "bad"))
    v))


(define e (lambda (x) x))
#;
(define e (lambda (x) (string->number (number->string x))))


(define N 10000000)

(define f #f)
(set! f e)
(define make-g1 #f)
(set! make-g1 (lambda (pre post)
                (lambda (x) (post (f (pre x))))))
(define g1 (make-g1 (lambda (x) x) (lambda (x) x)))

'wrapped+check
(time
 (for ([i (in-range N)])
   (g1 i)))


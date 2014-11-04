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

(define k (chaperone-procedure f
                               (lambda (x)
                                 (values (lambda (y) (check y)) (check x)))
                               impersonator-prop:application-mark
                               '(1 . 2)))

'chaperone+mark
(time
 (for ([i (in-range N)])
   (k i)))

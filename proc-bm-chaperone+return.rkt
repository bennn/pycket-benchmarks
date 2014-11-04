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

(define j (chaperone-procedure f
                               (lambda (x)
                                 (values (lambda (y) (check y)) (check x)))))

'chaperone+return
(time
 (for ([i (in-range N)])
   (j i)))
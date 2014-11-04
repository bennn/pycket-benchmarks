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

(define g2 #f)
(set! g2 (lambda (x) (cons (f (check x)) (lambda (y) (check y)))))

'wrapped+return
(time
 (for ([i (in-range N)])
   (let ([p (g2 i)])
     ((cdr p) (car p)))))


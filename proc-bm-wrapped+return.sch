(import (rnrs) (larceny benchmarking))

(define-syntax check
  (syntax-rules ()
    [(check e) e]))

(define-syntax for
  (syntax-rules ()
    [(for ([i (in-range N)]) e)
     (let loop ([i N])
       (if (zero? i)
           'done
           (begin
             e
             (loop (- i 1)))))]))

(define e (lambda (x) x))

(define (show n) (display n) (newline))

(define N 10000000)

(define f #f)
(set! f e)

(define g2 #f)
(set! g2 (lambda (x) (cons (f (check x)) (lambda (y) (check y)))))

(show 'wrapped+return)
(time
 (for ([i (in-range N)])
   (let ([p (g2 i)])
     ((cdr p) (car p)))))

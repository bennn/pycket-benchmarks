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

(define g #f)
(set! g (lambda (x) (check (f (check x)))))

(define make-g1 #f)
(set! make-g1 (lambda (pre post)
                (lambda (x) (post (f (pre x))))))
(define g1 (make-g1 (lambda (x) x) (lambda (x) x)))

(show 'wrapped+check)
(time
 (for ([i (in-range N)])
   (g1 i)))


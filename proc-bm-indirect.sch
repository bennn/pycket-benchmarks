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

(show 'indirect)
(time
 (for ([i (in-range N)])
   (f i)))




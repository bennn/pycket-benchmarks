#lang racket/base
(require "binomial-heap-contract.rkt")
(require "binomial-heap.rkt")
         
(define (run-ops pff-data insert find-min-obj remove-min)
  (define total-count (length pff-data))
  (define priority-offset
    (expt
     10
     (inexact->exact (ceiling (/ (log total-count) (log 10))))))
  (let loop ([ops pff-data]
             [count (length pff-data)]
             [heap empty-heap])
    (cond
      [(null? ops) (void)]
      [else
       (let ([op (car ops)])
         (case (car op)
           [(insert)
            (let* ([raw-priority (caddr op)]
                   [value (cadr op)]
                   [priority (+ (* raw-priority priority-offset) (- total-count count))])
              (loop (cdr ops)
                    (- count 1)
                    (begin #;(printf "insert ~s ~s~n" priority value)
                           (insert priority value heap))))]
           [(remove-min)
            (let* ([pff-min (cadr op)]
                   [my-min (find-min-obj heap)])
              (loop (cdr ops)
                    (- count 1)
                    (begin #;(printf "remove-min ~s~n" my-min)
                           (remove-min heap))))]))])))

(define (random-ops N)
  (define count 0)
  (for/list ([i (in-range N)])
    (if (or (= count 0) (> (random) .5))
        (begin (set! count (add1 count)) `(insert ,(random) ,(random)))
        (begin (set! count (sub1 count)) `(remove-min #f)))))

(define N 10000)

;; with contracts
(time (run-ops (random-ops N) t:insert t:find-min-obj t:remove-min))
;; without contracts
(time (run-ops (random-ops N) insert find-min-obj remove-min))

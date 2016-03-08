#lang racket/base
(require "binomial-heap.rkt"
         "binomial-heap-contract.rkt"
         racket/contract
         racket/port
         racket/cmdline
         ;;racket/runtime-path
         racket/list
         racket/match
         profile)

(define results "results")
;;(unless (directory-exists? results) (make-directory results))

(define (apply-contract c v) (contract c v 'pos 'neg))

(define profile? #f)
(define log-memory? #f)
(define chap-stats? #f)
(define stdout? #f)
(define stderr? #f)

(define-values (tracefile benchmark counter)
  (command-line
   #:once-each
   [("--profile") "enable profiling" (set! profile? #t)]
   [("--mem") "collect memory stats (not time)" (set! log-memory? #t)]
   [("--chap") "collect chaperone stats" (set! chap-stats? #t)]
   [("--stdout") "collect chaperone stats" (set! stdout? #t)]
   [("--stderr") "collect chaperone stats" (begin (set! stdout? #t) (set! stderr? #t))]
   #:args (tracefile benchmark counter)
   (values tracefile
           benchmark
           (cond
             [(string->number counter) => values]
             [(equal? counter "memory") 'memory]
             [else
              (error 'pff.rkt" expected counter to be a number or memory, got ~a" counter)]))))

(define shutdown-logger-chan (and log-memory? (make-channel)))

(define (parse-file filename)
  (call-with-input-file filename
    (λ (port)
       (let loop ([lines '()])
         (let ([l (read-line port)])
           (cond
             [(eof-object? l) (reverse lines)]
             [(regexp-match #rx"Insert: ([0-9]*) at priority ([0-9]*)$" l)
              =>
              (λ (m)
                 (loop
                   (cons `(insert ,(string->number/err (cadr m))
                                  ,(string->number/err (caddr m)))
                         lines)))]
             [(regexp-match #rx"RemoveMin: ([0-9]*)$" l)
              =>
              (λ (m)
                 (loop
                   (cons `(remove-min ,(string->number (cadr m)))
                         lines)))]))))))

(define (string->number/err str)
  (let ([n (string->number str)])
    (if n
        n
        (error 'string->number/err "could not convert ~s" str))))

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
              (unless (= pff-min my-min)
                (error 'run-ops "line ~a removed min of ~a, expected ~a"
                       count
                       pff-min
                       my-min))
              (loop (cdr ops)
                    (- count 1)
                    (begin #;(printf "remove-min ~s~n" my-min)
                           (remove-min heap))))]))])))

(define (do-benchmark what insert find-min-obj remove-min)
  (when (equal? benchmark what)
    (define pff-data (parse-file tracefile))
    (define (thunk) (run-ops pff-data insert find-min-obj remove-min))
    (when profile? (set! thunk (let ([t thunk]) (λ () (profile (t))))))
    ;;(define data-file-prefix (regexp-replace #rx".trace(?:.gz)?$" tracefile ""))
    (define data-file-prefix tracefile)
       (define small-part-fn (format "~a.time.~a" data-file-prefix counter))
       (define fn (build-path results small-part-fn))
       (printf "running ~a ~a\n" small-part-fn what)
       ;;(define chap-pre-stats (and chap-stats? (get-chap-stats)))
       (define-values (res time real-time gc-time) (time-apply thunk '()))
       ;;(when chap-stats?
       ;;  (printf "~s\n" (map - (get-chap-stats) chap-pre-stats)))
       (if stdout?
           (if stderr?
               (let ((t (exact->inexact time)))
                 (fprintf (current-error-port) "\n\nRESULT-cpu: ~a\nRESULT-total: ~a\n" t t))
               (printf "~s\n" time))
           (rewrite-log-file fn what time))))

(define (rewrite-log-file fn new-key new-val)
  (define old-entries '());;(if (file-exists? fn) (call-with-input-file fn read) '()))
  (define new-entry (list new-key new-val))
  (define new-entries (sort
                       (cons
                        new-entry
                        (filter-not (λ (x) (equal? (car x) new-key))
                                    old-entries))
                       string<=?
                       #:key car))
  (if profile?
      (printf "profiling, so not saving results\n")
      (call-with-output-file fn
        (λ (port)
          (write new-entries port)
          (newline port))
        #:exists 'truncate)))

(define (run-all-ops)
  (do-benchmark "none"        insert   find-min-obj   remove-min)
  (do-benchmark "normal"    c:insert c:find-min-obj c:remove-min)
  (do-benchmark "opt"       o:insert o:find-min-obj o:remove-min)
  (do-benchmark "hand chap" h:insert h:find-min-obj h:remove-min)
  (do-benchmark "chap"      s:insert s:find-min-obj s:remove-min)
  (do-benchmark "opt chap"  t:insert t:find-min-obj t:remove-min)
  (do-benchmark "flat"      ?:insert ?:find-min-obj ?:remove-min)
  )

(run-all-ops)


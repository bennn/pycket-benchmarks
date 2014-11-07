#lang racket/base
(require racket/contract)


(define empty-heap #f)

(define (make-binomial-heap-ops kons hd tl rev
                                make-node node-rank node-val node-obj node-children)
  (define (link t1 t2)
    (define r (node-rank t1))
    (define x1 (node-val t1))
    (define x2 (node-val t2))
    (cond
      [(<= x1 x2)
       (define c1 (node-children t1))
       (define o1 (node-obj t1))
       (make-node (+ r 1) x1 o1 (kons t2 c1))]
      [else
       (define c2 (node-children t2))
       (define o2 (node-obj t2))
       (make-node (+ r 1) x2 o2 (kons t1 c2))]))
  (define (ins-tree t ts)
    (cond
      [(not ts) (kons t #f)]
      [else
       (define tt (hd ts))
       (if (< (node-rank t) (node-rank tt))
           (kons t ts)
           (ins-tree (link t tt) (tl ts)))]))
  
  (define (insert x obj ts)
    (ins-tree (make-node 0 x obj #f) ts))

  (define (merge ts1 ts2)
    (cond
      [(not ts2) ts1]
      [(not ts1) ts2]
      [else 
       (define t1 (hd ts1))
       (define t2 (hd ts2))
       (cond
         [(< (node-rank t1) (node-rank t2))
          (define tts1 (tl ts1))
          (kons t1 (merge tts1 ts2))]
         [(< (node-rank t2) (node-rank t1))
          (define tts2 (tl ts2))
          (kons t2 (merge ts1 tts2))]
         [else
          (define tts1 (tl ts1))
          (define tts2 (tl ts2))
          (ins-tree (link t1 t2) (merge tts1 tts2))])]))
  
  (define (remove-min-tree l)
    (cond
      [(not l) (error 'empty)]
      [(not (tl l)) (values (hd l) #f)]
      [else 
       (define t (hd l))
       (define ts (tl l))
       (define-values (tt tts) (remove-min-tree ts))
       (if (<= (node-val t) (node-val tt))
           (values t ts)
           (values tt (kons t tts)))]))
  
  (define (find-min ts)
    (define-values (t tts) (remove-min-tree ts))
    t)
  (define (find-min-priority ts)
    (node-val (find-min ts)))
  (define (find-min-obj ts) (node-obj (find-min ts)))
  (define (delete-min ts)
    (define-values (t tts) (remove-min-tree ts))
    (merge (rev (node-children t)) tts))
  
  (values insert delete-min find-min-priority find-min-obj))

(define (apply-contract c v) (contract c v 'pos 'neg))

(define-contract-struct kons (hd tl) (make-inspector))
(define-contract-struct node (rank val obj children) (make-inspector))

(define (kfoldl f init kl res)
  (cond
    [(not kl) res]
    [(not res) (kfoldl f init (kons-tl kl) (f (kons-hd kl) init))]
    [else (kfoldl f init (kons-tl kl) (f (kons-hd kl) res))]))
(define (rev kl)
  (kfoldl make-kons #f kl #f))


(define-values (insert remove-min find-min-priority find-min-obj)
  (make-binomial-heap-ops make-kons kons-hd kons-tl rev
                          make-node node-rank node-val node-obj node-children))

(define-struct h:kons (hd tl) #:transparent)
(define-struct h:node (rank val obj children) #:transparent)

(define (h:kfoldl f init kl res)
  (cond
    [(not kl) res]
    [(not res) (h:kfoldl f init (h:kons-tl kl) (f (h:kons-hd kl) init))]
    [else (h:kfoldl f init (h:kons-tl kl) (f (h:kons-hd kl) res))]))
(define (h:rev kl)
  (h:kfoldl make-h:kons #f kl #f))

(define-values (h:insert/r h:remove-min/r h:find-min-priority/r h:find-min-obj/r)
  (make-binomial-heap-ops make-h:kons h:kons-hd h:kons-tl h:rev
                          make-h:node h:node-rank h:node-val h:node-obj h:node-children))

(define-opt/c (binomial-tree-rank=/sco r v)
  (or/c #f
        (struct/dc h:node
                   [rank (=/c r)]
                   [val (>=/c v)]
                   [children (rank val) #:lazy (heap-ordered/desc/sco (- rank 1) val)])))
(define-opt/c (binomial-tree-rank>/sco r)
  (or/c #f
        (struct/dc h:node
                   [rank (>=/c r)]
                   [val any/c]
                   [children (rank val) #:lazy (heap-ordered/desc/sco (- rank 1) val)])))
(define-opt/c (heap-ordered/desc/sco rank val)
  (or/c #f
        (struct/dc h:kons
                   [hd #:lazy (binomial-tree-rank=/sco rank val)]
                   [tl () #:lazy (heap-ordered/desc/sco (- rank 1) val)])))
(define-opt/c (binomial-trees/asc/sco rank)
  (or/c #f
        (struct/dc h:kons
                   [hd #:lazy (binomial-tree-rank>/sco rank)]
                   [tl (hd) #:lazy (binomial-trees/asc/sco (h:node-rank hd))])))

(define binomial-heap/sco (binomial-trees/asc/sco -inf.0))



(define t:insert (apply-contract (-> number? any/c binomial-heap/sco binomial-heap/sco) h:insert/r))
(define t:find-min-obj (apply-contract (-> binomial-heap/sco number?) h:find-min-obj/r))
(define t:find-min-priority (apply-contract (-> binomial-heap/sco number?) h:find-min-priority/r))
(define t:remove-min (apply-contract (-> binomial-heap/sco binomial-heap/sco) h:remove-min/r))

         
(define (run-ops pff-data insert find-min-obj remove-min)
  (let loop ([ops pff-data]
             [heap empty-heap])
    (cond
      [(null? ops) (void)]
      [else
       (let ([op (car ops)])
         (case (car op)
           [(insert)
            (let* ([raw-priority (caddr op)]
                   [value (cadr op)])
              (loop (cdr ops)
                    (insert raw-priority value heap)))]
           [(remove-min)
            (let* ([pff-min (cadr op)]
                   [my-min (find-min-obj heap)])
              (loop (cdr ops)
                    (remove-min heap)))]))])))

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

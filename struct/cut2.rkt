#lang pycket
(require racket/contract)


(define empty-heap #f)

(define (make-binomial-heap-ops kons hd tl
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

  (values insert))

(define (apply-contract c v) (contract c v 'pos 'neg))

(define-struct kons (hd tl) #:transparent)
(define-struct node (rank val obj children) #:transparent)


(define-values (insert)
  (make-binomial-heap-ops make-kons kons-hd kons-tl
                          make-node node-rank node-val node-obj node-children))

(define-struct h:kons (hd tl) #:transparent)
(define-struct h:node (rank val obj children) #:transparent)

(define-values (h:insert/r)
  (make-binomial-heap-ops make-h:kons h:kons-hd h:kons-tl
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

         

(define N 10000)

(define h1 (time (for/fold ([n empty-heap]) ([_ (in-range N)])
                    (insert (random) (random) n))))

(define h2 (time (for/fold ([n empty-heap]) ([_ (in-range N)])
                   (t:insert (random) (random) n))))


#lang racket
(require pict/tree-layout)

;DEFINICJA DRZEWA
(define-struct leaf () #:transparent)
(define-struct node (l elem r) #:transparent)

(define (tree? t)
  (cond [(leaf? t) #t]
        [(node? t) (and (tree? (node-l t)) (tree? (node-r t)))]
        [else #f]))

;ZADANIE 2
"zadanie 2"
(define (fold-tree f t null-val)
  (if (leaf? t)
      null-val
      (f (fold-tree f (node-l t) null-val) (node-elem t) (fold-tree f (node-r t) null-val))))

(define (tree-sum t)
  (fold-tree + t 0))

(define (tree-flip t)
  (fold-tree (λ (x y z)(node z y x)) t (leaf)))

(define (tree-height t)
  (fold-tree (λ (x y z) (+ (max z x) 1)) t 0))

(define (tree-span t)
  (fold-tree (λ (x y z)(cons (if x (car x) y) (if z (cdr z) y))) t #f))
  
(define (flatten2 t)
  (fold-tree (λ (x y z) (append x (cons y z) )) t (list)))

(define tree1
  ( node ( node ( leaf ) 2 ( leaf ) )
       5
       ( node ( node ( leaf ) 6 ( leaf ) )
              8
              ( node ( leaf ) 9 ( leaf ) ) ) ) )

(tree-sum tree1);działa
;(tree-flip tree1);działa
(tree-height tree1);działa
(tree-span tree1);działa
(flatten2 tree1);działa

;ZADANIE 3
"zadanie 3"

(define (bst? t)
  (cond [(leaf? t) #t]
        [else (and (bst? (node-l t))
                   (and (bst? (node-r t))
                        (and (cond [(leaf? (node-l t)) #t] 
                                   [(> (node-elem t)
                                       (node-elem (node-l t))) #t]
                                   [else #f])
                             (cond [(leaf? (node-r t)) #t]
                                   [(< (node-elem t)
                                      (node-elem (node-r t))) #t]
                                   [else #f]))))]))

;(bst? tree1);działa
(define tree2 (node (node (leaf) 3 (leaf)) 2 (node (leaf) 3 (leaf))))
;(bst? tree2);działa

(define treeBST tree1 )

;(bst? treeBST);działa

(define (add-path t x)
  (cond [(leaf? t) (leaf)]
        [else (node (add-path (node-l t) (+ x (node-elem t)))
                    (+ x (node-elem t))
                    (add-path (node-r t) (+ x (node-elem t))))]))

(define (sum-paths t)
  (add-path t 0))

;"drzewo 1"
;tree1
;(flatten tree1)

;(sum-paths treeBST)

;ZADANIE 4
"zadanie 4"

(define (flat-append t l)
  (cond [(leaf? t) l];jesli t puste
        [else (flat-append (node-l t)
                           (cons (node-elem t)
                                 (flat-append (node-r t) l)))]))

(define (flatten t)
  (flat-append t (list)))
;(flat-append tree1 (list))
;(flat-append tree1 (list 1 2 3 4 5 6 7))
;(flatten tree1)

;ZADANIE 5
"zadanie 5"

(define (insert t x)
  (cond [(leaf? t) (node (leaf) x (leaf))]
        [(node? t)
         (cond [(< x (node-elem t))
                 (node (insert (node-l t) x)
                       (node-elem t)
                       (node-r t))]
                [else
                 (node (node-l t)
                       (node-elem t)
                       (insert (node-r t) x))])]))

;"po wpisaniu 1:"
(define newtree (leaf))
;(insert newtree 1)
;(insert (insert (insert newtree 2) 3) 1)

(define (treesort xs)
  (define (iter xs t)
    (if (null? xs) t
        (iter (cdr xs) (insert t (car xs)))))
  (flatten (iter xs (leaf))))

;"sortowanie:"
;(treesort (list 4 2 6 8 5 3 5 3 68 4 2 6 3))

;ZADANIE 6
"zadanie 6"

(define (insert-tree t x);dziala
  (cond [(leaf? t) x]
        [(leaf? x) t]
        [else
         (cond [(< (node-elem x) (node-elem t))
                 (node (insert-tree (node-l t) x)
                       (node-elem t)
                       (node-r t))]
                [else
                 (node (node-l t)
                       (node-elem t)
                       (insert-tree (node-r t) x))])]))
(define treeuno (insert (leaf) 1))
;treeuno
;(flatten treeuno)
(define treedos (insert (leaf) 2))
;treedos
;(flatten treedos)
(define treenuevo (insert-tree treeuno treedos))
;treenuevo
;(flatten treenuevo)
(define (delete x t)
  (cond [(leaf? t) t];jesli nie bylo w drzewie to zwracamy cale
        [(equal? (node-elem t) x);jesli to ten wierzcholek
            (cond [(leaf? (node-l t)) (node-r t)];jesli nic po lewej
                  [(leaf? (node-r t)) (node-l t)];jesli nic po prawej
                  [else (insert-tree (node-l t) (node-r t))];jesli po obu stronach cos jest
                  )]
        [(< (node-elem t) x) (node (node-l t)(node-elem t)(delete x (node-r t)))];jesli po prawej;
        [else (node (delete x (node-l t))(node-elem t)(node-r t))];jesli po lewej
        ))
(define bigtree (insert (insert (insert (leaf) 5) 6) 7))
;"bez 5:"
;(delete 5 bigtree)
;(flatten (delete 5 bigtree))
;"bez 6:"
;(delete 6 bigtree)
;(flatten (delete 6 bigtree))
;"bez 7:"
;(delete 7 bigtree)
;(flatten (delete 7 bigtree))

;ZADANIE 7 - w osobnym pliku
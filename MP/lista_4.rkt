#lang racket

;DEFINICJA DRZEWA
(define-struct leaf () #:transparent)
(define-struct node (l elem r) #:transparent)

(define (tree? t)
  (cond [(leaf? t) #t]
        [(node? t) (and (tree? (node-l t)) (tree? (node-r t)))]
        [else #f]))

;ZADANIE 2
(define (fold-tree f t null-val)
  (if (leaf? t)
      null-val
      (f (fold-tree f (node-l t) null-val) (node-elem t) (fold-tree f (node-r t) null-val))))

(define (tree-sum t)
  (fold-tree (λ (x y z)(+ x y z)) t 0))

(define (tree-flip t)
  (fold-tree (λ (x y z)(node z y x)) t (leaf)))

(define (tree-height t)
  (fold-tree (λ (x y z)(if (> x z) (+ x 1) (+ z 1))) t 0))

(define (tree-span t)
  (fold-tree (λ (x y z)(if (leaf? x) (cons y y)(cons (car x) (cdr z)))) t (leaf)))

(define (flatten t)
  (fold-tree (λ (x y z) (append x (cons y z) )) t (list)))

(define tree1
  ( node ( node ( leaf ) 2 ( leaf ) )
       5
       ( node ( node ( leaf ) 6 ( leaf ) )
              8
              ( node ( leaf ) 9 ( leaf ) ) ) ) )

;(tree-sum tree1);działa
;(tree-flip tree1);działa
;(tree-height tree1);działa
;(tree-span tree1);działa
;(flatten tree1);działa

;ZADANIE 3

(define (bst? t)
  (cond [(leaf? t) #t]
        [(leaf? (node-l t)) #t]
        [(and (bst? (node-l t))
                   (and (bst? (node-l t))
                        (and (> (node-elem t)
                                (node-elem (node-l t)))
                             (< (node-elem t)
                               (node-elem (node-r t)))))) #t]
        [else #f]))

;(bst? tree1);działa

(define treeBST tree1 )

;(bst? treeBST);działa

(define (add-path t x)
  (cond [(leaf? t) (leaf)]
        [else (node (add-path (node-l t) (+ x (node-elem t)))
                    (+ x (node-elem t))
                    (add-path (node-r t) (+ x (node-elem t))))]))

(define (sum-paths t)
  (add-path t 0))

tree1

;(sum-paths treeBST)

;ZADANIE 4

;;NIE UMIEM !!!
(define (flat-append t l)
  (cond [(leaf? t) l]
        [(null? l) (cons (node-elem t) (cons (flat-append(node-l t)(list))(flat-append(node-r t)(list))))]
        [else (cons (node-elem t) (cons (flat-append (node-l t) l) ))]))

;(flat-append tree1 (list))
;(flat-append tree1 (list 1 2 3 4 5 6 7))

;ZADANIE 5

(define (insert t x)
  (cond [(leaf? t) (node (leaf) x (leaf))]
        [(node? t)
         (cond [(< x (node-elem t))
                 (node (insert x (node-l t))
                       (node-elem t)
                       (node-r t))]
                [else
                 (node (node-l t)
                       (node-elem t)
                       (insert x (node-r t)))])]))

(insert tree1 1)
;cos nie dziala i nie wiem dlaczego

;ZADANIE 6

;ZADANIE 7

;ZADANIE 8

;ZADANIE 9



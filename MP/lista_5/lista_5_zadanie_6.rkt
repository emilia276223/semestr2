#lang plait

(define-type (rose-trees 'a)
  (leaf [v : 'a])
  (node [ns : (Listof (rose-trees 'a))]))

;wypisanie:

(define (rt-display rt acc)
  (cond [(leaf? rt) (cons (leaf-v rt) acc)]
        [else (foldr (lambda (x xs)  (rt-display x xs)) acc  (node-ns rt))]))

(define (rose-tree-display rt)
  (rt-display rt (list)))

;testy:

(define rt1 (node (list (leaf "x1")
                        (leaf "b3")
                        (leaf "ostatni"))))

(rose-tree-display rt1)

(define rt2 (node (list rt1 (leaf "ccc") (node (list)))))

(rose-tree-display rt2)
#lang plait
(define-type (2-3-Tree 'a)
  (leaf)
  (3node [l : (2-3-Tree 'a)] [val1 : 'a] [s : (2-3-Tree 'a)]
         [val2 : 'a] [r : (2-3-Tree 'a)])
  (2node [l : (2-3-Tree 'a)] [val : 'a] [r : (2-3-Tree 'a)]))


(define-type (4-Tree 'a)
  (2-3-node [node : (2-3-Tree 'a)])
  (4node [l : (2-3-Tree 'a)] [val1 : 'a] [s1 : (2-3-Tree 'a)] [val2 : 'a] [s2 : (2-3-Tree 'a)] [val3 : 'a][r : (2-3-Tree 'a)]))

;typ funkcji pomocniczej: 2-3-Tree -> 4-Tree

(define (insert x t)
  (let ([new-tree (f x t)])
    (type-case (4-Tree 'a) t
      [(4-node l v1 s1 v2 s3 v3 r) (2node (2-node l v1 s1) v2 (2-node s2 v3 r))]
      [(2-3-node n) n])))
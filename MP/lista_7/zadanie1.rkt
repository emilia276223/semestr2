#lang plait
(define-type (2-3-Tree 'a)
  (leaf)
  (3node [l : (2-3-Tree 'a)] [val1 : 'a] [s : (2-3-Tree 'a)]
         [val2 : 'a] [r : (2-3-Tree 'a)])
  (2node [l : (2-3-Tree 'a)] [val : 'a] [r : (2-3-Tree 'a)]))

(define (tree-h t)
  (type-case (2-3-Tree 'a) t 
    [(leaf) 1]
    [(3node l val1 s val2 r) (let ([lh (tree-h l)])
                               (if (equal? lh (tree-h s))
                                   (if (equal? lh (tree-h r))
                                       (+ 1 lh)
                                       -1)
                                   -1))]
    [(2node l val r) (let ([lh (tree-h l)])
                       (if (equal? lh
                                   (tree-h r))
                           (+ 1 lh)
                           -1))]))

(define (tree-min-max t)
  (type-case (2-3-Tree 'a) t
                   ;min    ;max
    [(leaf) (pair +inf.0 -inf.0)]
    [(3node l val1 s val2 r)
     (letrec ([lmm (tree-min-max l)]
              [smm (tree-min-max s)]
              [rmm (tree-min-max r)]
              [lmin (fst lmm)]
              [smin (fst smm)]
              [rmin (fst rmm)]
              [lmax (snd lmm)]
              [smax (snd smm)]
              [rmax (snd rmm)])
       (if (and (<= lmax val1)
                (<= val1 smin)
                (<= smax val2)
                (<= val2 rmin))
           (pair lmin rmax)
           (pair -inf.0 +inf.0)))]
    [(2node l val r)
     (letrec ([lmm (tree-min-max l)]
              [rmm (tree-min-max r)]
              [lmin (fst lmm)]
              [rmin (fst rmm)]
              [lmax (snd lmm)]
              [rmax (snd rmm)])
       (if (and (<= lmax val)
                (<= val rmin))
           (pair lmin rmax)
           (pair -inf.0 +inf.0)))]))

(define (2-3-tree? t)
  (type-case (2-3-Tree 'a) t 
    [(leaf) #t]
    [(3node l val1 s val2 r) (and (not (equal? -1 (tree-h t)))
                                  (not (equal? (tree-min-max t) (pair -inf.0 +inf.0))))]
    [(2node l val r) (and (not (equal? -1 (tree-h t)))
                          (not (equal? (tree-min-max t) (pair -inf.0 +inf.0))))]))


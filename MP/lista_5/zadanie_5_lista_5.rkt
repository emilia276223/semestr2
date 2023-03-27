#lang plait

(define-type (Tree 'a)
  (leaf)
  (node [l : (Tree 'a)] [elem : 'a] [r : (Tree 'a)]))

(define example-tree
  (node (node (leaf) 1 (leaf))
        2
        (node (leaf)
              3
              (node (leaf) 4 (leaf)))))

(define (process-tree fw fl al ap acc t)
  (if (leaf? t) (fl t)
      (fw acc
          (process-tree fw
                        fl
                        al
                        ap
                        (al acc (node-elem t))
                        (node-l t))
          (node-elem t)
          (process-tree fw
                        fl
                        al
                        ap
                        (ap acc (node-elem t))
                        (node-r t)))))

(define (sum-paths t)
  (process-tree (λ (a b c d)(node b (+ a c) d))
                (λ (a) a)
                + + 0 t))
(define new-tree (sum-paths example-tree))

(define (bst? t)
  (fst(process-tree (λ (a b c d)
                  (pair (if (fst b)
                            (if (fst d)
                                (if (< (snd (snd b)) c)
                                    (if (> (fst (snd d)) c)
                                        #t #f)#f)#f)#f)
                        (pair (if (= (fst (snd b)) +inf.0) c (fst (snd b)))
                              (if (= (snd (snd d)) -inf.0) c (snd (snd d))))))
                (λ (a) (pair #t (pair +inf.0 -inf.0)))
                (λ (a c) c)
                (λ (a c) c)
                0
                t)))

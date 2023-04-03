#lang plait
(define (sorted? xs)
  (cond [(empty? xs) #t]
        [(empty? (rest xs)) #t]
        [else (if (<= (first xs) (second xs))
                  (sorted? (rest xs))
                  #f)]))

(define l1 (list 1 2 3 3 5 7))
(define l2 (list 1 7 3 6 5 7))
(sorted? l1)
(sorted? l2)

(define (insert x xs)
  (if (empty? xs)
      (list x)
      (if (<= x (first xs))
          (cons x xs)
          (cons (first xs) (insert x (rest xs))))))

(define new1 (insert 2 l1))
new1
(define new2 (insert 8 new1))
new2
(define new3 (insert 1 new2))
new3
(define new4 (insert 5 new3))
new4

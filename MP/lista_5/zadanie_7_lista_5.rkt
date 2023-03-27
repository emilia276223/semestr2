#lang plait

( define-type Prop
( var [ v : String ])
( conj [ l : Prop ] [ r : Prop ])
( disj [ l : Prop ] [ r : Prop ])
( neg [ f : Prop ]) )

(define (append-bez-powtorzen x l);dziala
  (cond [(empty? l) (list x)]
        [(equal? x (first l)) l]
        [else (cons (first l)
               (append-bez-powtorzen x (rest l)))]))

(define w1 (append-bez-powtorzen 5 (list)))
(define w2 (append-bez-powtorzen 5 (list 1 2 3 4)))
(define w3 (append-bez-powtorzen 5 (list 5 4 3 )))

w1
w2
w3

(define (append-list l1 l2);dziala
  (cond [(empty? l1) l2]
        [(empty? l2) l1]
        [else (append-list (rest l1) (append-bez-powtorzen (first l1) l2))]))

(define l1 (append-list (list) (list)))
(define l2 (append-list (list) (list 2 3 4 5)))
(define l3 (append-list (list 4 5 2 3) (list)))
(define l4 (append-list (list 4 5 6) (list 1 2 3)))
(define l5 (append-list (list 1 2 3 4) (list 1 2 3 5)))

l1
l2
l3
l4
l5

(define (all-vars formula l)
  (cond [(var? formula) (append-bez-powtorzen (var-v formula) l)]
        [(neg? formula) (all-vars (neg-f formula) l)]
        [(disj? formula) (append-list (all-vars (disj-r formula) l)
                           (all-vars (disj-l formula) l))]
        [else (append-list (all-vars (conj-r formula) l)
                           (all-vars (conj-l formula) l))]))

(define (free-vars formula)
  (all-vars formula (list)))

(define f1 (var "a"))
(define f2 (disj (var "a") (neg (var "c"))))

f1
(free-vars f1)
f2
(free-vars f2)

(define f3 (conj (disj (var "a") (neg (var "c"))) (var "a")))
(free-vars f3)
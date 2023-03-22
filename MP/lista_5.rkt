#lang plait
;ZADANIE 1

;('a 'b -> 'a)
(define (f1 x y) x)

;(('a 'b -> 'c) ('a -> 'b) 'a -> 'c)
(define (f2 f g x)
  (f x (g x)))

;((( 'a - > 'a ) - > 'a ) - > 'a )
(define (f3 g)
  (let ([f (λ (x) x)])
  (g id)));nie mam pojecia jak zrobic

;(('a -> 'b) ('a -> 'c) -> ('a -> ('b * 'c)))
(define (f4 f g)
  (λ (x) (pair (f x) (g x))))

;
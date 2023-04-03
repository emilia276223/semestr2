#lang plait
;ZADANIE 1

;('a 'b -> 'a)
(define (f1 x y) x)

;(('a 'b -> 'c) ('a -> 'b) 'a -> 'c)
(define (f2 f g x)
  (f x (g x)))

;((( 'a - > 'a ) - > 'a ) - > 'a )
(define (f3 g)
 (letrec ([f (λ (x) (g (λ (y) x)))]
          [h (λ (x) x)])
   (f (g h))));dziala, nie jestem pewna czemu ale sie nie petli

;(('a -> 'b) ('a -> 'c) -> ('a -> ('b * 'c)))
(define (f4 f g)
  (λ (x) (pair (f x) (g x))))

;(('a - > ( Optionof ('a * 'b ) ) ) 'a - > ( Listof 'b ) )
#;(define (ftest w s1 s2)
  (if w (some (pair s1 s2))
      (none)))
;(some? (ftest #t 1 2)) 
;(some? (ftest #f 1 2))
(define (g5 x) (none))
(define (f5 g x)
  (if (some? (g x))
      (if (equal? x (fst(some-v(g x))))
          (list (snd (some-v (g x))))
          (list))
      (list)))



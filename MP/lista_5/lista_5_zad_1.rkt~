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
(define (f5 g x)
  (if (some? (g x))
      (list (snd (g x)) (snd (g x)))
      (list)));nie dziala, nie wiem jak zrobic


#lang plait

;potrzebne definicje:
( define ( apply f x ) ( f x ) )
( define ( compose f g ) ( lambda ( x ) ( f ( g x ) ) ) )
( define ( flip f ) ( lambda ( x y ) ( f y x ) ) )
( define ( curry f ) ( lambda ( x ) ( lambda ( y ) ( f x y ) ) ) )

;zadanie:

( curry compose )
;(('_a -> '_b) -> (('_c -> '_a) -> ('_c -> '_b)))

;jak to zrobić:
(curry compose)
;(( lambda ( x ) ( lambda ( y ) ( f x y ) ) ) compose)
;( lambda ( x ) ( lambda ( y ) ( compose x y ) ) )
;( lambda (x) (lambda (y) (compose x y)))
;( lambda (x) (lambda (y) (( lambda (z) (x (y z))))))
; lambda 1       2             3
;i teraz typujemy:
;z = 'a
;y = ('a -> 'b)
;x = ('b -> 'c)
;lambda 3 = ('a -> 'c)
;lambda 2 = (('a -> 'b) -> ('a -> 'c))
;lambda 1 = (('b -> 'c) -> (('a -> 'b) -> ('a -> 'c)))
;lambda 1 = (('x -> 'y) -> (('z -> 'x) -> ('z -> 'y)))
;lambda 1 = (('a -> 'b) -> (('c -> 'a) -> ('c -> 'b)))

(( curry compose ) ( curry compose ) )
;(('_a -> ('_b -> '_c))      ->     ('_a -> (('_d -> '_b) -> ('_d -> '_c))))

;lambda 1 = (('a -> 'b) -> (('c -> ('a -> 'b)) -> ('c -> (('c -> 'a) -> ('c -> 'b)))))
;nowe 'a = ('a -> 'b)
;nowe 'b = (('c -> 'a) -> ('c -> 'b))
;lambda 1 = (('d -> 'e) -> (('f -> 'd) -> ('f -> 'e)))

;wynik: (('c -> ('a -> 'b)) -> ('c -> (('c -> 'a) -> ('c -> 'b)))))

(( curry compose ) ( curry apply ) )
;(('_a -> ('_b -> '_c)) -> ('_a -> ('_b -> '_c)))

(curry aply)
;( lambda ( x ) ( lambda ( y ) ( apply x y ) ) ) )
;(lambda (x) (lambda (y) (x y))))
;y = 'a
;x = ('a -> 'b)
;(x y) = 'b
;(('a -> 'b) -> ('a -> 'b))

;(('a -> 'b) -> (('c -> 'a) -> ('c -> 'b)))
;nowe 'a = ('a -> 'b)
;nowe 'b = ('a -> 'b)
;zwracamy:
;(('c -> ('a -> 'b)) -> ('c -> ('a -> 'b)))
 
(( curry apply ) ( curry compose ) )
;(('_a -> '_b) -> (('_c -> '_a) -> ('_c -> '_b)))

;(('a -> 'b) -> ('a -> 'b))
;nowe 'a = ('_a -> '_b)
;nowe 'b = (('_c -> '_a) -> ('_c -> '_b))

;zwracamy:
;(('_a -> '_b) -> (('_c -> '_a) -> ('_c -> '_b)))

( compose curry flip )
;(('_a '_b -> '_c) -> ('_b -> ('_a -> '_c)))

;flip: (lambda (x y) (f y x)))
; ('a 'b -> 'c) -> ('b 'a -> 'c))
;curry: (lambda (x) (lambda (y) (f x y))))
;(('a 'b -> 'c) -> ('a -> ('b -> 'c)))
;( lambda ( x ) ( curry ( flip x ) ) ) )
;     1             2       3
;x = ('a 'b -> 'c)
;(flip x) = ('b 'a -> 'c)
;(curry 3) = ('b -> ('a -> 'c))
;(lambda (x) (2)) = (('a 'b -> 'c) -> ('b -> ('a -> 'c)))
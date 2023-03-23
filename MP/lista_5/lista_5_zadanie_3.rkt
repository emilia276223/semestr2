#lang plait

;potrzebne definicje:
( define ( apply f x ) ( f x ) )
( define ( compose f g ) ( lambda ( x ) ( f ( g x ) ) ) )
( define ( flip f ) ( lambda ( x y ) ( f y x ) ) )
( define ( curry f ) ( lambda ( x ) ( lambda ( y ) ( f x y ) ) ) )

;zadanie:

( curry compose );ma sens
;(('_a -> '_b) -> (('_c -> '_a) -> ('_c -> '_b)))

(( curry compose ) ( curry compose ) );wtf
;(('_a -> ('_b -> '_c)) -> ('_a -> (('_d -> '_b) -> ('_d -> '_c))))

(( curry compose ) ( curry apply ) );???
;(('_a -> ('_b -> '_c)) -> ('_a -> ('_b -> '_c)))

(( curry apply ) ( curry compose ) );???
;(('_a -> '_b) -> (('_c -> '_a) -> ('_c -> '_b)))

( compose curry flip );???
;(('_a '_b -> '_c) -> ('_b -> ('_a -> '_c)))
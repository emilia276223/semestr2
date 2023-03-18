#lang racket

;ZADANIE 1
"chcemy wypisac cos co da ten sam efekt"

(list (cons 'car (list (cons 'a 'b)))(list '* '2))

`( ,( car '( a . b ) ) ,(* 2) )
(list (car (cons 'a 'b)) (* 2))

(list (list '+ '1 '2 '3) (list 'cons) (list 'cons 'a 'b))

;ciekawostka:
''(2,3)
(list 'quote (list 2 (list 'unquote 3))) ;czemu nie dziala
;bez ostatniejlisty??? 
;ZADANIE 2

(define (product xs)
  (define (it xs acc)
    (if (null? xs)
        acc
        (it (cdr xs) (* (car xs) acc))))
  (it xs 1))



(product (list 1 2 3 4))
(product (list 5 10 15))
(product (list 1 2 3 4 5 6 7))

;ZADANIE 3

(( lambda ( x y ) (+ x (* x y ) ) ) 1 2);3
(( lambda ( x ) x ) ( lambda ( x ) x ) );procedura (druga lambda)
(( lambda ( x ) ( x x ) ) ( lambda ( x ) x ) );procedura (druga lambda)  W OBU WYPISUJE SIE TEZ GDZIE DOKLADNIE JEST ZDEFINIOWANA PROCEDURA
;(( lambda ( x ) ( x x ) ) ( lambda ( x ) ( x x ) ) ); druga lambda zaczyna sie rekurencyjnie wywolywac

;ZADANIE 4

(define (square x) (* x x))
(define (inc x) (+ x 1))

(define (my-compose f g)
  (λ (x) (f (g x))))

(( my-compose square inc ) 5)
(( my-compose inc square ) 5)

;ZADANIE 5

;build-list robi n elementowa liste f(0), ..., f(n-1)

(define (negatives n)
  (build-list n (λ (x) (- 0 1 x))))

(negatives 5)

(define (reciprocals n)
  (build-list n (λ (x) (/ 1 (+ 1 x)))))

(reciprocals 5)

(define (evens n)
  (build-list n (λ (x) (* 2 x))))

(evens 5)



(define (identityM n)
  (build-list n (λ (x)
      (build-list n (λ (y) (if (= y x) 1 0))))))

(identityM 1)
(identityM 2)
(identityM 3)
(identityM 4)
(identityM 5)

;ZADANIE 6


;;nie robie tego
#;(define empty-set (list))

#;(define (singleton a)(list a))

#;(define (in a s)
  (cond ((null? s) #f)
        ((equal? (car s) (a)) #t)
        (in a (cdr s))))

#;(define (union s t)
  ())



;ZADANIE 7

( define ( foldr-reverse xs )
( foldr ( lambda ( y ys ) ( append ys ( list y ) ) ) null xs ) )

( length ( foldr-reverse ( build-list 10000 identity ) ) )

;za każdym razem kopiujemy liste więc tworzymy koło n^2 consów,
;a 10000 w zupełności by wystarczyło

;ZADANIE 8
;nie mam
#lang plait
1
#f
;(if #t 42 (+ 5 #t)) ; w rackecie by zadzialalo a tu nie, bo tam by sie wywolalo pierwsze a drugie nie sprawdzilo
not
;boolean? ;nie istnieje
;number? ;nie istnieje

;(if #t (+ 5 3) "inne") ;to tez nie dziala bo zwraca rzeczy roznych typow

;racket to i jezyk i system tworzenia jezykow
; => mozemy sobie zrobic wlasny jezyk

+ ;number -> number
;w plaicie nie mozna przyjac dowolnie wielu argumentow

"x" ;string

;silnia

(define (silnia x) ;domyslil sie ze to number -> number, wiec (silnia "42") nie uruchomi sie
  (if (= x 0) ;dlatego x musi byc liczbą
      1
      (* x (silnia (- x 1)))));jakbysmy dali tu string-append to bylby blad typowania (tzn ze zaden typ by nie dzialal)

(define (returns-8 x) 8) ;mozemy od czegokolwiek zrobic

(define (foo x);musi byc boolean
  (if
   x ;wiec musi byc boolean
   x ;wiec zwraca boolean
   x))

(define (id x) x)
(id id);('_a -> '_a)
(id 1);number
(id "a");string
(id 'a); symbol


;kwantyfikatory sa niejawne

(define (pair-ns)
  (pair (id 1) (id "x")))

#;(define (pair-ns-2 f) ;f nie ma kwantyfikatora => nie dziala
  (pair (f 1) (f "x")))

(define (pair-ns-3 f g) ; ((Number -> 'a) (String -> 'b) -> ('a * 'b))
  (pair (f 1) (g "x")))

;listy przechowuja rzeczy jednego typu
;nie ma lokalnych definow w plaicie
;ale mozna uzyc (local ...)  i wtedy tego defina mozna napisac

;mozna tez uzyc letrec, ktore pozwala sie odwolywac do rzeczy w niej zdefiniowanej (taki rekurencyjny let)

;ale da sie troche oszukać
(letrec [(x (lambda () (+ (x) 1)))] x) ;nie wywala bladu a to jest zapetlenie

;(let [(x (lambda () (+ (x) 1)))] x) ;to nie dziala bo x nie zwiazany

;FUNKCJE WYZSZEGO RZEDU

(define (my-foldr f x xs) ;typ: (('a 'b -> 'b) 'b (Listof 'a) -> 'b)
  (if (empty? xs)
      x
      (f (first xs) (my-foldr f x (rest xs)))))

;typ jest w jakis sensie dokumentacją fukcji

(define (my-foldr-err f x xs) ;typ: (('a (Listof 'a) -> 'b) 'b (Listof 'a) -> 'b)
  (if (empty? xs)
      x
      (f (first xs) (rest xs))))
;po typie da sie rozpoznac ze cos jest nie tak

;jest pewien odpowiednik struktury w rackecie ale ma inny charakter (bo rzeczy sa odróżniane po typie)

;wprowadzanie typow
;1. przenazywanie:
(define-type-alias NumberList (Listof Number))
(define x : NumberList empty)
(cons 1 x);dziala
;(cons "a" x) ;nie dziala

;2. wlasna para
(define-type MyPair
  (my-pair [fst : Number] [snd : String]));konstruktor, selektory, typ
;my-pair == (Number String -> MyPair)

;> (my-pair-fst (my-pair 3 "a"))
;- Number
;3
;> (my-pair-snd (my-pair 3 "a"))
;- String
;"a"

;3. wlasna lista
#;(define-type MyNumList
  (my-empty))


#;(define-type MyNumList
  (my-cons [first : Number] [rest : MyNumList])) ;nie dziala bo dwa razy to samo

(define-type MyNumList
  (myn-empty)
  (myn-cons [first : Number] [rest : MyNumList]))

;> myn-empty
;- (-> MyNumList)
;#<procedure:myn-empty>
;> myn-cons
;- (Number MyNumList -> MyNumList)
;#<procedure:myn-cons>

myn-empty?
myn-cons?

(define-type MyList
  (my-empty)
  (my-cons [first : 'a] [rest : MyList]));wtedy wszystkie sa tego samego typu (tzn jak pierwsza lista w
;programie ma dany typ to reszta tez ma taki sam (inne listy przy tem samym uruchomieniu programu)

;co zrobic zeby byl kwantyfikator???
(define-type (MyNewList 'a)
  (ml-empty)
  (ml-cons [first : 'a] [rest : (MyNewList 'a)]))

;> ml-empty
;- (-> (MyNewList 'a))
;#<procedure:ml-empty>
;> ml-cons
;- ('a MyList -> (MyNewList 'a))
;#<procedure:ml-cons>

(ml-cons 0 (ml-cons 1 (ml-empty)))
;- (MyNewList Number)
;(ml-cons 0 (ml-cons 1 (ml-empty)))
(ml-cons "0" (ml-cons "1" (ml-empty)))
;- (MyNewList String)
;(ml-cons "0" (ml-cons "1" (ml-empty)))


;jest cos jak s-wyrazenia ale na razie z tego nie bedziemy korzystać (dopiero w trzeciej tercji)
;dokladniej nie wiem, az tak nie sluchalam/notowalam

;mozna tez zrobic
(define ml-empty-val (ml-empty))
(ml-cons "0" (ml-cons "1" ml-empty-val))

;DRZEWA
(define-type (Tree 'a)
  (leaf)
  (node [l : (Tree 'a)] [elem : 'a] [r : (Tree 'a)]))

;dziala jak w rackecie +-
;napisalismy jakis kodzik jak w rackecie, tylko z errorami
;drzewo - slownik

;istnieje typ ktory ma wartosc danego typu albo nic
(none)
some


;heterogeniczne listy - nie-jednotypowe

;mozna zrobic wielotypowo listy "zakodowane jednotypowo"
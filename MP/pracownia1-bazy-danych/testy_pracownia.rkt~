#lang racket
;tablice do testow:

(define cities
  (table
   (list (column-info 'city    'string)
         (column-info 'country 'string)
         (column-info 'area    'number)
         (column-info 'capital 'boolean))
   (list (list "Wrocław" "Poland"  293 #f)
         (list "Warsaw"  "Poland"  517 #t)
         (list "Poznań"  "Poland"  262 #f)
         (list "Berlin"  "Germany" 892 #t)
         (list "Munich"  "Germany" 310 #f)
         (list "Paris"   "France"  105 #t)
         (list "Rennes"  "France"   50 #f))))

(define numbered-cities
  (table
   (list (column-info 'city    'string)
         (column-info 'country 'string)
         (column-info 'area    'number)
         (column-info 'capital 'boolean)
         (column-info 'hash 'number))
   (list (list "Wrocław" "Poland"  293 #f 1)
         (list "Wrocław" "Poland"  293 #f 2)
         (list "Warsaw"  "Poland"  517 #t 3)
         (list "Warsaw"  "Poland"  517 #t 4)
         (list "Poznań"  "Poland"  262 #f 5)
         (list "Poznań"  "Poland"  262 #f 6)
         (list "Berlin"  "Germany" 892 #t 7)
         (list "Berlin"  "Germany" 892 #t 8)
         (list "Munich"  "Germany" 310 #f 9)
         (list "Munich"  "Germany" 310 #f 10)
         (list "Paris"   "France"  105 #t 11)
         (list "Paris"   "France"  105 #t 12)
         (list "Rennes"  "France"   50 #f 13))))

(define countries
  (table
   (list (column-info 'country 'string)
         (column-info 'population 'number))
   (list (list "Poland" 38)
         (list "Germany" 83)
         (list "France" 67)
         (list "Spain" 47))))

(define (empty-table columns) (table columns '()))

;funkcje do wyswietlania testow:

(define (print xs)
  (displayln (first xs))
  (if (null? (rest xs))
      (displayln ")")
      (print (rest xs))))

(define (print2 tab)
  (displayln "tablica:")
  (displayln "kolumny:")
  (display "(")
  (print (table-schema tab))
  (displayln "wiersze:")
  (display "(")
  (print (table-rows tab)))

;testy z treści zadań:

(define (orig-tests)
  (displayln "")
  (displayln "table insert")
  (print  (table-rows (table-insert ( list " Rzeszow " " Poland " 129 #f ) cities ) ))
  (displayln "")
  (displayln "table project")
  (print2  ( table-project '( city country ) cities ))
  (displayln "")
  (displayln "table rename")
  (print2  ( table-rename 'city 'name cities ))
  (displayln "")
  (displayln "table sort")
  (print  ( table-rows ( table-sort '( country city ) cities ) ))
  (displayln "")
  (displayln "table select")
  (print  ( table-rows ( table-select ( and-f ( eq-f 'capital #t )( not-f ( lt-f 'area 300) ) )cities ) ))
  (displayln "")
  (displayln "table cross-join")
  (print2  ( table-cross-join cities( table-rename 'country 'country2 countries ) ))
  (displayln "")
  (displayln "table natural-join")
  (print2  ( table-natural-join cities countries ))
  (displayln "")
  (displayln "table how natural join should look like")
  (print2 (table-project '(city country area capital population)
                         (table-select (eq2-f 'country 'country1)
                                       (table-cross-join cities
                                                         (table-rename 'country 'country1 countries))))))

;moje własne testy:
(define (moje-testy)
  (displayln "testy table-select")
  (print (table-rows (table-select (and-f (eq-f 'capital #t) ;dziala dobrze
                                            (not-f (lt-f 'area 300)))
                                     cities)))


  (displayln "testy rename:")
  (print2 (table-rename 'capital 'visited cities))

  (displayln "testy table-cross-join")
  (define cross1 (table-cross-join cities countries))
  (print2 cross1)
  (define cross2 (table-cross-join cross1 countries))
  ;(print2 cross2)
  (define cross3 (table-cross-join cross2 countries))
  ;(print2 cross3)

  (displayln "testy remove-duplicates")
  (displayln (remove-duplicated (table-schema cities)
                              (table-schema countries)))

  (displayln "testy table-insert")
  (print2 (table-insert (list "Toruń"  "Poland" 69 #t) cities))
  ;(table-insert (list "Toruń"  "Poland" 69 #t #t) cities) ;error bo nie pasuje (powinien byc)
  ;(table-insert (list "Toruń"  "Poland" 69 "true") cities) ;error (powinien byc)
  (print2 (table-insert (list "Poland" 420) countries))
  ;(table-insert (list "Poland" "2137") countries) ;error (powinien byc)

  (displayln "test natural-join")
  (print2 (table-natural-join countries cities))
  (print2 (table-natural-join cities countries))

  (displayln "testy table-sort")
  (print2 (table-sort (list 'capital 'city) cities))
  (print2 (table-sort (list 'population 'country) countries))
  (print2 (table-sort (list 'area 'country) numbered-cities))

  (displayln "table project testy:")
  (displayln "1:")
  (print2 (table-project (list `area `city) cities))
  (displayln "2:")
  (displayln (table-project `(money) cities)) ;no jak piszemu glupoty to czemu nie
  (displayln "3:")
  (print2 (table-project `(population money PKB) countries)))
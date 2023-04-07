#lang racket

(provide (struct-out column-info)
         (struct-out table)
         (struct-out and-f)
         (struct-out or-f)
         (struct-out not-f)
         (struct-out eq-f)
         (struct-out eq2-f)
         (struct-out lt-f)
         table-insert ;działa
         table-project ;działa
         table-sort ;działa
         table-select ;dziala dobrze
         table-rename ;działa
         table-cross-join ;działa
         table-natural-join)



(define-struct column-info (name type) #:transparent)

(define-struct table (schema rows) #:transparent)

; Wstawianie

(define (do-for-every-in-rows connecting f rows ys null-f)
  (cond [(null? rows) (null-f ys)]
        [(null? ys) (null-f rows)]
        [else (connecting (f (first rows) (first ys))
                           (do-for-every-in-rows connecting
                                                 f
                                                 (rest rows)
                                                 (rest ys)
                                                 null-f))]))

(define (check-types row ys)
  (do-for-every-in-rows (λ (this rest) (if this rest #f))
                        (λ (row y)
                          (cond 
                            [(equal? 'string (column-info-type y))
                             (string? row)]
                            [(equal? 'symbol (column-info-type y))
                             (symbol? row)]
                            [(equal? 'boolean (column-info-type y))
                             (boolean? row)]
                            [(equal? 'number (column-info-type y))
                             (number? row)]
                            [else #f]))
                        row
                        ys
                        null?))

(define (check-types-tab row tab)
  (check-types row (table-schema tab)))

(define (table-insert row tab)
  (if (check-types-tab row tab)
      (table (table-schema tab) (cons row (table-rows tab)))
      (error 'row-does-not-fit)))

; Projekcja

(define (apply-to-all-rows connect f rows)
  (if (null? rows) null
      (connect (f (first rows))
            (apply-to-all-rows connect f (rest rows)))))

(define (remove-first-from-all rows)
  (apply-to-all-rows cons
                     (λ (row) (rest row))
                     rows))

(define (replace-rest-in-all-rows rows-original new-ends)
  (do-for-every-in-rows cons
                        (λ (row rest) (cons (first row) rest))
                        rows-original
                        new-ends
                        (λ (x) null)))

(define (table-project cols tab)
  (cond [(null? cols) (table (list) (list))]
        [(null? (table-schema tab)) tab]
        [else (let ([tab-of-rest (table-project cols
                                                (table (rest (table-schema tab))
                                                       (remove-first-from-all (table-rows tab))))])
                (if (member (column-info-name (first (table-schema tab))) cols)
                    (table (cons (first (table-schema tab)) (table-schema tab-of-rest))
                           (replace-rest-in-all-rows (table-rows tab) (table-rows tab-of-rest)))
                    tab-of-rest))]))

; Sortowanie
(define (cmp x y)
  (cond [(string? x) (string<? x y)]
        [(boolean? x) (if x #f y)];f < t
        [(number? x) (if (number? y)
                         (< x y)
                         (error 'cmp "Jedna zmienna number a druga inna"))]
        [(symbol? x) (cmp (symbol->string x) (symbol->string x))]))

(define (get-element name cols row)
  (cond [(null? cols) (error 'the-column-does-not-exist)]
        [(equal? name (column-info-name (first cols))) (first row)]
        [else (get-element name (rest cols) (rest row))]))

(define (czy-w-dobrej-kolejnosci row1 whole-row1
                                 row2 whole-row2
                                 cols
                                 tab-schema whole-tab-schema) ;powinno sprawdzac dobrze
  (cond [(null? cols) #f]
        [(null? tab-schema) #f]
        [(equal? (first cols) (column-info-name (first tab-schema)));dobry element
         (if (equal? (first row1) (first row2));takie same
             (czy-w-dobrej-kolejnosci whole-row1 whole-row1
                                      whole-row2 whole-row2
                                      (rest cols)
                                      whole-tab-schema whole-tab-schema)
             (cmp (first row1) (first row2)))]
        [else (czy-w-dobrej-kolejnosci (rest row1) whole-row1
                                       (rest row2) whole-row2
                                       cols
                                       (rest tab-schema) whole-tab-schema)]))

(define (wstaw-w-dobre-miejsce x xs cols tab-schema)
  (cond [(null? xs) (list x)]
        [(czy-w-dobrej-kolejnosci x x
                                  (first xs) (first xs)
                                  cols
                                  tab-schema
                                  tab-schema)
         (cons x xs)]
        [else (cons (first xs)
                    (wstaw-w-dobre-miejsce x (rest xs) cols tab-schema))]))

(define (insert-sort rows-to-add sorted cols tab-schema)
  (cond [(null? rows-to-add) sorted]
        [(insert-sort (rest rows-to-add)
                      (wstaw-w-dobre-miejsce (first rows-to-add)
                                             sorted
                                             cols
                                             tab-schema)
                      cols
                      tab-schema)]))
  
(define (table-sort cols tab)
  (table (table-schema tab)
         (insert-sort (table-rows tab)
               (list)
               cols
               (table-schema tab))))

; Selekcja

(define-struct and-f (l r));conjunction
(define-struct or-f (l r));disjunction
(define-struct not-f (e));negation
(define-struct eq-f (name val));wartosc kolumny name rowna val
(define-struct eq2-f (name name2));wartosci name i name2 są równe
(define-struct lt-f (name val));wartosc kolumny name mniejsza niz val


(define (is-formula-satisfied fi row tab-schema)
  (cond [(and-f? fi) (and (is-formula-satisfied (and-f-l fi) row tab-schema)
                          (is-formula-satisfied (and-f-r fi) row tab-schema))]
        [(and-f? fi) (or (is-formula-satisfied (or-f-l fi) row tab-schema)
                          (is-formula-satisfied (or-f-r fi) row tab-schema))]
        [(not-f? fi) (not (is-formula-satisfied (not-f-e fi) row tab-schema))]
        [(eq-f? fi) (equal? (get-element (eq-f-name fi) tab-schema row) (eq-f-val fi))]
        [(eq2-f? fi) (equal? (get-element (eq2-f-name fi) tab-schema row)
                             (get-element (eq2-f-name2 fi) tab-schema row))]
        [(lt-f? fi) (let ([val (get-element (lt-f-name fi) tab-schema row)])
                     (cmp val (lt-f-val fi)))];zmienione, że zamiast (if (equal) #f cmp) jest cmp
        [(boolean? fi) #t]
        [else (error 'fi-is-not-formula)]))

(define (satisfying-only fi rows tab-schema)
  (cond [(null? rows) null]
        [(is-formula-satisfied fi (first rows) tab-schema)
         (cons (first rows) (satisfying-only fi (rest rows) tab-schema))]
        [else (satisfying-only fi (rest rows) tab-schema)]))

(define (table-select form tab) 
  (table (table-schema tab)
         (satisfying-only form
                          (table-rows tab)
                          (table-schema tab))))

; Zmiana nazwy

(define (name-change col ncol columns)
  (cond [(null? columns) null]
        [(equal? (column-info-name (first columns)) col)
         (cons (column-info ncol
                            (column-info-type
                             (first columns)))
               (rest columns))]
        [else (cons (first columns)
                    (name-change col ncol (rest columns)))]))

(define (table-rename col ncol tab)
  (table (name-change col ncol (table-schema tab)) (table-rows tab)))

(define (rename-col col)
  (column-info (string->symbol (string-append (symbol->string (column-info-name col)) "2x_2")) (column-info-type col)))

; Złączenie kartezjańskie
(define (rename-duplicates cols1 cols2)
  (cond [(null? cols2) cols2]
        [(null? cols1) cols2]
        [(member (first cols2) cols1)
         (rename-duplicates cols1 (cons (rename-col (first cols2 ))
                                        (rest cols2)))]
        [else (cons (first cols2) (rename-duplicates cols1 (rest cols2)))]))

(define (table-cross-join tab1 tab2)
  (table (append (table-schema tab1)
                 (rename-duplicates (table-schema tab1)
                                    (table-schema tab2)))
   (apply-to-all-rows append
                     (λ (row) (apply-to-all-rows cons
                                                 (λ (row2) (append row row2))
                                                 (table-rows tab2)))
                     (table-rows tab1))))

; Złączenie
(define (extract-column-names tab-schema)
  (if (null? tab-schema)
      null
      (cons (column-info-name (first tab-schema)) (extract-column-names (rest tab-schema)))))

(define (should-be-connected? col-names-1 col-names-2 cols1 cols2 row1 row2)
  (cond [(null? col-names-1) #t]
        [(null? col-names-2) #t]
        [(member (first col-names-2) col-names-1)
         (if (equal? (get-element (first col-names-2) cols1 row1)
                     (get-element (first col-names-2) cols2 row2))
             (should-be-connected? col-names-1
                                   (rest col-names-2)
                                   cols1 cols2
                                   row1 row2)
             #f)]
        [else (should-be-connected? col-names-1
                                   (rest col-names-2)
                                   cols1 cols2
                                   row1 row2)]))

(define (remove-duplicated xs ys);modyfikuje pierwsza liste
  (cond [(null? xs) ys]
        [(null? ys) xs]
        [(member (first xs) ys) (remove-duplicated (rest xs) ys)];dziala bo jak jest inny typ to nie polaczy a to nie moj problem wtedy
        [else (cons (first xs) (remove-duplicated (rest xs) ys))]))

(define (merge-rows row1 row2 cols1 cols2 merged-cols)
  (cond [(null? row1) row2]
        [(equal? (first cols1) (first merged-cols))
         (cons (first row1)
               (merge-rows (rest row1) row2
                           (rest cols1) cols2 (rest merged-cols)))]
        [else (merge-rows (rest row1) row2
                           (rest cols1) cols2 merged-cols)]))

(define (merge-to-all row fitting-sorted2 cols1 cols2 col-names-1 col-names-2 merged-cols)
  (cond [(null? fitting-sorted2) (cons null fitting-sorted2)];skonczylo sie z czym pasowac
        [(should-be-connected? col-names-1 col-names-2
                               cols1 cols2
                               row (first fitting-sorted2))
         (let ([previous (merge-to-all row (rest fitting-sorted2)
                                       cols1 cols2
                                       col-names-1 col-names-2
                                       merged-cols)])
           (cons (cons (merge-rows row (first fitting-sorted2) cols1 cols2 merged-cols);zestaw wierszy
                       (car previous))
                 fitting-sorted2))];pierwsze ktore pasowalo
        [else (cons null fitting-sorted2)]));przestaly pasowac

(define (row-cmp row1 row1-orig row2 row2-orig ;zmieniłam cmp ale jestem przekonana, że nadal powinno działać
                 merged-cols cols1 cols1-orig cols2 cols2-orig)
  (cond [(null? merged-cols) #t]
        [(null? cols1) #t]
        [(null? cols2) #f]
        [(equal? (column-info-name (first merged-cols))
                 (column-info-name (first cols1)))
         (if (equal? (column-info-name (first cols1))
                     (column-info-name (first cols2))) ;jesli takie same
             (if (equal? (first row1) (first row2)) ;czy w dobrej kolejnosci
                 (row-cmp row1-orig row1-orig row2-orig row2-orig
                          (rest merged-cols) cols1-orig cols1-orig cols2-orig cols2-orig)
                 (cmp (first row1) (first row2)))
             (row-cmp row1 row1-orig (rest row2) row2-orig
                      merged-cols cols1 cols1-orig (rest cols2) cols2-orig))];jesli rozne
        [(equal? (column-info-name (first merged-cols))
                 (column-info-name (first cols2)))
         (row-cmp (rest row1) row1-orig row2 row2-orig
                  merged-cols (rest cols1) cols1-orig cols2 cols2-orig)]
        [else (row-cmp (rest row1) row1-orig (rest row2) row2-orig
                       merged-cols (rest cols1) cols1-orig (rest cols2) cols2-orig)]))

(define (natural-join sorted1 sorted2 cols1 cols2 merged-cols col-names-1 col-names-2) ;lacze wszystkie pasujace do danej z 1
  (cond [(null? sorted1) null];jesli juz nic nie laczymy
        [(null? sorted2) null]
        [(should-be-connected? col-names-1 col-names-2 ;jesli pasują
                               cols1 cols2
                               (first sorted1) (first sorted2))
         (let ([merge (merge-to-all (first sorted1) sorted2
                                    cols1 cols2
                                    col-names-1 col-names-2
                                    merged-cols)])
           (append (first merge)
                   (natural-join (rest sorted1) (rest merge)
                                 cols1 cols2 merged-cols
                                 col-names-1 col-names-2)))]
        [(row-cmp (first sorted1) (first sorted1) ;jesli nie pasuja musze sprawdzic kto ma byc pierwszy (nie mam pojecia czy zadziala ale chyba powinno
                  (first sorted2) (first sorted2) 
                  merged-cols
                  cols1 cols1 cols2 cols2) ;jesli w pierwszej jest mniejsze => nie ma jego odpowiednikow => idziemy do nastepnego
         (natural-join (rest sorted1) sorted2 cols1 cols2 merged-cols col-names-1 col-names-2)]
        [else (natural-join sorted1 (rest sorted2) cols1 cols2 merged-cols col-names-1 col-names-2)]
        ))

(define (duplicated-cols cols1 cols2)
  (if (null? cols1)
      null
      (if (member (first cols1) cols2)
          (cons (first cols1) (duplicated-cols (rest cols1) cols2))
          (duplicated-cols (rest cols1) cols2))))

(define (table-natural-join tab1 tab2)
  (letrec ([col-names-1 (extract-column-names (table-schema tab1))]
           [col-names-2 (extract-column-names (table-schema tab2))]
           [merged-cols (remove-duplicated (table-schema tab1) (table-schema tab2))]
           [duplicates (duplicated-cols (table-schema tab1) (table-schema tab2))]
           [duplicated-col-names (extract-column-names duplicates)]
           [sorted1 (table-rows (table-sort duplicated-col-names tab1))]
           [sorted2 (table-rows (table-sort duplicated-col-names tab2))])
    (table merged-cols
           (natural-join sorted1 sorted2 (table-schema tab1) (table-schema tab2) merged-cols col-names-1 col-names-2))))

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
  (print2  ( table-project '( city country area capital population )( table-select ( eq2-f 'country 'country1 )( table-cross-join cities( table-rename 'country 'country1 countries ) ) ) )))

;moje własne testy:
(define (moje-testy)
  (displayln "testy table-select")
  (print (table-rows (table-select (and-f (eq-f 'capital #t) ;dziala dobrze
                                            (not-f (lt-f 'area 300)))
                                     cities)))


  (displayln "testy rename:")
  (print2 (table-rename 'capital 'visited cities))

  (displayln "test rename-col")
  (displayln (rename-col (column-info 'abc 'boolean)))

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


  (displayln "test should be connected")
  (displayln (should-be-connected? (list `city `country `area `capital) (list `country `population);#t
                                 (table-schema cities) (table-schema countries)
                                 (list "Wrocław" "Poland"  293 #f) (list "Poland" 38)))

  (displayln (should-be-connected? (list `city `country `area `capital) (list `country `population);#t
                                 (table-schema cities) (table-schema countries)
                                 (list "Rennes"  "France"   50 #f) (list "France" 67)))

  (displayln (should-be-connected? (list `city `country `area `capital) (list `country `population);#f
                                 (table-schema cities) (table-schema countries)
                                 (list "Poznań"  "Poland"  262 #f) (list "Germany" 83)))


  (displayln "test merge-to-all")
  (print (merge-to-all (list "Poland" 38) (table-rows cities)
                         (table-schema countries) (table-schema cities)
                         (extract-column-names (table-schema countries))
                         (extract-column-names (table-schema cities))
                         (remove-duplicated (table-schema countries) (table-schema cities))))


  (displayln "testy table-insert")
  (print2 (table-insert (list "Toruń"  "Poland" 69 #t) cities))
  ;(table-insert (list "Toruń"  "Poland" 69 #t #t) cities) ;error bo nie pasuje (powinien byc)
  ;(table-insert (list "Toruń"  "Poland" 69 "true") cities) ;error (powinien byc)
  (print2 (table-insert (list "Poland" 420) countries))
  ;(table-insert (list "Poland" "2137") countries) ;error (powinien byc)

  (displayln "tesy remove-first:")
  (define last3 (remove-first-from-all (table-rows cities)))
  (displayln last3)
  (define last2 (remove-first-from-all last3))
  (displayln last2)

  (displayln "row-cmp testy")
  (displayln (row-cmp (list "Wrocław" "Poland"  293 #f) (list "Wrocław" "Poland"  293 #f)
                    (list "Poland" 38) (list "Poland" 38)
                    (remove-duplicated (table-schema cities) (table-schema countries))
                    (table-schema cities) (table-schema cities)
                    (table-schema countries) (table-schema countries)))

  (displayln (row-cmp (list "Wrocław" "Poland"  293 #f) (list "Wrocław" "Poland"  293 #f)
                    (list "Germany" 83) (list "Germany" 83)
                    (remove-duplicated (table-schema cities) (table-schema countries))
                    (table-schema cities) (table-schema cities)
                    (table-schema countries) (table-schema countries)))

  (displayln (row-cmp (list "Munich"  "Germany" 310 #f) (list "Munich"  "Germany" 310 #f)
                    (list "Poland" 38) (list "Poland" 38)
                    (remove-duplicated (table-schema cities) (table-schema countries))
                    (table-schema cities) (table-schema cities)
                    (table-schema countries) (table-schema countries)))


  (displayln "test natural-join")
  (print2 (table-natural-join countries cities))
  (print2 (table-natural-join cities countries))

  (displayln "testy replace:")
  (print (replace-rest-in-all-rows (table-rows countries)
                                     (list (list "aaa")
                                           (list "bbb")
                                           (list "ccc")
                                           (list "ddd"))))

  (displayln "testy czy-w-dobrej-kolejnosci")
  (displayln (czy-w-dobrej-kolejnosci (first (table-rows cities))
                                    (first (table-rows cities));#f
                                    (second (table-rows cities))
                                    (second (table-rows cities))
                                    (list `city)
                                    (table-schema cities)
                                    (table-schema cities)))

  (displayln (czy-w-dobrej-kolejnosci (first (table-rows cities))
                                    (first (table-rows cities));#t
                                    (second (table-rows cities))
                                    (second (table-rows cities))
                                    (list `area)
                                    (table-schema cities)
                                    (table-schema cities)))

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
  (print2 (table-project `(population money PKB) countries))

  (displayln "test merge-rows")
  (displayln (merge-rows (list "Wrocław" "Poland"  293 #f)
                       (list "Poland" 38)
                       (table-schema cities)
                       (table-schema countries)
                       (remove-duplicated (table-schema cities) (table-schema countries))))
  )
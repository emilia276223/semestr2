#lang racket

;autorka: Emilia Wiśniewska

(provide (struct-out column-info)
         (struct-out table)
         (struct-out and-f)
         (struct-out or-f)
         (struct-out not-f)
         (struct-out eq-f)
         (struct-out eq2-f)
         (struct-out lt-f)
         table-insert 
         table-project
         table-sort 
         table-select 
         table-rename 
         table-cross-join
         table-natural-join)

(define-struct column-info (name type) #:transparent)

(define-struct table (schema rows) #:transparent)

; Wstawianie

(define (do-for-every-in-rows connecting f rows ys null-f);każdy z pierwszej listy "łączę" z odpowiadającym z drugiej
  (cond [(null? rows) (null-f ys)]
        [(null? ys) (null-f rows)]
        [else (connecting (f (first rows) (first ys))
                           (do-for-every-in-rows connecting f (rest rows) (rest ys) null-f))]))

(define (check-types row ys) ;sprawdzenie czy zgadzają się wszystkie typy (i ich ilość)
  (do-for-every-in-rows (λ (x y) (and x y))
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
                        row ys null?))

(define (table-insert row tab) ;wstawienie elementu do tablicy
  (if (check-types row (table-schema tab))
      (table (table-schema tab) (cons row (table-rows tab)))
      (error 'row-does-not-fit)))

; Projekcja

(define (apply-to-all-rows connect f rows) ;przerobienie każdego wiersza funkcją f
  (if (null? rows) null
      (connect (f (first rows))
            (apply-to-all-rows connect f (rest rows)))))

(define (remove-first-from-all rows) ;usunięcie pierwszego elementu z każdego wiersza
  (apply-to-all-rows cons
                     (λ (row) (rest row))
                     rows))

(define (replace-rest-in-all-rows rows-original new-ends) ;zamiania końcówek w każdym z rzędów
  (do-for-every-in-rows cons
                        (λ (row rest) (cons (first row) rest))
                        rows-original
                        new-ends
                        (λ (x) null)))

(define (table-project cols tab) ;usunięcie wszystkich wierszy poza podanymi
  (cond [(null? (table-schema tab)) tab]
        [else (let ([tab-of-rest (table-project cols
                                                (table (rest (table-schema tab))
                                                       (remove-first-from-all (table-rows tab))))])
                (if (member (column-info-name (first (table-schema tab))) cols)
                    (table (cons (first (table-schema tab)) (table-schema tab-of-rest))
                           (replace-rest-in-all-rows (table-rows tab) (table-rows tab-of-rest)))
                    tab-of-rest))]))


; Sortowanie
(define (cmp x y) ;porównanie dwóch elementów
  (cond [(string? x) (string<? x y)]
        [(boolean? x) (if x #f y)];f < t
        [(number? x) (if (number? y) (< x y) (error 'cmp "Jedna zmienna number a druga inna"))]
        [(symbol? x) (cmp (symbol->string x) (symbol->string x))]))

(define (get-element name cols row) ;wzięcie elementu z podanej kolumny 
  (cond [(null? cols) (error 'the-column-does-not-exist)]
        [(equal? name (column-info-name (first cols))) (first row)]
        [else (get-element name (rest cols) (rest row))]))

(define (czy-w-dobrej-kolejnosci row1 whole-row1 row2 whole-row2 ;czy te dwa rzędy są w "dobrej" kolejności
                                 cols tab-schema whole-tab-schema) 
  (cond [(null? cols) #f]
        [(null? tab-schema) #f]
        [(equal? (first cols) (column-info-name (first tab-schema)));dobry element
         (if (equal? (first row1) (first row2));takie same
             (czy-w-dobrej-kolejnosci whole-row1 whole-row1 whole-row2 whole-row2
                                      (rest cols) whole-tab-schema whole-tab-schema)
             (cmp (first row1) (first row2)))]
        [else (czy-w-dobrej-kolejnosci (rest row1) whole-row1
                                       (rest row2) whole-row2
                                       cols (rest tab-schema) whole-tab-schema)]))

(define (wstaw-w-dobre-miejsce x xs cols tab-schema) ;wstawienie rzędu w odpowiednie miejsce
  (cond [(null? xs) (list x)]
        [(czy-w-dobrej-kolejnosci x x (first xs) (first xs)
                                  cols tab-schema tab-schema)
         (cons x xs)]
        [else (cons (first xs)
                    (wstaw-w-dobre-miejsce x (rest xs) cols tab-schema))]))

(define (insert-sort rows-to-add sorted cols tab-schema) ;posortowanie wierszy
  (cond [(null? rows-to-add) sorted]
        [(insert-sort (rest rows-to-add)
                      (wstaw-w-dobre-miejsce (first rows-to-add)
                                             sorted cols tab-schema)
                      cols tab-schema)]))
  
(define (table-sort cols tab) ;posortowanie tabeli
  (table (table-schema tab)
         (insert-sort (table-rows tab) (list) cols (table-schema tab))))

; Selekcja

(define-struct and-f (l r));conjunction
(define-struct or-f (l r));disjunction
(define-struct not-f (e));negation
(define-struct eq-f (name val));wartosc kolumny name rowna val
(define-struct eq2-f (name name2));wartosci name i name2 są równe
(define-struct lt-f (name val));wartosc kolumny name mniejsza niz val

(define (is-formula-satisfied fi row tab-schema) ;czy formuła jest spełniona
  (cond [(and-f? fi) (and (is-formula-satisfied (and-f-l fi) row tab-schema)
                          (is-formula-satisfied (and-f-r fi) row tab-schema))]
        [(or-f? fi) (or (is-formula-satisfied (or-f-l fi) row tab-schema)
                          (is-formula-satisfied (or-f-r fi) row tab-schema))]
        [(not-f? fi) (not (is-formula-satisfied (not-f-e fi) row tab-schema))]
        [(eq-f? fi) (equal? (get-element (eq-f-name fi) tab-schema row) (eq-f-val fi))]
        [(eq2-f? fi) (equal? (get-element (eq2-f-name fi) tab-schema row)
                             (get-element (eq2-f-name2 fi) tab-schema row))]
        [(lt-f? fi) (let ([val (get-element (lt-f-name fi) tab-schema row)])
                     (cmp val (lt-f-val fi)))];zmienione, że zamiast (if (equal) #f cmp) jest cmp
        [(boolean? fi) #t]
        [else (error 'fi-is-not-formula)]))

(define (satisfying-only fi rows tab-schema);zwrócenie jedynie wierszy spełniających formułę
  (cond [(null? rows) null]
        [(is-formula-satisfied fi (first rows) tab-schema)
         (cons (first rows) (satisfying-only fi (rest rows) tab-schema))]
        [else (satisfying-only fi (rest rows) tab-schema)]))

(define (table-select form tab) ;utworzenie tablicy zawierającej jedynie wiersze spełniające formułę
  (table (table-schema tab)
         (satisfying-only form (table-rows tab)
                          (table-schema tab))))

; Zmiana nazwy

(define (name-change col ncol columns) ;zmiana nazwy kolumny
  (cond [(null? columns) null]
        [(equal? (column-info-name (first columns)) col)
         (cons (column-info ncol
                            (column-info-type
                             (first columns)))
               (rest columns))]
        [else (cons (first columns)
                    (name-change col ncol (rest columns)))]))

(define (table-rename col ncol tab) ;tablica ze zmienioną nazwą kolumny
  (table (name-change col ncol (table-schema tab)) (table-rows tab)))


; Złączenie kartezjańskie

(define (table-cross-join tab1 tab2) ;połączenie kartezjańskie zbiorów
  (table (append (table-schema tab1) (table-schema tab2))
   (apply-to-all-rows append
                      (λ (row) (apply-to-all-rows cons
                                                  (λ (row2) (append row row2))
                                                  (table-rows tab2)))
                      (table-rows tab1))))


; Złączenie

(define (extract-column-names tab-schema); utworzenie listy zawierającej same nazwy kolumn
  (if (null? tab-schema)
      null
      (cons (column-info-name (first tab-schema)) (extract-column-names (rest tab-schema)))))

(define (should-be-connected? col-names-1 col-names-2 cols1 cols2 row1 row2) ;czy dwa wiersze powinny zostać połączone
  (cond [(null? col-names-1) #t]
        [(null? col-names-2) #t]
        [(member (first col-names-2) col-names-1)
         (if (equal? (get-element (first col-names-2) cols1 row1)
                     (get-element (first col-names-2) cols2 row2))
             (should-be-connected? col-names-1
                                   (rest col-names-2)
                                   cols1 cols2
                                   row1 row2) #f)]
        [else (should-be-connected? col-names-1 (rest col-names-2)
                                   cols1 cols2 row1 row2)]))

(define (remove-duplicated xs ys);modyfikuje pierwsza liste, usuwa duplikaty
  (cond [(null? xs) ys]
        [(null? ys) xs]
        [(member (first xs) ys) (remove-duplicated (rest xs) ys)];dziala bo jak jest inny typ to 
        [else (cons (first xs) (remove-duplicated (rest xs) ys))]));nie polaczy a to nie moj problem wtedy

(define (merge-rows row1 row2 cols1 cols2 merged-cols) ;połączenie dwóch wierszy
  (cond [(null? row1) row2]
        [(equal? (first cols1) (first merged-cols))
         (cons (first row1)
               (merge-rows (rest row1) row2
                           (rest cols1) cols2 (rest merged-cols)))]
        [else (merge-rows (rest row1) row2
                           (rest cols1) cols2 merged-cols)]))

(define (merge-to-all row fitting-sorted2 cols1 cols2 col-names-1 col-names-2 merged-cols) ;połączenie wiersza z wszystkimi pasującymi
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

(define (row-cmp row1 row1-orig row2 row2-orig ;porównanie wierszy (który jest "mniejszy")
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

(define (natural-join sorted1 sorted2 cols1 cols2 merged-cols col-names-1 col-names-2) ;łączę z pasującymi
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
        [(row-cmp (first sorted1) (first sorted1) ;jesli nie pasuja musze sprawdzic kto ma byc pierwszy
                  (first sorted2) (first sorted2) ;(nie mam pojecia czy zadziala ale chyba powinno)
                  merged-cols
                  cols1 cols1 cols2 cols2) ;jesli w pierwszej jest mniejsze => nie ma jego odpowiednikow =>
         (natural-join (rest sorted1) sorted2 cols1 cols2 merged-cols col-names-1 col-names-2)]; do nastepnego
        [else (natural-join sorted1 (rest sorted2) cols1 cols2 merged-cols col-names-1 col-names-2)]
        ))

(define (duplicated-cols cols1 cols2) ;wybranie powtórzonych kolumn
  (if (null? cols1)
      null
      (if (member (first cols1) cols2)
          (cons (first cols1) (duplicated-cols (rest cols1) cols2))
          (duplicated-cols (rest cols1) cols2))))

(define (table-natural-join tab1 tab2) ;połączenie naturalne
  (letrec ([col-names-1 (extract-column-names (table-schema tab1))]
           [col-names-2 (extract-column-names (table-schema tab2))]
           [merged-cols (remove-duplicated (table-schema tab1) (table-schema tab2))]
           [duplicates (duplicated-cols (table-schema tab1) (table-schema tab2))]
           [duplicated-col-names (extract-column-names duplicates)]
           [sorted1 (table-rows (table-sort duplicated-col-names tab1))]
           [sorted2 (table-rows (table-sort duplicated-col-names tab2))])
    (displayln "przebieg natural-join")
    (displayln sorted1)
    (displayln sorted2)
    (table merged-cols
           (natural-join sorted1 sorted2 (table-schema tab1) (table-schema tab2)
                         merged-cols col-names-1 col-names-2))))

;;TABLICE DO TESTOW
(define countries
  (table
   (list (column-info 'country 'string)
         (column-info 'population 'number))
   (list (list "Poland" 38)
         (list "Germany" 83)
         (list "France" 67)
         (list "Spain" 47))))

(define countries2
  (table
   (list (column-info 'country 'string)
         (column-info 'population 'number))
   (list (list "Poland" 38)
         (list "Germany" 83)
         (list "France" 67)
         (list "Spain" 47)
         (list "Poland" 380)
         (list "Germany" 830)
         (list "France" 670)
         (list "Spain" 470))))


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

(define cities-but-more
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
         (list "Rennes"  "France"   50 #f)
         (list "Wrocław" "Poland"  299 #f)
         (list "Warsaw"  "Poland"  518 #t)
         (list "Poznań"  "Poland"  25 #f)
         (list "Berlin"  "Germany" 897 #t)
         (list "Munich"  "Germany" 315 #f)
         (list "Paris"   "France"  102 #t)
         (list "Rennes"  "France"   53 #f))));powtorki ze zmienionymi liczbami


;testy od Miłosza:
;(table-project empty countries)
;(table-project empty cities)
;(table '() '(() () () ()))
;(table-cross-join countries (table empty empty))
;(table (list (column-info 'country 'string) (column-info 'population 'number)) '())
;(table-natural-join (table empty empty) countries)
;(table-natural-join (table empty empty) cities)
;(table-natural-join cities (table empty empty))
;(table-natural-join countries (table empty empty))
;(table-cross-join cities (table empty empty))
;(table-cross-join (table empty empty) cities)
;(table-natural-join cities countries)
;(table-natural-join cities-but-more countries)
;(table-natural-join cities countries2)
;(table-natural-join cities-but-more countries2)



;nowe testy:
;testy




(define (empty-table columns) (table columns '()))



;"testy table-insert"
;(table-insert (list "Toruń"  "Poland" 69 #t) cities)
;;(table-insert (list "Toruń"  "Poland" #t) cities)
;;(table-insert (list "Toruń"  "Poland" 69 #t #t) cities) ;error bo nie pasuje (powinien byc)
;;(table-insert (list "Toruń"  "Poland" 69 "true") cities) ;error (powinien byc)
;(table-insert (list "Poland" 420) countries)
;;(table-insert (list "Poland" "2137") countries) ;error (powinien byc)


;testy
(define test-tab
  (table
   (list )
   (list (list )
         (list )
         (list )
         (list )
         (list )
         (list )
         (list ))))

#;(define test-tab-2
  (table (list )
   (list 
         (list 'Poznań  "Poland"  262 #f)
         (list 'Berlin  "Germany" 892 #t)
         (list 'Munich  "Germany" 310 #f)
         (list 'Paris   "France"  105 #t)
         (list 'Rennes  "France"   50 #f))))

(define test-tab-3
  (table
   (list (column-info 'city    'string)
         (column-info 'country 'string)
         (column-info 'area    'number)
         (column-info 'capital 'boolean))
   (list )))


;(table-project (list 'PKB) (table null null))
;(table-project (list) cities)
;(table-project (list) (table null null))
;(table-project (list 'prawa 'lewa 'start) test-tab)

;(table-project (list 'PKB) test-tab-3)
;(table-project (list) test-tab-3)
;(table-project (list) test-tab-3)
;(table-project (list 'city 'area) test-tab-3)

;testy

;""
;"testy sort"
;(table-sort (list 'PKB) (table null null))
;(table-sort (list) cities)
;cities
;(table-sort (list) (table null null))
;(table-sort (list 'prawa 'lewa 'start) test-tab)

;(table-sort (list 'PKB) test-tab-3)
;(table-sort (list) test-tab-3)
;(table-sort (list 'city 'area) test-tab-3)



;""
;"testy rename"
;(table-rename 'PKB 'PKD (table null null))
;(table-rename 'city 'area cities)

;(table-rename 'city 'jhtdxcvbhj (table null null))
;(table-rename 'prawa 'lewa test-tab)

;(table-rename 'PKB 'city test-tab-3)
;(table-rename 'city 'area test-tab-3)
;(table-rename 'country 'akjhgcvb test-tab-3)


;""
;"table-cross testy"
;""
;cities
;""
;test-tab
;""
;test-tab-3


;(table-cross-join cities test-tab)
;(table-cross-join test-tab-3 test-tab);puste
;(table-cross-join test-tab test-tab-3);puste
;(table-cross-join test-tab-3 test-tab-3);puste
;(table-cross-join cities test-tab-3);puste
;(table-cross-join countries countries)

;""
;""
;""
;""
;"testy natural"
;(table-natural-join cities countries)
;(table-natural-join cities test-tab)
;(table-natural-join test-tab countries)
;(table-natural-join cities test-tab-3)
;(table-natural-join test-tab-3 countries)
;(table-natural-join test-tab-3 test-tab)





;tablice do testow:

#;(define cities
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

#;(define countries
  (table
   (list (column-info 'country 'string)
         (column-info 'population 'number))
   (list (list "Poland" 38)
         (list "Germany" 83)
         (list "France" 67)
         (list "Spain" 47))))

;(define (empty-table columns) (table columns '()))

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

  ;(displayln "test rename-col")
  ;(displayln (rename-col (column-info 'abc 'boolean)))

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


  ;(displayln "test should be connected")
  #;(displayln (should-be-connected? (list `city `country `area `capital) (list `country `population);#t
                                 (table-schema cities) (table-schema countries)
                                 (list "Wrocław" "Poland"  293 #f) (list "Poland" 38)))

  #;(displayln (should-be-connected? (list `city `country `area `capital) (list `country `population);#t
                                 (table-schema cities) (table-schema countries)
                                 (list "Rennes"  "France"   50 #f) (list "France" 67)))

  #;(displayln (should-be-connected? (list `city `country `area `capital) (list `country `population);#f
                                 (table-schema cities) (table-schema countries)
                                 (list "Poznań"  "Poland"  262 #f) (list "Germany" 83)))


  ;(displayln "test merge-to-all")
  #;(print (merge-to-all (list "Poland" 38) (table-rows cities)
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

  ;(displayln "tesy remove-first:")
  ;(define last3 (remove-first-from-all (table-rows cities)))
  ;(displayln last3)
  ;(define last2 (remove-first-from-all last3))
  ;(displayln last2)

  ;(displayln "row-cmp testy")
  #;(displayln (row-cmp (list "Wrocław" "Poland"  293 #f) (list "Wrocław" "Poland"  293 #f)
                    (list "Poland" 38) (list "Poland" 38)
                    (remove-duplicated (table-schema cities) (table-schema countries))
                    (table-schema cities) (table-schema cities)
                    (table-schema countries) (table-schema countries)))

  #;(displayln (row-cmp (list "Wrocław" "Poland"  293 #f) (list "Wrocław" "Poland"  293 #f)
                    (list "Germany" 83) (list "Germany" 83)
                    (remove-duplicated (table-schema cities) (table-schema countries))
                    (table-schema cities) (table-schema cities)
                    (table-schema countries) (table-schema countries)))

  #;(displayln (row-cmp (list "Munich"  "Germany" 310 #f) (list "Munich"  "Germany" 310 #f)
                    (list "Poland" 38) (list "Poland" 38)
                    (remove-duplicated (table-schema cities) (table-schema countries))
                    (table-schema cities) (table-schema cities)
                    (table-schema countries) (table-schema countries)))


  (displayln "test natural-join")
  (print2 (table-natural-join countries cities))
  (print2 (table-natural-join cities countries))

  ;(displayln "testy replace:")
  #;(print (replace-rest-in-all-rows (table-rows countries)
                                     (list (list "aaa")
                                           (list "bbb")
                                           (list "ccc")
                                           (list "ddd"))))

  #;(displayln "testy czy-w-dobrej-kolejnosci")
  #;(displayln (czy-w-dobrej-kolejnosci (first (table-rows cities))
                                    (first (table-rows cities));#f
                                    (second (table-rows cities))
                                    (second (table-rows cities))
                                    (list `city)
                                    (table-schema cities)
                                    (table-schema cities)))

  #;(displayln (czy-w-dobrej-kolejnosci (first (table-rows cities))
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

  #;(displayln "test merge-rows")
  #;(displayln (merge-rows (list "Wrocław" "Poland"  293 #f)
                       (list "Poland" 38)
                       (table-schema cities)
                       (table-schema countries)
                       (remove-duplicated (table-schema cities) (table-schema countries)))))
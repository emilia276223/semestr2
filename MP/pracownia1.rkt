#lang racket

#;(provide (struct-out column-info)
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

(define countries
  (table
   (list (column-info 'country 'string)
         (column-info 'population 'number))
   (list (list "Poland" 38)
         (list "Germany" 83)
         (list "France" 67)
         (list "Spain" 47))))

(define (empty-table columns) (table columns '()))

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
      (error 'row-does-not-in-fit-the-table-function-table-insert)))

;testy table-insert (działa)

(table-insert (list "Toruń"  "Poland" 69 #t) cities)
;(table-insert (list "Toruń"  "Poland" 69 #t #t) cities)
;(table-insert (list "Toruń"  "Poland" 69 "true") cities)
(table-insert (list "Poland" 420) countries)
;(table-insert (list "Poland" "2137") countries)


; Projekcja

;to się może też późńiej przydać
(define (apply-to-all-rows f rows)
  (if (null? rows) null
      (cons (f (first rows))
            (apply-to-all-rows f (rest rows)))))

(define (remove-first-from-all rows)
  (apply-to-all-rows (λ (row) (rest row)) rows))

;test remove-first:
""
""
"tesy remove-first:"
(define last3 (remove-first-from-all (table-rows cities)))
last3
(define last2 (remove-first-from-all last3))
last2

(define (replace-rest-in-all-rows rows-original new-ends)
  (do-for-every-in-rows cons
                        (λ (row rest) (cons (first row) rest))
                        rows-original
                        new-ends
                        (λ (x) null)))

;testy replace end
""
""
"testy replace:"
(replace-rest-in-all-rows (table-rows countries)
                          (list (list "aaa")
                                (list "bbb")
                                (list "ccc")
                                (list "ddd")))


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

;table project testy:
""
""
""
"table project testy:"
"1:"
(table-project (list `area `city) cities)
"2:"
(table-project `(money) cities) ;no jak piszemu glupoty to czemu nie
"3:"
(table-project `(population money PKB) countries)

; Sortowanie

(define (table-sort cols tab)
  #t
  ;; uzupełnij
  )

; Selekcja

(define-struct and-f (l r))
(define-struct or-f (l r))
(define-struct not-f (e))
(define-struct eq-f (name val))
(define-struct eq2-f (name name2))
(define-struct lt-f (name val))

(define (table-select form tab)
  #t
  ;; uzupełnij
  )

; Zmiana nazwy

(define (table-rename col ncol tab)
  #t
  ;; uzupełnij
  )

; Złączenie kartezjańskie

(define (table-cross-join tab1 tab2)
  #t
  ;; uzupełnij
  )

; Złączenie

(define (table-natural-join tab1 tab2)
  #t
  ;; uzupełnij
  )

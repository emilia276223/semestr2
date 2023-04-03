#lang racket

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
        [else: (connecting (f (first rows) (first ys))
                           (do-for-every-in-rows connecting
                                                 f
                                                 (rest rows)
                                                 (rest ys)
                                                 null-f))]))

(define (check-types row ys)
  (do-for-every-in-rows (λ (row y) (if (row) y #f))
                        (λ (row y)
                          (cond
                            [(equal? 'string (column-info-type y))
                             (if (string? row)
                                         (check-types (rest row) (rest ys))
                                         #f)]
        [(equal? 'symbol (column-info-type (first ys))) (if (symbol? (first row))
                                         (check-types (rest row) (rest ys))
                                         #f)]
        [(equal? 'boolean (column-info-type (first ys))) (if (boolean? (first row))
                                         (check-types (rest row) (rest ys))
                                         #f)]
        [(equal? 'number (column-info-type (first ys))) (if (number? (first row))
                                         (check-types (rest row) (rest ys))
                                         #f)]
        [else #f])))
                        
  (cond [(null? ys) (null? row)]
        [(null? row) (null? ys)]
        [(equal? 'string (column-info-type (first ys))) (if (string? (first row))
                                         (check-types (rest row) (rest ys))
                                         #f)]
        [(equal? 'symbol (column-info-type (first ys))) (if (symbol? (first row))
                                         (check-types (rest row) (rest ys))
                                         #f)]
        [(equal? 'boolean (column-info-type (first ys))) (if (boolean? (first row))
                                         (check-types (rest row) (rest ys))
                                         #f)]
        [(equal? 'number (column-info-type (first ys))) (if (number? (first row))
                                         (check-types (rest row) (rest ys))
                                         #f)]
        [else #f]))

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

(define (replace-rest-in-all-rows rows-original new-ends)
  (apply-to-all-rows (λ (row)))

(define (table-project cols tab)
  (if (null? cols)
      null
      (let ([tab-of-rest (table-project cols
                                        (table (rest (table-schema tab))
                                               (remove-first-from-all-rows (table-rows tab))))])
        (if (member? (column-info-name (first (table-schema tab))) cols)
            (table (cons (first (table-schema tab)) (table-schema tab-of-rest))
                   (cons (first (table-rows tab)) (table-rows tab-of-rest)))))
  ;; uzupełnij
  ))

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

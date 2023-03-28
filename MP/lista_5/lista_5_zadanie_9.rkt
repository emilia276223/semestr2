#lang plait
;zrobione
;potrzebne

;formuly
( define-type Prop
   ( var [ v : String ])
   ( conj [ l : Prop ] [ r : Prop ]) ;i
   ( disj [ l : Prop ] [ r : Prop ]) ;v
   ( neg [ f : Prop ]) )

;czy spelniona
(define (eval slownik formula)
  (cond [(var? formula) (some-v (hash-ref slownik (var-v formula)))]
        [(conj? formula) (and (eval slownik (conj-r formula))
                              (eval slownik (conj-l formula)))]
        [(disj? formula) (or (eval slownik (disj-r formula))
                             (eval slownik (disj-l formula)))]
        [(neg? formula) (if (eval slownik (neg-f formula)) #f #t)]))

;wszystkie zmienne wolne:
(define (append-bez-powtorzen x l);dziala
  (cond [(empty? l) (list x)]
        [(equal? x (first l)) l]
        [else (cons (first l)
               (append-bez-powtorzen x (rest l)))]))

(define (append-list l1 l2);dziala
  (cond [(empty? l1) l2]
        [(empty? l2) l1]
        [else (append-list (rest l1) (append-bez-powtorzen (first l1) l2))]))

(define (all-vars formula l)
  (cond [(var? formula) (append-bez-powtorzen (var-v formula) l)]
        [(neg? formula) (all-vars (neg-f formula) l)]
        [(disj? formula) (append-list (all-vars (disj-r formula) l)
                           (all-vars (disj-l formula) l))]
        [else (append-list (all-vars (conj-r formula) l)
                           (all-vars (conj-l formula) l))]))

(define (free-vars formula)
  (all-vars formula (list)))

;dlugosc listy
(define (list-len l)
  (if (empty? l) 0
      (+ 1 (list-len (rest l)))))

;policzenie mozliwych wartosciowan k zmiennych
(define (dopisz-do-kazdej x l)
  (cond [(empty? l) (list)]
        [(empty? (rest l)) (list (cons x (first l)))]
        [else (cons (cons x (first l))
                    (dopisz-do-kazdej x (rest l)) )]))
  
(define (possible-vart k)
  (cond [(= k 0) (list)]
        [(= k 1) (list (list #t) (list #f))]
        [else (append (dopisz-do-kazdej #t
                                        (possible-vart (- k 1)))
                      (dopisz-do-kazdej #f
                                         (possible-vart (- k 1))))]))

;lista par wartosciowan
(define (pair-list xs ys)
  (cond [(empty? xs) (list)]
        [(empty? (rest xs)) (list (pair (first xs)
                                        (first ys)))]
        [else (cons (pair (first xs) (first ys))
                    (pair-list (rest xs) (rest ys)))]))

;lista slownikow
(define (lista-slownikow xs ys)
  (cond [(empty? ys) (list)]
        [(empty? (rest ys)) (list (hash (pair-list xs
                                                   (first ys))))]
        [else (cons (hash (pair-list xs (first ys)))
                    (lista-slownikow xs (rest ys)))]))

;czy spelnione wszystkie?
(define (czy-spelnione formula slowniki)
  (cond [(empty? slowniki) #t]
        [(empty? (rest slowniki)) (eval (first slowniki) formula)]
        [else (if (eval (first slowniki) formula)
                  (czy-spelnione formula (rest slowniki))
                  #f)]))

;tautologia?
(define (tautology? formula)
  (letrec ([wszystkie-zmienne (free-vars formula)]
           [wartosciowania (possible-vart (list-len wszystkie-zmienne))] 
           [slowniki (lista-slownikow wszystkie-zmienne
                                      wartosciowania)])
    (czy-spelnione formula slowniki)))

;testy:
(define f1 (var "a")) ; #f
(define f2 (disj (var "a") (neg (var "c")))) ; #f
(define f3 (conj (disj (var "a") (neg (var "c"))) (var "a"))) ; #f
(define t1 (disj (var "x") (neg (var "x")))) ; #t

(tautology? f1)
(tautology? f2)
(tautology? f3)
(tautology? t1)

(define example-taut
  (disj (disj (var "p") (var "q")) (neg (var "q")))); #t

(tautology? example-taut)

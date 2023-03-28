#lang plait

;potrzebne:
( define-type Prop
( var [ v : String ])
( conj [ l : Prop ] [ r : Prop ]) ;i
( disj [ l : Prop ] [ r : Prop ]) ;v
( neg [ f : Prop ]) )

;sprawdzenie czy formula spelniona
(define (eval slownik formula)
  (cond [(var? formula) (some-v (hash-ref slownik (var-v formula)))]
        [(conj? formula) (and (eval slownik (conj-r formula))
                              (eval slownik (conj-l formula)))]
        [(disj? formula) (or (eval slownik (disj-r formula))
                             (eval slownik (disj-l formula)))]
        [(neg? formula) (if (eval slownik (neg-f formula)) #f #t)]))


;testy:
(define s0 (hash (list)))
(define s1 (hash-set s0 "a" #t))
(define s2 (hash-set s1 "c" #t))

(define f1 (var "a"))
(define f2 (conj (var "a") (neg (var "c"))))

(eval s2 f1)
(eval s2 f2)
;dziala
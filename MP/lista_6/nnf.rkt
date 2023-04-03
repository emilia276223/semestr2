#lang plait

;definicja typu:
( define-type ( NNF 'v )
( nnf-lit [ polarity : Boolean ] [ var : 'v ])
( nnf-conj [ l : ( NNF 'v ) ] [ r : ( NNF 'v ) ]) ;i
( nnf-disj [ l : ( NNF 'v ) ] [ r : ( NNF 'v ) ]) ) ;lub

;negacja formuly:
(define (neg-nnf formula)
        (cond [(nnf-lit? formula) (if (equal? (nnf-lit-polarity formula) #t) 
                                      (nnf-lit #f (nnf-lit-var formula))
                                      (nnf-lit #t (nnf-lit-var formula)))]
              [(nnf-conj? formula) (nnf-disj (neg-nnf (nnf-conj-l formula))
                                             (neg-nnf (nnf-conj-r formula)))]
              [(nnf-disj? formula) (nnf-conj (neg-nnf (nnf-disj-l formula))
                                             (neg-nnf (nnf-disj-r formula)))]))

(define f1 (nnf-conj (nnf-lit #f "x") (nnf-lit #t "y")))
;f1
;(neg-nnf f1)

;sprawdzenie spelnienia fukcji

(define (eval-nnf s fi)
  (cond [(nnf-lit? fi)
         (if (equal? (nnf-lit-polarity fi) #t) 
             (s (nnf-lit-var fi))
             (not (s (nnf-lit-var fi))))]
        [(nnf-conj? fi) (and (eval-nnf s (nnf-conj-l fi))
                                  (eval-nnf s (nnf-conj-r fi)))]
        [(nnf-disj? fi) (or (eval-nnf s (nnf-disj-l fi))
                                  (eval-nnf s (nnf-disj-r fi)))]))

;ZADANIE 6

( define-type ( Formula 'v )
    ( var [ var : 'v ])
    ( neg [ f : ( Formula 'v ) ])
    ( conj [ l : ( Formula 'v ) ] [ r : ( Formula 'v ) ])
    ( disj [ l : ( Formula 'v ) ] [ r : ( Formula 'v ) ]) )

#;(define (to-nnf fi)
  (cond [(var? fi) fi]
        [(conj? fi) (conj (to-nnf (conj-l fi))
                          (to-nnf (conj-r fi)))]
        [(disj? fi) (disj (to-nnf (disj-l fi))
                          (to-nnf (disj-r fi)))]
        [(neg? fi)(cond [(var? (neg-f fi)) fi]
                        [(neg? (neg-f fi)) (to-nnf (neg-f (neg-f fi)))]
                        [(conj? (neg-f fi)) (disj (to-nnf (neg (conj-l (neg-f fi))))
                                                  (to-nnf (neg (conj-r (neg-f fi)))))]
                        [(disj? (neg-f fi)) (conj (to-nnf (neg (disj-l (neg-f fi))))
                                                  (to-nnf (neg (disj-r (neg-f fi)))))])]))


;wersja druga: (Formula 'a -> NNF 'a)

(define (to-nnf fi)
  (cond [(var? fi) (nnf-lit #t (var-var fi))]
        [(conj? fi) (nnf-conj (to-nnf (conj-l fi))
                          (to-nnf (conj-r fi)))]
        [(disj? fi) (nnf-disj (to-nnf (disj-l fi))
                          (to-nnf (disj-r fi)))]
        [(neg? fi)(cond
                    [(var? (neg-f fi))
                     (nnf-lit #f (var-var (neg-f fi)))]
                    [(neg? (neg-f fi))
                     (to-nnf (neg-f (neg-f fi)))]
                    [(conj? (neg-f fi))
                     (nnf-disj (to-nnf (neg (conj-l (neg-f fi))))
                               (to-nnf (neg (conj-r (neg-f fi)))))]
                    [(disj? (neg-f fi))
                     (nnf-conj (to-nnf (neg (disj-l (neg-f fi))))
                               (to-nnf (neg (disj-r (neg-f fi)))))])]))

;(define f1 (nnf-conj (nnf-lit #f "x") (nnf-lit #t "y")))
f1
(define f2 (neg (conj ( var "x") (var "y"))))
f2
(to-nnf f2)
"druga:"
(define f3 (neg (conj (neg ( var "x")) (neg (var "y")))))
f3
(to-nnf f3)
; ZADANIE 7

(define (eval-formula s fi)
  (cond [(var? fi) (s (var-var fi))]
        [(conj? fi) (and (eval-formula s (conj-l fi))
                         (eval-formula s (conj-r fi)))]
        [(disj? fi) (or (eval-formula s (disj-l fi))
                            (eval-formula s (disj-r fi)))]
        [(neg? fi) (not (eval-formula s (neg-f fi)))]))


#lang plait

(define-type Op-2
  (op-add) (op-mul) (op-sub) (op-div) (op-pow))

(define-type Op-1
  (op-neg) (op-sil))

(define-type Exp
  (exp-number [n : Number])
  (exp-op-2 [op-2 : Op-2] [e1 : Exp] [e2 : Exp])
  (exp-op-1 [op-1 : Op-1] [e : Exp]))

(define (parse-Op-2 s)
  (let ([sym (s-exp->symbol s)])
  (cond
    [(equal? sym '+) (op-add)]
    [(equal? sym '-) (op-sub)]
    [(equal? sym '*) (op-mul)]
    [(equal? sym '/) (op-div)]
    [(equal? sym '^) (op-pow)])))

(define (parse-Op-1 s)
  (let ([sym (s-exp->symbol s)])
  (cond
    [(equal? sym '-) (op-neg)]
    [(equal? sym '!) (op-sil)])))

(define (parse-Exp s)
  (cond
    [(s-exp-number? s) (exp-number (s-exp->number s))]
    [(s-exp-list? s)
     (let ([xs (s-exp->list s)])
       (if (empty? (rest (rest xs))) ;jesli unarny
           (exp-op-1 (parse-Op-1 (first  xs))
                     (parse-Exp (second xs)))
           (exp-op-2 (parse-Op-2 (first  xs))
                     (parse-Exp (second xs))
                     (parse-Exp (third  xs)))))]))

; ==============================================

(define (power a n)
  (cond [(= n 0) 1]
        [(< n 0) (error 'power "nie można brać ujemnej potęgi z liczby")]
        [else (* a (power a (- n 1)))]))

(define (silnia n)
  (cond [(= n 0) 1]
        [(< n 0) (error 'silnia "nie można brać silni z ujemnej liczby")]
        [else (* n (silnia (- n 1)))]))

(define (eval-op-2 op)
  (type-case Op-2 op
    [(op-add) +]
    [(op-sub) -]
    [(op-mul) *]
    [(op-div) /]
    [(op-pow) power]))

(define (eval-op-1 op)
  (type-case Op-1 op
    [(op-neg) (λ (x) (- 0 x))]
    [(op-sil) silnia]))

(define (eval e)
  (type-case Exp e
    [(exp-number n)    n]
    [(exp-op-2 op e1 e2)
     ((eval-op-2 op) (eval e1) (eval e2))]
    [(exp-op-1 op e)
     ((eval-op-1 op) (eval e))]))

; =============================================
(eval (parse-Exp `(* 2 (+ 2 2))))
(eval (parse-Exp `(^ 2 (+ 2 2))))
(eval (parse-Exp `(* 2 (- 2))))
(eval (parse-Exp `(! (+ 2 (* 1 3)))))
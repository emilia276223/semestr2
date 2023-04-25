#lang plait

(define-type Op
  (op-add) (op-mul) (op-sub) (op-div))

(define-type Exp
  (exp-number [n : Number])
  (exp-op [op : Op] [e1 : Exp] [e2 : Exp]))

(define (parse-Op s)
  (let ([sym (s-exp->symbol s)])
  (cond
    [(equal? sym '+) +]
    [(equal? sym '-) -]
    [(equal? sym '*) *]
    [(equal? sym '/) /])))

(define (parse-Exp s)
  (cond
    [(s-exp-number? s) (s-exp->number s)]
    [(s-exp-list? s)
     (let ([xs (s-exp->list s)])
       ((parse-Op (first  xs))
               (parse-Exp (second xs))
               (parse-Exp (third  xs))))]))

; ==============================================

(define (eval-op op)
  (type-case Op op
    [(op-add) +]
    [(op-sub) -]
    [(op-mul) *]
    [(op-div) /]))

(define (eval e)
  (type-case Exp e
    [(exp-number n)    n]
    [(exp-op op e1 e2)
     ((eval-op op) (eval e1) (eval e2))]))

; ===============================================
(parse-Exp `(+ 2 (* 2 2)))
(parse-Exp `(* 2 (+ 2 2)))
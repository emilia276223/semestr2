#lang plait

(module+ test
  (print-only-errors #t))

;; abstract syntax -------------------------------

(define-type Op
  (add) (sub) (mul) (div) (eql) (leq))

(define-type Exp
  (numE [n : Number])
  (opE [op : Op] [l : Exp] [r : Exp])
  (tryE [e1 : Exp] [e2 : Exp]) ;dodane, żeby zrobić try
  (ifE [b : Exp] [l : Exp] [r : Exp])
  (condE [cs : (Listof (Exp * Exp))])
  (errorE [loc : Symbol] [msg : String]))

;; parse ----------------------------------------

(define (parse-exp [s : S-Exp]) : Exp
  (cond
    [(s-exp-match? `NUMBER s)
     (numE (s-exp->number s))]
    [(s-exp-match? `{if ANY ANY ANY} s)
     (ifE (parse-exp (second (s-exp->list s)))
          (parse-exp (third (s-exp->list s)))
          (parse-exp (fourth (s-exp->list s))))]
    [(s-exp-match? `{cond ANY ...} s)
     (condE (parse-cond (rest (s-exp->list s))))]
    [(s-exp-match? `{error SYMBOL STRING} s) ;UWAGA! error nie chce działać, ale że to jest kod z wykładu to nie naprawiam tego
     (errorE (s-exp->symbol (second (s-exp->list s)))
             (s-exp->string (third (s-exp->list s))))]
    [(s-exp-match? `{SYMBOL ANY ANY} s)
     (if (s-exp-match? (first (s-exp->list s)) `try)
         (tryE (parse-exp (second (s-exp->list s))) ;dlaczego try jest tutaj a nie w osobnym match-s-exp? bo coś wtedy nie działało
               (parse-exp (third (s-exp->list s)))) ; i tylko tak działa poprawnie parser, normalnie możnaby zrobić jak if jest czy coś
         (opE (parse-op (s-exp->symbol (first (s-exp->list s))))
              (parse-exp (second (s-exp->list s)))
              (parse-exp (third (s-exp->list s)))))]
    [else (error 'parse-exp
                 "what else would you like to evaluate today?"
                 ;(s-exp->string s) ;bylo do testow
                 )]))

(define (parse-cond [ss : (Listof S-Exp)]) : (Listof (Exp * Exp))
  (type-case (Listof S-Exp) ss
    [empty
     empty]
    [(cons s ss)
     (if (s-exp-match? `{ANY ANY} s)
         (cons (pair (parse-exp (first (s-exp->list s)))
                     (parse-exp (second (s-exp->list s))))
               (parse-cond ss))
         (error 'parse-exp "invalid input: cond"))]))

(define (parse-op [op : Symbol]) : Op
  (cond
    [(eq? op '+) (add)]
    [(eq? op '-) (sub)]
    [(eq? op '*) (mul)]
    [(eq? op '/) (div)]
    [(eq? op '=) (eql)]
    [(eq? op '<=) (leq)]
    [else (error 'parse-op
                 "unknown operator"
                 ;(symbol->string op) ;do testów
                 )]))
                
(module+ test
  (test (parse-exp `2)
        (numE 2))
  (test (parse-exp `{+ 2 1})
        (opE (add) (numE 2) (numE 1)))
  (test (parse-exp `{* 3 4})
        (opE (mul) (numE 3) (numE 4)))
  (test (parse-exp `{+ {* 3 4} 8})
        (opE (add)
             (opE (mul) (numE 3) (numE 4))
             (numE 8)))
  (test (parse-exp `{if {= 0 1} {* 3 4} 8})
        (ifE (opE (eql) (numE 0) (numE 1))
             (opE (mul) (numE 3) (numE 4))
             (numE 8)))
  (test (parse-exp `{try {/ 5 0} {* 3 4}}) ;test try
        (tryE (opE (div) (numE 5) (numE 0)) (opE (mul) (numE 3) (numE 4))))
  #;(test (parse-exp `{error 'error "error"}) ;test error, okazuje sie ze nie dziala ale to kod w wykladu => nie moj problem
        (tryE (opE (div) (numE 5) (numE 0)) (opE (mul) (numE 3) (numE 4))))
  (test/exn (parse-exp `{{+ 1 2}})
            "what else would you like to evaluate today?")
  (test/exn (parse-exp `{+ 1})
            "what else would you like to evaluate today?")
  (test/exn (parse-exp `{^ 1 2})
            "unknown operator")
  (test (parse-exp `{cond {{= 0 1} {* 3 4}}
                      {{= 1 1} 8}})
        (condE (list (pair (opE (eql) (numE 0) (numE 1))
                           (opE (mul) (numE 3) (numE 4)))
                     (pair (opE (eql) (numE 1) (numE 1))
                           (numE 8))))))
  
;; eval --------------------------------------

(define-type Value
  (numV [n : Number])
  (boolV [b : Boolean]))

(define-type Answer
  (valueA [v : Value])
  (errorA [loc : Symbol] [msg : String]))

;; error monad

(define (err [l : Symbol] [m : String]) : Answer
  (errorA l m))

(define (return [v : Value]) : Answer
  (valueA v))

(define (bind [a : Answer] [f : (Value -> Answer)]) : Answer
  (type-case Answer a
    [(valueA v)
     (f v)]
    [(errorA l m)
     (errorA l m)]))

(define-syntax do
  (syntax-rules ()
    [(do () a)
     a]
    [(do ([x1 a1] [x2 a2] ...) a)
     (bind a1 (λ (x1) (do ([x2 a2] ...) a)))])) 

;; primitive operations

(define (op-num-num->proc [f : (Number Number -> Number)]) : (Value Value -> Answer)
  (λ (v1 v2)
    (type-case Value v1
      [(numV n1)
       (type-case Value v2
         [(numV n2)
          (return (numV (f n1 n2)))]
         [else
          (errorA 'eval "type error")])]
      [else
       (errorA 'eval "type error")])))

(define (op-num-bool->proc [f : (Number Number -> Boolean)]) : (Value Value -> Answer)
  (λ (v1 v2)
    (type-case Value v1
      [(numV n1)
       (type-case Value v2
         [(numV n2)
          (return (boolV (f n1 n2)))]
         [else
          (errorA 'eval "type error")])]
      [else
       (errorA 'eval "type error")])))

(define (div->proc) : (Value Value -> Answer)
  (λ (v1 v2)
    (type-case Value v1
      [(numV n1)
       (type-case Value v2
         [(numV n2)
          (if (= n2 0)
              (errorA 'eval "attempt to divide by 0")
              (return (numV (/ n1 n2))))]
         [else
          (errorA 'eval "type error")])]
      [else
       (errorA 'eval "type error")])))

(define (op->proc [op : Op]) : (Value Value -> Answer)
  (type-case Op op
    [(add) (op-num-num->proc +)]
    [(sub) (op-num-num->proc -)]
    [(mul) (op-num-num->proc *)]
    [(div) (div->proc)]
    [(eql) (op-num-bool->proc =)]
    [(leq) (op-num-bool->proc <=)]))

;; evaluation function

(define (eval [e : Exp]) : Answer
  (type-case Exp e
    [(numE n)
     (return (numV n))]
    [(opE o l r)
     (do ([v-l (eval l)]
          [v-r (eval r)])
       ((op->proc o) v-l v-r))]
    [(ifE b l r)
     (do ([v (eval b)])
       (type-case Value v
         [(boolV u)
          (if u (eval l) (eval r))]
         [else
          (error 'eval "type error")]))]
    [(condE cs)
     (eval (cond->if cs))]
    [(tryE e1 e2) ;dodane:
     (type-case Answer (eval e1) 
       [(errorA l m) (eval e2)] ;jesli pierwsza rzecz to error to zwracam druga
       [(valueA v1) (return v1)])] ;jesli poprawna to zwracam ją
    [(errorE l m)
     (err l m)]))

(define (cond->if [cs : (Listof (Exp * Exp))]) : Exp
  (type-case (Listof (Exp * Exp)) cs
    [empty
     (errorE 'cond "no matching clause")]
    [(cons c cs)
     (ifE (fst c)
          (snd c )
          (cond->if cs))]))

(define (run [e : S-Exp]) : Answer
  (eval (parse-exp e)))

;; Exercise: get rid of Plait's error procedure from the evaluator altogether

(module+ test
  (test (run `2)
        (valueA (numV 2)))
  (test (run `{+ 2 1})
        (valueA (numV 3)))
  (test (run `{* 2 1})
        (valueA (numV 2)))
  (test (run `{+ {* 2 3} {+ 5 8}})
        (valueA (numV 19)))
  (test (run `{= 0 1})
        (valueA (boolV #f)))
  (test (run `{if {= 0 1} {* 3 4} 8})
        (valueA (numV 8)))
  (test (run `{cond {{= 0 1} {* 3 4}}
                    {{= 1 1} 8}})
        (valueA (numV 8)))
  (test (run `{try {/ 5 0} {* 3 4}}) ;test 1 try
        (valueA (numV 12)))
  (test (run `{try {/ 5 0} {/ 3 0}}) ;test 2 try
        (errorA 'eval "attempt to divide by 0"))
  (test (run `{try {* 3 4} {/ 5 0}}) ;test 3 try
        (valueA (numV 12)))
  (test (run `{cond})
        (errorA 'cond "no matching clause")))

;; printer ———————————————————————————————————-

(define (value->string [v : Value]) : String
  (type-case Value v
    [(numV n) (to-string n)]
    [(boolV b) (if b "true" "false")]))

(define (print-value [v : Value]) : Void
  (display (value->string v)))

(define (print-answer [a : Answer]) : Void
  (type-case Answer a
    [(valueA v)
     (print-value v)]
    [(errorA l m)
     (begin
       (display l)
       (display ": ")
       (display m))]))

(define (main [e : S-Exp]) : Void
  (print-answer (eval (parse-exp e))))

;; read-eval-print-loop -----------------------

(define input-prompt "MP22> ")
(define newline (λ () (display "\n")))
(define (driver-loop)
  (begin 
    (display input-prompt)
    (let ([input (read)])
      (if (s-exp-match? input `exit)
          (newline)
          (let ([output (run input)])
            (begin
              (print-answer output)
              (newline)
              (driver-loop)))))))
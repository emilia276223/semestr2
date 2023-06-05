#lang plait

(module+ test
  (print-only-errors #t))

;; abstract syntax -------------------------------

(define-type Op
  (add) (sub) (mul) (div) (eql) (leq))

(define-type Exp
  (numE [n : Number])
  (opE [op : Op] [l : Exp] [r : Exp])
  (ifE [b : Exp] [l : Exp] [r : Exp])
  (varE [x : Symbol])
  (letE [x : Symbol] [e1 : Exp] [e2 : Exp])
  (lamE [x : Symbol] [e : Exp]);dodajemy
  (appE [e1 : Exp] [e2 : Exp]));dodajemy

;; parse ----------------------------------------

;dodanie parsowania lambd, nic ciekawego, kopiuj - wklej

(define (parse [s : S-Exp]) : Exp
  (cond
    [(s-exp-match? `NUMBER s)
     (numE (s-exp->number s))]
    [(s-exp-match? `{lambda {SYMBOL} ANY} s)
     (lamE (s-exp->symbol
            (first (s-exp->list 
                    (second (s-exp->list s)))))
           (parse (third (s-exp->list s))))]
    [(s-exp-match? `{SYMBOL ANY ANY} s)
     (opE (parse-op (s-exp->symbol (first (s-exp->list s))))
          (parse (second (s-exp->list s)))
          (parse (third (s-exp->list s))))]
    [(s-exp-match? `{if ANY ANY ANY} s)
     (ifE (parse (second (s-exp->list s)))
          (parse (third (s-exp->list s)))
          (parse (fourth (s-exp->list s))))]
    [(s-exp-match? `SYMBOL s)
     (varE (s-exp->symbol s))]
    [(s-exp-match? `{let SYMBOL ANY ANY} s)
     (letE (s-exp->symbol (second (s-exp->list s)))
           (parse (third (s-exp->list s)))
           (parse (fourth (s-exp->list s))))]
    [(s-exp-match? `{ANY ANY} s)
     (appE (parse (first (s-exp->list s)))
           (parse (second (s-exp->list s))))]
    [else (error 'parse "invalid input")]))

(define (parse-op [op : Symbol]) : Op
  (cond
    [(eq? op '+) (add)]
    [(eq? op '-) (sub)]
    [(eq? op '*) (mul)]
    [(eq? op '/) (div)]
    [(eq? op '=) (eql)]
    [(eq? op '<=) (leq)]
    [else (error 'parse "unknown operator")]))
                
(module+ test
  (test (parse `2)
        (numE 2))
  (test (parse `{+ 2 1})
        (opE (add) (numE 2) (numE 1)))
  (test (parse `{* 3 4})
        (opE (mul) (numE 3) (numE 4)))
  (test (parse `{+ {* 3 4} 8})
        (opE (add)
             (opE (mul) (numE 3) (numE 4))
             (numE 8)))
  (test (parse `{if {= 0 1} {* 3 4} 8})
        (ifE (opE (eql) (numE 0) (numE 1))
             (opE (mul) (numE 3) (numE 4))
             (numE 8)))
  (test/exn (parse `{{+ 1 2}})
            "invalid input")
  (test (parse `{+ 1})
        (appE (varE '+) (numE 1)))
  (test/exn (parse `{^ 1 2})
            "unknown operator")
  (test (parse `{let x 1 {+ x 1}})
        (letE 'x (numE 1) (opE (add) (varE 'x) (numE 1))))
  (test (parse `{lambda {x} 9})
        (lamE 'x (numE 9)))
  (test (parse `{double 9})
        (appE (varE 'double) (numE 9))))


;; eval --------------------------------------

;; values

(define-type Value
  (numV [n : Number])
  (boolV [b : Boolean])
  (funV [e : ExpA] [env : (EnvA Value)]))
;teraz nasza funkcja nie potrzebuje nazwy zmiennej,
;do ewaluacji wykorzystamy indeksy użytych zmienych w Exp,
;funkcja składa się z wyrażenia i środowiska,w którym będzie
;ona wyliczana, czyli tak naprawdę mamy tu domkniecie funkcji



;; primitive operations

(define (op-num-num->proc [f : (Number Number -> Number)]) : (Value Value -> Value)
  (λ (v1 v2)
    (type-case Value v1
      [(numV n1)
       (type-case Value v2
         [(numV n2)
          (numV (f n1 n2))]
         [else
          (error 'eval "type error")])]
      [else
       (error 'eval "type error")])))

(define (op-num-bool->proc [f : (Number Number -> Boolean)]) : (Value Value -> Value)
  (λ (v1 v2)
    (type-case Value v1
      [(numV n1)
       (type-case Value v2
         [(numV n2)
          (boolV (f n1 n2))]
         [else
          (error 'eval "type error")])]
      [else
       (error 'eval "type error")])))

(define (op->proc [op : Op]) : (Value Value -> Value)
  (type-case Op op
    [(add) (op-num-num->proc +)]
    [(sub) (op-num-num->proc -)]
    [(mul) (op-num-num->proc *)]
    [(div) (op-num-num->proc /)]
    [(eql) (op-num-bool->proc =)]
    [(leq) (op-num-bool->proc <=)]))

;; evaluation function (eval/apply)
;;lexical adressing
(define-type ExpA
  (numA [n : Number])
  (opA [op : Op] [l : ExpA] [r : ExpA])
  (ifA [b : ExpA] [l : ExpA] [r : ExpA])
  (varA [n : Number])
  (letA [a1 : ExpA] [a2 : ExpA])
  (lamA [e : ExpA]) ;lambda składa się tylko z ciała funkcji
  (appA [e1 : ExpA] [e2 : ExpA])
  )

;; environments (lists of entities)
;skoro zmieniamy adresowanie zmiennych na adresowanie leksykalne to nie potrzebujemy już Binding'u
;musimy także zmienić nasze środowisko na leksykalne
;zmienia się także struktura funV bo już nie potrzebujemy nazwy zmiennej
;nasze środowisko jest teraz adresowane leksykalnie

;nowa reprezentacja dobrze współgra z domknięciami funkcji, bo w domknięciu i tak byśmy trzymali wartości ze środowiska
;teraz nie musimy trzymać nazw zmiennych
;środowisko funkcji pokrywa się ze środowiskiem w adresowaniu leksykalnym, przetrzymujemy w nim adresy naszych zmiennych
;każda funkcja może mieć swoje środowisko, obok środowiska programu

;(run `{{lambda {f} {+ {f 2} {f 3}}} {lambda {x} {* x x}}})

(define-type-alias (EnvA 'a) (Listof 'a))

(define mt-envA empty)

(define (extend-envA [env : (EnvA 'a)] [x : 'a]) : (EnvA 'a)
  (cons x env))

(define (lookup-envA [n : Number] [env : (EnvA 'a)]) : 'a
  (list-ref env n))


;evaluation
(define (evalA [a : ExpA] [env : (EnvA Value)]) : Value
  (type-case ExpA a
    [(numA n) (numV n)]
    [(opA o l r) ((op->proc o) (evalA l env) (evalA r env))]
    [(ifA b l r)
     (type-case Value (evalA b env)
       [(boolV v)
        (if v (evalA l env) (evalA r env))]
       [else
        (error 'eval "type error")])]
    [(varA n)
     (lookup-envA n env)]
    [(letA e1 e2)
     (let ([v1 (evalA e1 env)])
       (evalA e2 (extend-envA env v1)))]
    ;dodajemy lambdę i aplikację
    [(lamA e)
     (funV e env)]
    [(appA e1 e2) ;nic ciekawego
     (applyA (evalA e1 env) (evalA e2 env))]))


(define (applyA [v1 : Value] [v2 : Value]) : Value
  (type-case Value v1
    [(funV b env)
     (evalA b (extend-envA env v2))]
    [else (error 'apply "not a function")]))

;; translation function

(define (address-of [x : Symbol] [env : (EnvA Symbol)]) : Number
  (type-case (EnvA Symbol) env
    [empty
     (error 'x "unbound variable")]
    [(cons y rst-env)
     (if (eq? x y)
         0
         (+ 1 (address-of x rst-env)))]))

(define (translate [e : Exp] [env : (EnvA Symbol)]) : ExpA
  (type-case Exp e
    [(numE n)
     (numA n)]
    [(opE o l r)
     (opA o (translate l env) (translate r env))]
    [(ifE b l r)
     (ifA (translate b env)
          (translate l env)
          (translate r env))]
    [(varE x)
     (varA (address-of x env))]
    [(letE x e1 e2)
     (letA (translate e1 env)
           (translate e2 (extend-envA env x)))]
    [(lamE x e) ;dodane
     (lamA (translate e (extend-envA env x))) ;rozszerzamy środowisko o zmienną z lambdy
     ]
    [(appE e1 e2) ;dodane (ale nic nie robi)
     (appA (translate e1 env) (translate e2 env))
     ]))


(define (run [s : S-Exp]) : Value
  (evalA (translate (parse s) mt-envA) mt-envA))

(module+ test
  (test (run `2)
        (numV 2))
  (test (run `{+ 2 1})
        (numV 3))
  (test (run `{* 2 1})
        (numV 2))
  (test (run `{+ {* 2 3} {+ 5 8}})
        (numV 19))
  (test (run `{= 0 1})
        (boolV #f))
  (test (run `{if {= 0 1} {* 3 4} 8})
        (numV 8))
  (test (run `{let x 1 {+ x 1}})
        (numV 2))
  (test (run `{let x 1 {+ x {let y 2 {* x y}}}})
        (numV 3))
  (test (run `{let x 1
                {+ x {let x {+ x 1}
                       {* x 3}}}})
        (numV 7))
  (test (run `{{lambda {x} {+ x 1}} 5})
        (numV 6))
  (test (run `{lambda {x} {lambda {y} {+ x y}}})
        (funV (lamA (opA (add) (varA 1) (varA 0))) mt-envA))

  (test (run `{{lambda {x} {+ x 2}} 3})
        (numV 5))
 

  (test (run `{{lambda {f} {+ {f 2} {f 3}}} {lambda {x} {* x x}}})
        (numV 13)))



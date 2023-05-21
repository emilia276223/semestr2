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
  (lamE [x : Symbol] [e : Exp])
  (appE [e1 : Exp] [e2 : Exp]))

;; parse ----------------------------------------

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
  (funV [f : (Value -> Value)]))

(define-type Binding
  (bind [name : Symbol]
        [val : Value]))

;; environments

(define-type-alias Env (Listof Binding))

(define mt-env empty)
(define (extend-env [env : Env] [x : Symbol] [v : Value]) : Env
  (cons (bind x v) env))
(define (lookup-env [n : Symbol] [env : Env]) : Value
  (type-case (Listof Binding) env
    [empty (error 'lookup "unbound variable")]
    [(cons b rst-env) (cond
                        [(eq? n (bind-name b))
                         (bind-val b)]
                        [else (lookup-env n rst-env)])]))

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

(define (eval [e : Exp] [env : Env]) : Value
  (type-case Exp e
    [(numE n) (numV n)]
    [(opE o l r) ((op->proc o) (eval l env) (eval r env))]
    [(ifE b l r)
     (type-case Value (eval b env)
       [(boolV v)
        (if v (eval l env) (eval r env))]
       [else
        (error 'eval "type error")])]
    [(varE x)
     (lookup-env x env)]
    [(letE x e1 e2)
     (let ([v1 (eval e1 env)])
       (eval e2 (extend-env env x v1)))]
    [(lamE x b)
     (funV (λ (v) (eval b (extend-env env x v))))]
    [(appE e1 e2)
     (apply (eval e1 env) (eval e2 env))]))

(define (apply [v1 : Value] [v2 : Value]) : Value
  (type-case Value v1
    [(funV f) (f v2)]
    [else (error 'apply "type error")]))


(define (run [e : S-Exp]) : Value
  (eval (parse e) mt-env))


;; set of free variables <- dodane


(define-type-alias (Setof 'a) (Listof 'a))

(define (emptyS) : (Setof 'a)
  empty)

(define (singletonS [x : 'a]) : (Setof 'a)
  (list x)) 

(define (inS [x : 'a] [s : (Setof 'a)]) : Boolean
  (member x s))

(define (unionS [s1 : (Setof 'a)] [s2 : (Setof 'a)]) : (Setof 'a)
  (append (filter (λ (x) (not (member x s2))) s1) s2)) 

(define (removeS [x : 'a] [s : (Setof 'a)]): (Setof 'a)
  (filter (λ (y) (not (eq? x y))) s))

(define (subsetS [s1 : (Setof 'a)] [s2 : (Setof 'a)]) : Boolean
  (empty? (filter (λ (x) (not (member x s2))) s1)))

(define (equalS [s1 : (Setof 'a)] [s2 : (Setof 'a)]) : Boolean
  (and (subsetS s1 s2) (subsetS s2 s1)))
  
(define (fromList [xs : (Listof 'a)]) : (Setof 'a)
  (foldr (λ (x s) (unionS (singletonS x) s))
         (emptyS)
         xs))

(define (fv [e : Exp]) : (Setof Symbol)
  (type-case Exp e
    [(numE n) (emptyS)]
    [(opE o l r) (unionS (fv l) (fv r))]
    [(ifE b l r)
     (unionS (fv b) (unionS (fv l) (fv r)))]
    [(varE x)
     (singletonS x)]
    [(letE x e1 e2)
     (unionS (fv e1)
             (removeS x (fv e2)))]
    [(lamE x b)
     (removeS x (fv b))]
    [(appE e1 e2)
     (unionS (fv e1)
             (fv e2))]))

(define (free-variables e)
  (fv (parse e)))

(module+ test
  (test (equalS (free-variables `2)
                (emptyS))
        #t)
  (test (equalS (free-variables `{+ 2 1})
                (emptyS))
        #t)
  (test (equalS (free-variables `{+ {* 2 3} {+ 5 8}})
                (emptyS))
        #t)
  (test (equalS (free-variables `{if {= 0 1} {* 3 4} 8})
                (emptyS))
        #t)
  (test (equalS (free-variables `{let x 1 {+ x 1}})
                (emptyS))
        #t)
  (test (equalS (free-variables `{let x 1 {+ x {let y 2 {* x y}}}})
                (emptyS))
        #t)
  (test (equalS (free-variables `{let x 1
                {+ x {let x {+ x 1}
                       {* x 3}}}})
                (emptyS))
        #t)
  (test (equalS (free-variables `{{lambda {x} {+ x 1}} 5})
                (emptyS))
        #t)
  (test (equalS (free-variables `x)
                (fromList (list 'x)))
        #t)
  (test (equalS (free-variables `{+ x y})
                (fromList (list 'x 'y)))
        #t)
  (test (equalS (free-variables `{+ {* x 3} {+ x x2}})
                (fromList (list 'x 'x2)))
        #t)
  (test (equalS (free-variables `{if {= x 1} {* 3 x} y})
                (fromList (list 'x 'y)))
        #t)
  (test (equalS (free-variables `{let x x {+ x 1}})
                (fromList (list 'x)))
        #t)
  (test (equalS (free-variables `{let x 1 {+ x {let y z {+ t {* x y}}}}})
                (fromList (list 'z 't)))
        #t)
  (test (equalS (free-variables `{let x 1
                                   {+ x {let x {+ y 1}
                                          {* x 3}}}})
                (fromList (list 'y)))
        #t)
  (test (equalS (free-variables `{{lambda {x} {+ x 1}} y})
                (fromList (list 'y)))
        #t)
  (test (equalS (free-variables `{{lambda {x} {+ x y}} 2})
                (fromList (list 'y)))
        #t))


;; koniec dodanych rzeczy



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
        (numV 6)))

;; printer ———————————————————————————————————-

(define (value->string [v : Value]) : String
  (type-case Value v
    [(numV n) (to-string n)]
    [(boolV b) (if b "true" "false")]
    [(funV _) "#<procedure>"]))

(define (print-value [v : Value]) : Void
  (display (value->string v)))

(define (main [e : S-Exp]) : Void
  (print-value (eval (parse e) mt-env)))
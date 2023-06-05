#lang plait

(module+ test
  (print-only-errors #t))

;; abstract syntax -------------------------------

(define-type Op
  (add) (sub) (mul) (div) (eql) (leq))

(define-type Exp
  (numE [n : Number])
  (ifE [b : Exp] [l : Exp] [r : Exp])
  (varE [x : Symbol])
  (letE [x : Symbol] [e1 : Exp] [e2 : Exp])
  (lamE [x : Symbol] [e : Exp])
  (appE [e1 : Exp] [e2 : Exp])
  (letrecE [x : Symbol] [e1 : Exp] [e2 : Exp])
  (letmutrecE [x1 : Symbol] [e1 : Exp] [x2 : Symbol] [e2 : Exp] [e : Exp]) ;dodajemy letrec'a z podwójną rekurenją
  )

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
    [(s-exp-match? `{letrec SYMBOL ANY ANY} s)
     (letrecE (s-exp->symbol (second (s-exp->list s)))
              (parse (third (s-exp->list s)))
              (parse (fourth (s-exp->list s))))]
    [(s-exp-match? `{letmutrec {SYMBOL ANY} {SYMBOL ANY} ANY} s)
     (letmutrecE
                ;x1 e1
                (s-exp->symbol
                  (first (s-exp->list
                          (second (s-exp->list s)))))
                 (parse (second (s-exp->list
                          (second (s-exp->list s)))))
                 ;x2 e2
                 (s-exp->symbol
                  (first (s-exp->list
                          (third (s-exp->list s)))))
                 (parse (second (s-exp->list
                          (third (s-exp->list s)))))
                 ;e
                 (parse (fourth (s-exp->list s))))]
    [(s-exp-match? `{SYMBOL ANY ANY} s)
     (appE (appE (varE (parse-op (s-exp->symbol (first (s-exp->list s)))))
                 (parse (second (s-exp->list s))))
           (parse (third (s-exp->list s))))]
    [(s-exp-match? `{ANY ANY} s)
     (appE (parse (first (s-exp->list s)))
           (parse (second (s-exp->list s))))]
    [else (error 'parse "invalid input")]))

(define prim-ops '(+ - * / = <=))

(define (parse-op [op : Symbol]) : Symbol
  (if (member op prim-ops)
      op 
      (error 'parse "unknown operator")))

(module+ test
  (test (parse `2)
        (numE 2))
    (test (parse `2)
        (numE 2))
  (test (parse `{+ 2 1})
        (appE (appE (varE '+) (numE 2)) (numE 1)))
  (test (parse `{* 3 4})
        (appE (appE (varE '*) (numE 3)) (numE 4)))
  (test/exn (parse `{{+ 1 2}})
            "invalid input")
  (test (parse `{+ 1})
        (appE (varE '+) (numE 1)))
  (test/exn (parse `{^ 1 2})
            "unknown operator")
  (test (parse `{lambda {x} 9})
        (lamE 'x (numE 9)))
  (test (parse `{double 9})
        (appE (varE 'double) (numE 9))))

;; eval --------------------------------------

;; values

(define-type Value
  (numV [n : Number])
  (boolV [b : Boolean])
  (funV [x : Symbol] [e : Exp] [env : Env])
  (primopV [f : (Value -> Value)]))

;; environments

;na stercie możemy trzymać wartość niezdefiniowaną albo po prostu wartość
(define-type Storable
  (valS [v : Value])
  (undefS))

;teraz w środowisku przetrzymujemy nazwę zmiennej i wskaźnik na jej zawartość w pamięci
(define-type Binding
  (bind [name : Symbol]
        [ref : (Boxof Storable)]))

(define-type-alias Env (Listof Binding))

(define mt-env empty)

;środowisko można rozszerzać na dwa sposoby
;rozbuduwujemy środowisko o wskaźnik do pamięci
(define (extend-env-undef [env : Env] [x : Symbol]) : Env
  (cons (bind x (box (undefS))) env))

;rozbuduwujemy środowsiko o wartość
(define (extend-env [env : Env] [x : Symbol] [v : Value]) : Env
  (cons (bind x (box (valS v))) env))

(define (find-var [env : Env] [x : Symbol]) : (Boxof Storable)
  (type-case (Listof Binding) env
    [empty (error 'lookup "unbound variable")]
    [(cons b rst-env) (cond
                        [(eq? x (bind-name b))
                         (bind-ref b)]
                        [else
                         (find-var rst-env x)])]))
  
(define (lookup-env [x : Symbol] [env : Env]) : Value
  (type-case Storable (unbox (find-var env x))
    [(valS v) v] ;wyciągamy zawartość box'a
    [(undefS) (error 'lookup-env "undefined variable")]))

;podmiana zwartości wskaźnika
(define (update-env! [env : Env] [x : Symbol] [v : Value]) : Void
  (set-box! (find-var env x) (valS v)))


;; primitive operations

(define (op-num-num->value [f : (Number Number -> Number)]) : Value 
  (primopV
   (λ (v1)
     (type-case Value v1
       [(numV n1)
        (primopV
         (λ (v2)
           (type-case Value v2
             [(numV n2)
              (numV (f n1 n2))]
             [else
              (error 'eval "type error")])))]
       [else
        (error 'eval "type error")]))))

(define (op-num-bool->value [f : (Number Number -> Boolean)]) : Value 
  (primopV
   (λ (v1)
     (type-case Value v1
       [(numV n1)
        (primopV
         (λ (v2)
           (type-case Value v2
             [(numV n2)
              (boolV (f n1 n2))]
             [else
              (error 'eval "type error")])))]
       [else
        (error 'eval "type error")]))))

(define init-env 
  (foldr (λ (b env) (extend-env env (fst b) (snd b)))
         mt-env 
         (list (pair '+ (op-num-num->value +))
               (pair '- (op-num-num->value -))
               (pair '* (op-num-num->value *))
               (pair '/ (op-num-num->value /))
               (pair '= (op-num-bool->value =))
               (pair '<= (op-num-bool->value <=)))))

;; evaluation function (eval/apply)

(define (eval [e : Exp] [env : Env]) : Value
  (type-case Exp e
    [(numE n) (numV n)]
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
     (funV x b env)]
    [(appE e1 e2)
     (apply (eval e1 env) (eval e2 env))]
    [(letrecE x e1 e2)
     ;rozbudowuję środowisko letrec'a o wartość niezdefiniowaną
     (let* ([new-env (extend-env-undef env x)]
            [v1 (eval e1 new-env)]) ;liczymy wartość w nowym środowisku
       (begin (update-env! new-env x v1)  ;chcemy żeby x nie pokazywał na undef tylko na v1
              (eval e2 new-env)))]
    ;ewaluacja letmutrecE
    [(letmutrecE x1 e1 x2 e2 e)
     ;robimy nowe środowisko z niedefiniowanymi wartościami x1 i x2
     (let* ([new-env (extend-env-undef (extend-env-undef env x1) x2)]
            [v1 (eval e1 new-env)] ;obliczamy wartość x1 w nowym środowisku
            [v2 (eval e2 new-env)] ;analogicznie dla x2
            )
       (begin
         (update-env! new-env x1 v1);podmieniamy wartość x1 w naszym środowisku
         (update-env! new-env x2 v2)
         (eval e new-env) ;na samym końcu liczymy właściwe wyrażenie
         ))]))

;żeby zrobić to na dowolną liczbę wiązań wystarczy zmienić składnię, parser i eval
;składnia wyglądałaby w ten sposób, że przyjmowalibyśmy po prostu listę [{symbol exp} ...] i samo wyrażenie do obliczenia w ciele let'a
;w parserze w ramach argumentu przyjmowalibyśmy listę [{symbol exp} ...]
;natomiast w ewaluatorze trzeba by było zrobić po prostu map po liście par wiązań (część z let*) to samo dla begin'a

(define (apply v1 v2)
  (type-case Value v1
    [(funV x b env)
     (eval b (extend-env env x v2))]
    [(primopV f)
     (f v2)]
    [else (error 'apply "not a function")]))

(define (run [e : S-Exp]) : Value
  (eval (parse e) init-env))

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
  (test (run `{letrec fact {lambda {n}
                             {if {= n 0}
                                 1
                                 {* n {fact {- n 1}}}}}
                {fact 5}})
        (numV 120))
  (test (run `{ let true {= 0 0}
                 { let false {= 0 1}
                    { letmutrec
                      { even { lambda { n } { if {= n 0} true { odd {- n 1}}}}}
                      { odd { lambda { n } { if {= n 0} false { even {- n 1}}}}}
                      { even 6}}}})
        (boolV #t)))


;; printer ———————————————————————————————————-

(define (value->string [v : Value]) : String
  (type-case Value v
    [(numV n) (to-string n)]
    [(boolV b) (if b "true" "false")]
    [(funV x e env) "#<procedure>"]
    [(primopV f) "#<primop>"]))

(define (print-value [v : Value]) : Void
  (display (value->string v)))

(define (main [e : S-Exp]) : Void
  (print-value (eval (parse e) mt-env)))

#lang plait

(module+ test
  (print-only-errors #t))

;; abstract syntax -------------------------------

(define-type Op
  (add)
  (sub)
  (mul)
  (div))

(define-type Exp
  (numE [n : Number])
  (opE [op : Op] [es : (Listof Exp)]))

;; parse ----------------------------------------

(define (parse-all es)
  (if (empty? es) empty
      (cons (parse (first es)) (parse-all (rest es)))))

(define (parse [s : S-Exp]) : Exp
  (cond
    [(s-exp-match? `NUMBER s)
     (numE (s-exp->number s))]
    [(s-exp-match? `{SYMBOL ANY ...} s)
     (let ([sx (s-exp->list s)])(opE (parse-op (s-exp->symbol (first sx)))
          (parse-all (rest sx))))]
    [else (error 'parse "invalid input")]))

(define (parse-op [op : Symbol]) : Op
  (cond
    [(eq? op '+) (add)]
    [(eq? op '-) (sub)]
    [(eq? op '*) (mul)]
    [(eq? op '/) (div)]
    [else (error 'parse "unknown operator")]))
                 
(module+ test
  (test (parse `2)
        (numE 2))
  (test (parse `{+ 2 1})
        (opE (add) (list (numE 2) (numE 1))))
  (test (parse `{* 3 4})
        (opE (mul) (list (numE 3) (numE 4))))
  (test (parse `{+ {* 3 4} 8})
        (opE (add)
             (list (opE (mul) (list (numE 3) (numE 4)))
             (numE 8))))
  (test/exn (parse `{{+ 1 2}})
            "invalid input")
  (test (parse `{+ 1})
            (opE (add) (list (numE 1))))
  (test (parse `{+})
            (opE (add) (list )))
  (test/exn (parse `{^ 1 2})
            "unknown operator"))
  
;; eval --------------------------------------

(define-type-alias Value Number)

(define (neutral-value op)
  (type-case Op op
    [(add) 0]
    [(sub) 0]
    [(mul) 1]
    [(div) 1]))

(define (op->proc [op : Op]) : (Value Value -> Value)
  (type-case Op op
    [(add) +]
    [(sub) -]
    [(mul) *]
    [(div) /]))

(define (f-for-rest [op : Op]) : Op
  (type-case Op op
    [(add) (add)]
    [(sub) (add)]
    [(mul) (mul)]
    [(div) (mul)]))

(define (eval-all f es)
  (if (empty? es)
      (neutral-value f)
      ((op->proc f) (eval (first es)) (eval-all (f-for-rest f) (rest es))))) 

(define (eval [e : Exp]) : Value
  (type-case Exp e
    [(numE n) n]
    [(opE o es) (eval-all o es)]))

(define (run [e : S-Exp]) : Value
  (eval (parse e)))

(module+ test
  (test (run `2)
        2)
  (test (run `{+ 2 1})
        3)
  (test (run `{* 2 1})
        2)
  (test (run `{+ {* 2 3} {+ 5 8}})
        19)
  (test (run `{/ {* 2 3} {+ 5 8} 4})
        (/ 6 (* 13 4)))
  (test (run `{- {* 2 3} {+ 5 8} 4})
        (- 6 (+ 13 4))))

;; printer ———————————————————————————————————-

(define (print-value [v : Value]) : Void
  (display v))

(define (main [e : S-Exp]) : Void
  (print-value (eval (parse e))))

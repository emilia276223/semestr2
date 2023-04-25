#lang racket

(define/contract (f1 a b)
  (parametric->/c [a b] (-> a b a))
  ;                         n n p
  a)

(define/contract (f2 f g a)
  (parametric->/c [a b c] (-> (-> a b c) (-> a b) a c))
  ;                               p p n      p n  n p
  (f a (g a)))

(define/contract (f3 f g)
  (parametric->/c [a b c] (-> (-> b c ) (-> a b) (-> a c)))
  ;                               p n       p n      n p
  (λ (a) (f(g a))))

(define/contract (f4 f)
  (parametric->/c [a] (-> (-> (-> a a ) a) a))
                                 ;n p   n  p
  (f (λ (x) x)))

(f1 3 5)
(f2 (λ (a b) 5) (λ (a) 13) 7)
(f3 (λ (x) (- 0 x)) (λ (c) (* c 13)))
((f3 (λ (x) (- 0 x)) (λ (c) (* c 13))) 4 )
(f4 (λ (f) (f 3)))


;;ZADANIE 7/8

(define ()
  (define arity ...)
  (define (wrap ...)
    (lambda xs
      (define cs (map ...)
        (apply ...))))



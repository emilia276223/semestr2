#lang racket

(define/contract (suffixes xs)
  ;(list? . -> . list?)
  (parametric->/c [a] (-> (listof a) (listof (listof a))))
  (if (null? xs)
      (list (list))
      (cons xs (suffixes (rest xs)))))

(suffixes (list 1 2 3 4))
;(suffixes 1) ;blad kontraktu

(define x (time (suffixes (range 3000))))

(define (suffixes2 xs);teraz na testach wychodzi szybciej (0 a nie dużo) dla tych samych danych
  (if (null? xs)
      (list (list))
      (cons xs (suffixes2 (rest xs)))))

(define y (time (suffixes2 (range 3000))))
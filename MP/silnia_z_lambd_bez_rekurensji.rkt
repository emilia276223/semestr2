#lang racket
(define (silnia n)
  (let ([fact
         (λ (f) (λ (n) (if (= n 0)
                           1
                           (* n ((f f) (- n 1))))))])
    ((fact fact) n)))
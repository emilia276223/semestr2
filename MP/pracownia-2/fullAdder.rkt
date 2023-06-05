#lang racket
; Maksymilian Adamczewski
; Implementacja Adderów n-bitowych
(require "solution.rkt")
(require rackunit)

(define (binaries n xs)
  (if (= n 0)
      xs
      (binaries (- n 1) (append (map (λ (x) (cons #f x)) xs)
                                (map (λ (x) (cons #t x)) xs)))
      ))


(define (bin-value ws)
  (foldr (lambda (w value) (+ (if w 1 0) (* 2 value)))
         0
         (reverse ws)))

(define (setValues ws bin)
  (if (null? ws)
      (void)
      (begin
        (wire-set! (first ws) (first bin))
        (setValues (rest ws) (rest bin))
        )
      )
  )

(define (testAdder n) ; dla dużych n trzeba zmienić 100 na coś większego złożność to 2*2^2n
  (define adder (n-bit-adder n))
  (define bins (binaries n (list `() ) ))
  (define circ (first adder))
  (define as (second adder))
  (define bs (third adder))
  (define sub? (fourth adder))
  (define maxNum (expt 2 n))
  (for-each (λ (b1)
              (for-each (λ (b2) (begin
                                  (wire-set! sub? #f)
                                  (setValues as (reverse b1))
                                  (setValues bs (reverse b2))
                                  (sim-wait! sim 100)
                                  (check-equal? (bus-value circ) (modulo (+ (bin-value b1)
                                                                            (bin-value b2)) maxNum))
                                  (wire-set! sub? #t)
                                  (sim-wait! sim 100)
                                  (check-equal? (bus-value circ) (modulo (- (bin-value b1)
                                                                            (bin-value b2)) maxNum))))
                        bins)) bins))

(define sim (make-sim))

(define (halfAdder a b) ; zwraca pare (suma . przeniesienie)
  (list (wire-xor a b) (wire-and a b)))

(define (fullAdder a b c) ; zwraca pare (suma . przeniesienie)
  (define ha1 (halfAdder a b))
  (define s1  (first ha1))
  (define ha2 (halfAdder s1 c))
  (list (first ha2) (wire-or (second ha2) (second ha1))))

(define (add-sub as bs c sub?) ; długości as i bs muszą być równe  
  (if (null? as)
      `()
      (let
          [(add (fullAdder (first as) (wire-xor (first bs) sub?) c))]
          (cons (first add) (add-sub (rest as) (rest bs) (second add) sub?)))
      )
  )

(define (n-bit-adder n)
  (define as (build-list n (λ (n) (make-wire sim))))
  (define bs (build-list n (λ (n) (make-wire sim))))
  (define sub? (make-wire sim))
  (list (add-sub as bs sub? sub?) as bs sub?))

;(testAdder 7)
(testAdder 8) ; ostrożnie z dużymi n ;juz nie dziala




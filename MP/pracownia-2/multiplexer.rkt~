#lang racket
(require "circuitsim.rkt")
(require rackunit)

(define sim (make-sim))

(define (mux a b s)
  (wire-or (wire-and a s) (wire-and b (wire-not s) )))

(define a (make-wire sim))
(define b (make-wire sim))
(define s (make-wire sim))
(define mux1 (mux a b s))

(wire-set! a #f)
(wire-set! b #f)
(wire-set! s #f)
(sim-wait! sim 20)
(check-equal? (wire-value mux1) (wire-value b))

(wire-set! a #f)
(wire-set! b #t)
(wire-set! s #f)
(sim-wait! sim 20)
(check-equal? (wire-value mux1) (wire-value b))

(wire-set! a #t)
(wire-set! b #f)
(wire-set! s #f)
(sim-wait! sim 20)
(check-equal? (wire-value mux1) (wire-value b))

(wire-set! a #t)
(wire-set! b #t)
(wire-set! s #f)
(sim-wait! sim 20)
(check-equal? (wire-value mux1) (wire-value b))



(wire-set! a #f)
(wire-set! b #f)
(wire-set! s #t)
(sim-wait! sim 20)
(check-equal? (wire-value mux1) (wire-value a))

(wire-set! a #f)
(wire-set! b #t)
(wire-set! s #t)
(sim-wait! sim 20)
(check-equal? (wire-value mux1) (wire-value a))

(wire-set! a #t)
(wire-set! b #f)
(wire-set! s #t)
(sim-wait! sim 20)
(check-equal? (wire-value mux1) (wire-value a))

(wire-set! a #t)
(wire-set! b #t)
(wire-set! s #t)
(sim-wait! sim 20)
(check-equal? (wire-value mux1) (wire-value a))
#lang racket
(require "solution.rkt")

(define sim (make-sim))
(define w1 (make-wire sim))
(define w2 (make-wire sim))
(define wout (make-wire sim))

(wire-on-change! w1 (λ () (wire-set! wout (and (wire-value w1) (wire-value w2)))))
(sim-add-action! sim 3 (λ () (wire-set! wout (and (wire-value w1) (wire-value w2)))))

(wire-set! w1 #t)
(wire-value wout)
(wire-set! w2 #t)
(wire-value wout)
(sim-wait! sim 0.0001)
(wire-value wout)
(sim-wait! sim 5)
(wire-value wout)

#lang racket
;ostrożnie z tym układem bo on ze swojej natury jest podatny na metastabliność
(require "solution (3).rkt")
(require rackunit)

(define sim (make-sim))

(define (srLatch s r)
  (define q (make-wire sim))
  (define nq (make-wire sim))
  (gate-nor q r nq)
  (gate-nor nq s q)
  (list q nq))

(define s (make-wire sim))
(define r (make-wire sim))
(define sr (srLatch s r))

(wire-set! s   #t)
(wire-set! r   #f)
(sim-wait! sim 20)
(check-equal? (map wire-value sr) (list #t #f))

(wire-set! s   #f)
(wire-set! r   #t)
(sim-wait! sim 20)
(check-equal? (map wire-value sr) (list #f #t))

(wire-set! s   #t)
(wire-set! r   #t)
(sim-wait! sim 20)
(check-equal? (map wire-value sr) (list #f #f))

(wire-set! s   #f)
(wire-set! r   #t)
(sim-wait! sim 20)
(check-equal? (map wire-value sr) (list #f #t))

(wire-set! s   #f)
(wire-set! r   #f)
(sim-wait! sim 20)
(check-equal? (map wire-value sr) (list #f #t))

(wire-set! s   #t)
(wire-set! r   #f)
(sim-wait! sim 20)
(check-equal? (map wire-value sr) (list #t #f))

(wire-set! s   #f)
(wire-set! r   #f)
(sim-wait! sim 20)
(check-equal? (map wire-value sr) (list #t #f))



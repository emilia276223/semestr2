#lang racket

(define (last mxs)
  (if (null? (mcdr mxs))
      mxs
      (last (mcdr mxs))))

(define (cycle! mxs)
  (set-mcdr! (last mxs) mxs)
  mxs)

(define (display-first-n mxs n)
  (if (zero? n)
      (displayln '=)
      (begin (display (mcar mxs))
             (display-first-n (mcdr mxs) (- n 1)))))

(define (mlist xs)
  (if (null? xs)
      null
      (mcons (first xs) (mlist (rest xs)))))

(define ml1 (mlist (list 1 2 3 4 5 6 7 8)))
(display-first-n ml1 5)
(set! ml1 (cycle! ml1))
(display-first-n ml1 10)
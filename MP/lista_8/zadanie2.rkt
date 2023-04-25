#lang racket

(define (mrev! mx mxs)
  (cond [(null? mxs) mx]
        [(null? (mcdr mxs))
         (begin (set-mcdr! mxs mx) mxs)] ;zwracam nowy pierwszy
        [else (let ([rest (mrev! mxs (mcdr mxs))]) ;zamieniona reszta, rest to nowy poczatek
                (begin (set-mcdr! mxs mx) rest))]))

(define (mreverse! mxs)
  (if (null? mxs)
      mxs
      (let ([new(mrev! mxs (mcdr mxs))])
             (begin (set-mcdr! mxs null) new))))

(define (mlist xs)
  (if (null? xs)
      null
      (mcons (first xs) (mlist (rest xs)))))

(define (display-first-n mxs n)
  (cond [(zero? n) (displayln '=)]
        [(null? mxs) (displayln '=)]
        [else (begin (display (mcar mxs))
                     (display-first-n (mcdr mxs) (- n 1)))]))

(define ml1 (mlist (list 1 2 3 4 5 6 7 8)))
(display-first-n (mreverse! ml1) 100)
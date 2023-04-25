#lang racket

(define/contract (foldl-map f a xs)
  (parametric->/c [a acc c] (-> (-> a acc (cons/c acc acc)) acc (listof a)
                                (cons/c (listof acc) acc)))
   (define (it a xs ys)
      (if (null? xs)
          (cons (reverse ys) a)
          (let [(p (f (car xs) a))]
            (it (cdr p)
                 (cdr xs)
                 (cons (car p) ys)))))
   (it a xs null))

(foldl-map (lambda (x a) (cons a (+ a x))) 0 '(1 2 3))
;prawdopodobnie dziala
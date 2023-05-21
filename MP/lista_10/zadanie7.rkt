#lang plait
(define-syntax my-and
  (syntax-rules ()
    [(my-and) #t]
    [(my-and a) a]
    [(my-and a1 a2 ... )
     (if a1
         (my-and a2 ...)
         #f)]))

(define-syntax my-or
  (syntax-rules ()
    [(my-or)
     #f]
    [(my-or a) a]
    [(my-or a1 a2 ... )
     (if a1
         a1
         (my-or a2 ...))]))


(define-syntax my-let ;dziala
  (syntax-rules ()
    [(my-let ([v exp]) body)
     ((λ (v) body ) exp)]
    [(my-let ([v1 exp1] [v2 exp2] ...) body)
     ((λ (v1 v2 ...) body ) exp1 exp2 ...)]))

(define-syntax my-let*
  (syntax-rules ()
    [(my-let* () body) body]
    [(my-let* ([v1 exp1] [v2 exp2] ...) body)
     ((λ (v1) (my-let* ([v2 exp2] ...) body)) exp1)]))

(my-and #t #t #f) ; Should return #f, as the third argument is false

(my-or #f #f #t) ; Should return #t, as the third argument is true

(my-let ((x 5) (y 10))
  (+ x y)) ; Should return 15, as it evaluates (+ 5 10)

(my-let* ((x 5)
          (y (+ x 2)) ;7
          (z (* y 3))) ;21
  (* x (* y z))) ; Should return 735, as it evaluates (* 5 7 15)
#lang plait

(define-type MyRacket
  (r-variable [x : Symbol])
  (r-num [n : Number])
  (r-lambda [var : (Listof MyRacket)] [exp : MyRacket])
  (r-func [f : Symbol] [var : (Listof MyRacket)])
  (r-let [l : (Listof (MyRacket * MyRacket))] [exp : MyRacket])
  (r-if [con : MyRacket] [t : MyRacket] [f : MyRacket])
  (r-cond [cs : (Listof (MyRacket * MyRacket))]))

(define (parse-all xs); przyjmuje liste wyrazen
  (if (empty? xs)
      empty
      (cons (parse-Exp (first xs)) (parse-all (rest xs)))));zwraca liste MyRacket

(define (parse-pairs xs);przyjmuje liste wyrazen
  (if (empty? xs)
      empty
      (let ([wyr (s-exp->list (first xs))])
        (cons (pair (parse-Exp (first wyr))
                  (parse-Exp (second wyr)))
            (parse-pairs (rest xs))))))

(define (parse-Exp s)
  (cond
    [(s-exp-number? s) (r-num (s-exp->number s))]
    [(s-exp-symbol? s) (r-variable (s-exp->symbol s))]
    [(s-exp-list? s)
     (letrec ([xs (s-exp->list s)] [f (s-exp->symbol (first xs))])
       (cond [(equal? f 'lambda) (r-lambda (parse-all (s-exp->list (second xs))) (parse-Exp (third xs)))]
             [(equal? f 'let) (r-let (parse-pairs (s-exp->list (second xs))) (parse-Exp (third xs)))]
             [(equal? f 'if) (r-if (parse-Exp (second xs))(parse-Exp (third xs))(parse-Exp (fourth xs)))]
             [(equal? f 'cond) (r-cond (parse-pairs (rest xs)))]
             [else ;aplikacja
              (r-func (s-exp->symbol (second xs)) (parse-all (rest xs)))]))]
    ))


#lang racket

(provide
 double-queue?
 make-double-queue
 (contract-out
  [double-queue-empty? (-> double-queue? boolean?)]
  [double-queue-push-front (-> double-queue? any/c void)]
  [double-queue-push-back (-> double-queue? any/c void)]
  [double-queue-pop-front (-> double-queue? any/c)]
  [double-queue-pop-back (-> double-queue? any/c)]
  [double-queue-join (-> double-queue? double-queue? void)]
  [double-queue-print (-> double-queue? void)])) 

(struct double-queue (front back) #:mutable)
(struct double-elem (prev val next) #:mutable)

(define (make-double-queue) (double-queue null null))

(define (double-queue-empty? q);pusta ma oba konce puste
  (and (null? (double-queue-front q))
       (null? (double-queue-back q))))

(define (double-queue-push-front q val)
  (define elem (double-elem null val null))
  (if (double-queue-empty? q)
      (begin (set-double-queue-front! q elem)
             (set-double-queue-back! q elem)
             (void))
      (begin (set-double-elem-prev! (double-queue-front q) elem)
             (set-double-elem-next! elem (double-queue-front q))
             (set-double-queue-front! q elem)
             (void))))

(define (double-queue-push-back q val)
  (define elem (double-elem null val null))
  (if (double-queue-empty? q)
      (begin (set-double-queue-front! q elem)
             (set-double-queue-back! q elem)
             (void))
      (begin (set-double-elem-next! (double-queue-back q) elem)
             (set-double-elem-prev! elem (double-queue-back q))
             (set-double-queue-back! q elem)
             (void))))

(define (double-queue-pop-front q)
  (if (null? double-queue-front)
      (error 'double-queue "próba wzięcia elementu z pustej kolejki")
      (let ([val (double-elem-val (double-queue-front q))])
      (if (equal? (double-queue-front q) (double-queue-back q))
          (begin (set-double-queue-front! q null)
                 (set-double-queue-back! q null)
                 val)
          (begin (set-double-queue-front! q (double-elem-next (double-queue-front q)))
                 (set-double-elem-prev! (double-queue-front q) null)
                 val)))))

(define (double-queue-pop-back q)
(if (null? double-queue-back)
      (error 'double-queue "próba wzięcia elementu z pustej kolejki")
      (let ([val (double-elem-val (double-queue-back q))])
        (if (equal? (double-queue-front q) (double-queue-back q))
            (begin (set-double-queue-front! q null)
                   (set-double-queue-back! q null)
                   val)
            (begin (set-double-queue-back! q (double-elem-prev (double-queue-back q)))
                   (set-double-elem-next! (double-queue-front q) null)
                   val)))))

(define (double-queue-join q1 q2)
  (cond [(null? (double-queue-front q1)) (begin (set-double-queue-back! q1 (double-queue-back q2))
                                                (set-double-queue-front! q1 (double-queue-front q2))
                                                (set-double-queue-front! q2 null)
                                                (set-double-queue-back! q2 null))]
        [(null? (double-queue-front q2)) (void)]
        [else (begin (set-double-elem-next! (double-queue-back q1) (double-queue-front q2))
                     (set-double-elem-prev! (double-queue-front q2) (double-queue-back q1))
                     (set-double-queue-back! q1 (double-queue-back q2))
                     (set-double-queue-front! q2 null)
                     (set-double-queue-back! q2 null)
                     (void))]))

(define (double-queue-print-rest elem)
  (cond [(null? elem) (void)]
        [(null? (double-elem-next elem)) (display (double-elem-val elem))]
        [else (begin (display (double-elem-val elem))
                     (display ", ")
                     (double-queue-print-rest (double-elem-next elem)))]))

(define (double-queue-print q1)
  (display "(")
  (double-queue-print-rest (double-queue-front q1))
  (displayln ")"))

;(double-queue-print (make-double-queue))
(define q1 (make-double-queue))
(double-queue-push-back q1 2)
(double-queue-push-back q1 1)
(double-queue-push-back q1 3)
(double-queue-push-back q1 7)
(double-queue-print q1)
(define q2 (make-double-queue))
(double-queue-push-back q2 4)
(double-queue-push-back q2 2)
(double-queue-push-back q2 0)
(double-queue-push-back q2 6)
(double-queue-push-back q2 9)
(double-queue-print q2)
(double-queue-join q1 q2)
(double-queue-print q1)
(double-queue-print q2)
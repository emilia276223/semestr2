#lang racket
(require data/heap)
(provide sim?
         wire?
         (contract-out
          [make-sim        (-> sim?)]
          [sim-wait!       (-> sim? positive? void?)]
          [sim-time        (-> sim? real?)]
          [sim-add-action! (-> sim? positive? (-> any/c) void?)]

          [make-wire       (-> sim? wire?)]
          [wire-on-change! (-> wire? (-> any/c) void?)]
          [wire-value      (-> wire? boolean?)]
          [wire-set!       (-> wire? boolean? void?)]

          [bus-value (-> (listof wire?) natural?)]
          [bus-set!  (-> (listof wire?) natural? void?)]

          [gate-not  (-> wire? wire? void?)]
          [gate-and  (-> wire? wire? wire? void?)]
          [gate-nand (-> wire? wire? wire? void?)]
          [gate-or   (-> wire? wire? wire? void?)]
          [gate-nor  (-> wire? wire? wire? void?)]
          [gate-xor  (-> wire? wire? wire? void?)]

          [wire-not  (-> wire? wire?)]
          [wire-and  (-> wire? wire? wire?)]
          [wire-nand (-> wire? wire? wire?)]
          [wire-or   (-> wire? wire? wire?)]
          [wire-nor  (-> wire? wire? wire?)]
          [wire-xor  (-> wire? wire? wire?)]

          [flip-flop (-> wire? wire? wire? void?)]))

(struct wire (value sim) #:mutable)

(struct sim (time actions-q) #:mutable)

(struct action (time todo))

(sim-time sim)

(define (make-sim)
  (sim 0 (make-heap (λ (v1 v2)
                      (<= (action-time v1) (action-time v2))))))

(define (do-action! act);TRZEBA JESZCZE ZROBIC
  (void))

(define (do-actions sim)
  #;(with-handlers ([heap-empty? (λ (exn) #f)])
    (define act (heap-min sim)))
  (if (eq? (sim-actions-q (make-sim)) (sim-actions-q sim))
      (let ([act (heap-min (sim-actions-q sim))])
        (if (<= (action-time act) (sim-time sim))
            (begin (do-action! act)
                   (heap-remove-min! (sim-actions-q sim))
                   (do-actions sim))
            (void)))
      (void)))

(define (sim-wait! sim t)
  (define (iter time)
    (if (< (sim-time sim) time)
        (begin (set-sim-time! (+ (sim-time sim) 1))
               (do-actions sim))
        (void)))
  (iter t))

(define (make-wire sim)
  (wire #f sim))

(define (wire-set! w b)
  (set-wire-value! w b))


(define (bus-set! wires value)
  (match wires
    ['() (void)]
    [(cons w wires)
     (begin
       (wire-set! w (= (modulo value 2) 1))
       (bus-set! wires (quotient value 2)))]))

(define (bus-value ws)
  (foldr (lambda (w value) (+ (if (wire-value w) 1 0) (* 2 value)))
         0
         ws))

(define (wire-not w1)
  (define sim (wire-sim w1))
  (define w2 (make-wire sim))
  (begin (gate-not w1 w2)
         w2))

(define (wire-and w1 w2)
  (define sim (wire-sim w1))
  (define w3 (make-wire sim))
  (begin (gate-and w1 w2 w3)
         w3))

(define (wire-nand w1 w2)
  (define sim (wire-sim w1))
  (define w3 (make-wire sim))
  (begin (gate-nand w1 w2 w3)
         w3))

(define (wire-or w1 w2)
  (define sim (wire-sim w1))
  (define w3 (make-wire sim))
  (begin (gate-or w1 w2 w3)
         w3))

(define (wire-nor w1 w2)
  (define sim (wire-sim w1))
  (define w3 (make-wire sim))
  (begin (gate-nor w1 w2 w3)
         w3))

(define (wire-xor w1 w2)
  (define sim (wire-sim w1))
  (define w3 (make-wire sim))
  (begin (gate-xor w1 w2 w3)
         w3))

(define (flip-flop out clk data)
  (define sim (wire-sim data))
  (define w1  (make-wire sim))
  (define w2  (make-wire sim))
  (define w3  (wire-nand (wire-and w1 clk) w2))
  (gate-nand w1 clk (wire-nand w2 w1))
  (gate-nand w2 w3 data)
  (gate-nand out w1 (wire-nand out w3)))
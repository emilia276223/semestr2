#lang racket

(require data/heap)
(provide sim? wire?
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

          [flip-flop (-> wire? wire? wire? void?)]
          ))

;funkcje pomocnicze wyliczajace wartosci logiczne

(define (logical-not in);zeby mozna bylo odpalac zawsze z 2 argumentami
  (not (wire-value in)))
(define (logical-and in1 in2)
  (and (wire-value in1) (wire-value in2)))
(define (logical-nand in1 in2)
  (not (and (wire-value in1) (wire-value in2))))
(define (logical-or in1 in2)
  (or (wire-value in1) (wire-value in2)))
(define (logical-nor in1 in2)
  (and (not (wire-value in1)) (not (wire-value in2))))
(define (logical-xor in1 in2)
  (and (not (and (wire-value in1) (wire-value in2)))
       (or (wire-value in1) (wire-value in2))))

;testy wartosci logicznych

(struct wire (value sim actions) #:mutable)

(struct sim (time actions-q) #:mutable)

(define (make-wire sim)
  (wire #f sim null))

(define (sim-add-action! sim time act)
  (begin ;(heap-remove! (sim-actions-q sim) (list (+ (sim-time sim) time) act)); czy to potrzebne?
         (heap-add! (sim-actions-q sim) (list (+ (sim-time sim) time) act))))

(define (add-list-of-actions sim acts)
  (if (null? acts) (void)
      (begin ;(sim-add-action! sim (first (first acts)) (second (first acts)))
             ((first acts))
             (add-list-of-actions sim (rest acts)))))

(define (wire-set! w b)
  (if (equal? b (wire-value w))
      (void)
      (begin (set-wire-value! w b)
             (add-list-of-actions (wire-sim w) (wire-actions w)))))

(define (make-sim) ;w kolejce trzymam pary: (czas wykonania * akcja)
  (sim 0 (make-heap (λ (v1 v2)
                      (<= (first v1) (first v2))))))

(define (heap-empty? h)
  (= (heap-count h) 0))

(define (sim-wait! sim t)
  (if (> 0 t)
      (void)
      (if (heap-empty? (sim-actions-q sim))
          (begin (set-sim-time! sim (+ (sim-time sim) t))
                 (void))
          (let* ([act (heap-min (sim-actions-q sim))]
                 [timedif (- (first act) (sim-time sim))]);ile musi poczekac przed wykonaniem pierwszej akcji
            (if (<= (first act) (+ (sim-time sim) t))
                (begin (set-sim-time! sim (first act));ustawiam czas symulacji
                       (heap-remove-min! (sim-actions-q sim))
                       ((second act)); wykonuje akcje
                       (sim-wait! sim (- t timedif)))
                (void))))))

(define (wire-on-change! w act)
  (begin (set-wire-actions! w (cons act (wire-actions w)))
         (act)))

(define (gate-not w-out w-in)
  (wire-on-change! w-in (λ () (sim-add-action! (wire-sim w-out) 1 (λ () (wire-set! w-out (logical-not w-in)))))))

(define (gate-and w-out w-in1 w-in2)
  (begin 
         (wire-on-change! w-in1 (λ () (sim-add-action! (wire-sim w-out) 1 (λ () (wire-set! w-out (logical-and w-in1 w-in2))))))
         (wire-on-change! w-in2 (λ () (sim-add-action! (wire-sim w-out) 1 (λ () (wire-set! w-out (logical-and w-in1 w-in2))))))))

(define (gate-nand w-out w-in1 w-in2)
  (begin (wire-on-change! w-in1 (λ () (sim-add-action! (wire-sim w-out) 1 (λ () (wire-set!  w-out (logical-nand w-in1 w-in2))))))
         (wire-on-change! w-in2 (λ () (sim-add-action! (wire-sim w-out) 1 (λ () (wire-set!  w-out (logical-nand w-in1 w-in2))))))))

(define (gate-or w-out w-in1 w-in2)
  (begin (wire-on-change! w-in1 (λ () (sim-add-action! (wire-sim w-out) 1 (λ () (wire-set!  w-out (logical-or w-in1 w-in2))))))
         (wire-on-change! w-in2 (λ () (sim-add-action! (wire-sim w-out) 1 (λ () (wire-set!  w-out (logical-or w-in1 w-in2))))))))

(define (gate-nor w-out w-in1 w-in2)
  (begin (wire-on-change! w-in1 (λ () (sim-add-action! (wire-sim w-out) 1 (λ () (wire-set!  w-out (logical-nor w-in1 w-in2))))))
         (wire-on-change! w-in2 (λ () (sim-add-action! (wire-sim w-out) 1 (λ () (wire-set!  w-out (logical-nor w-in1 w-in2))))))))

(define (gate-xor w-out w-in1 w-in2)
  (begin (wire-on-change! w-in1 (λ () (sim-add-action! (wire-sim w-out) 2 (λ () (wire-set! w-out (logical-xor w-in1 w-in2))))))
         (wire-on-change! w-in2 (λ () (sim-add-action! (wire-sim w-out) 2 (λ () (wire-set! w-out (logical-xor w-in1 w-in2))))))))

(define (wire-not w1)
  (define sim (wire-sim w1))
  (define w2 (make-wire sim))
  (begin (gate-not w2 w1)
         w2))

(define (wire-and w1 w2)
  (define sim (wire-sim w1))
  (define w3 (make-wire sim))
  (begin (gate-and w3 w1 w2)
         w3))

(define (wire-nand w1 w2)
  (define sim (wire-sim w1))
  (define w3 (make-wire sim))
  (begin (gate-nand w3 w1 w2)
         w3))

(define (wire-or w1 w2)
  (define sim (wire-sim w1))
  (define w3 (make-wire sim))
  (begin (gate-or w3 w1 w2)
         w3))

(define (wire-nor w1 w2)
  (define sim (wire-sim w1))
  (define w3 (make-wire sim))
  (begin (gate-nor w3 w1 w2)
         w3))

(define (wire-xor w1 w2)
  (define sim (wire-sim w1))
  (define w3 (make-wire sim))
  (begin (gate-xor w3 w1 w2)
         w3))

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

(define (flip-flop out clk data)
  (define sim (wire-sim data))
  (define w1  (make-wire sim))
  (define w2  (make-wire sim))
  (define w3  (wire-nand (wire-and w1 clk) w2))
  (gate-nand w1 clk (wire-nand w2 w1))
  (gate-nand w2 w3 data)
  (gate-nand out w1 (wire-nand out w3)))





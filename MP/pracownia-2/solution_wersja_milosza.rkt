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

          [flip-flop (-> wire? wire? wire? void?)]))

;<><><><><><><><><><><><><><><><><><><><> Wire Functions <><><><><><><><><><><><><><><><><><><><>

(struct wire (sim val actions) #:mutable #:transparent)

(define (make-wire sim) ;done
  (wire sim #f '()))

(define (wire-on-change! wire action) ;done
  (set-wire-actions! wire (cons action (wire-actions wire))))

(define (wire-value wire) ;done
  (wire-val wire))

(define (wire-set! wire bool) ;done
  (if (equal? (wire-val wire) bool)
      (void)
      (let ([sim (wire-sim wire)])
        (define (add-actions actions)
          (cond [(empty? actions) (void)]
                [(equal? (action-function (first actions)) logical-xor) (begin (sim-add-action! sim 2 (first actions))
                                                                               (add-actions (rest actions)))]
                [else (begin (sim-add-action! sim 1 (first actions))
                             (add-actions (rest actions)))]))
        (begin (set-wire-val! wire bool)
        (add-actions (wire-actions wire))))))

(struct sim (current_time events_queue) #:transparent #:mutable)

(struct action (input1 input2 output function) #:transparent)
(define (heap<=? x y)
    (< (first x) (first y)))

(define (make-sim) ;done
  (sim 0 (make-heap heap<=?)))

(define (sim-wait! sim time)
  (let ([new_time (+ time (sim-current_time sim))])
    (define (do)
      (if (= (heap-count (sim-events_queue sim)) 0)
          (set-sim-current_time! sim new_time)
          (let* ([min (heap-min (sim-events_queue sim))]
                 [action_time (first min)]
                 [actionn (second min)])
      (cond [(> action_time new_time) (set-sim-current_time! sim new_time)]
            [(> action_time (sim-time sim)) (begin (set-sim-current_time! sim action_time)
                                                   (do))]
            [(< action_time (sim-time sim)) (error "skjdsj")]
            [else (begin (heap-remove-min! (sim-events_queue sim))
                         (wire-set! (action-output actionn) (if (equal? (action-function actionn) logical-not)
                                                               ((action-function actionn) (wire-val (action-input1 actionn)))
                                                               ((action-function actionn) (wire-val (action-input1 actionn)) (wire-val (action-input2 actionn)))))
                         (do))]))))
    (do)))

(define (sim-time sim) ;done
  (sim-current_time sim))

(define (sim-add-action! sim time action) ;done
  (heap-add! (sim-events_queue sim) (list (+ time (sim-current_time sim)) action)))

;<><><><><><><><><><><><><><><><><><><><> Logic Gates <><><><><><><><><><><><><><><><><><><><>

(define (logical-not input)
  (cond [(not input) #t]
        [input #f]
        [else (error "Nieprawidłwy sygnał logical-not")]))

(define (logical-and input1 input2)
  (cond [(and input1 input2) #t]
        [(not input1) #f]
        [(not input2) #f]
        [else (error "Nieprawidłwy sygnał logical-and")]))

(define (logical-nand input1 input2)
  (cond [(and input1 input2) #f]
        [(not input1) #t]
        [(not input2) #t]
        [else (error "Nieprawidłwy sygnał logical-nand")]))

(define (logical-or input1 input2)
  (cond [(and (not input1) (not input2)) #f]
        [input1 #t]
        [input2 #t]
        [else (error "Nieprawidłwy sygnał logical-or")]))

(define (logical-nor input1 input2)
  (cond [(and (not input1) (not input2)) #t]
        [input1 #f]
        [input2 #f]
        [else (error "Nieprawidłwy sygnał logical-nor")]))

(define (logical-xor input1 input2)
  (cond [(and input1 input2) #f]
        [(and (not input1) (not input2)) #f]
        [input1 #t]
        [input2 #t]
        [else (error "Nieprawidłwy sygnał logical-xor")]))

(define (gate-not output input)
  (set-wire-val! output (logical-not (wire-val input)))
  (wire-on-change! input (action input -inf.0 output logical-not)))

(define (gate-and output input1 input2)
  (set-wire-val! output (logical-and (wire-val input1) (wire-val input2)))
  (wire-on-change! input1 (action input1 input2 output logical-and))
  (wire-on-change! input2 (action input1 input2 output logical-and)))

(define (gate-nand output input1 input2)
  (set-wire-val! output (logical-nand (wire-val input1) (wire-val input2)))
  (wire-on-change! input1 (action input1 input2 output logical-nand))
  (wire-on-change! input2 (action input1 input2 output logical-nand)))

(define (gate-or output input1 input2)
  (set-wire-val! output (logical-or (wire-val input1) (wire-val input2)))
  (wire-on-change! input1 (action input1 input2 output logical-or))
  (wire-on-change! input2 (action input1 input2 output logical-or)))

(define (gate-nor output input1 input2)
  (set-wire-val! output (logical-nor (wire-val input1) (wire-val input2)))
  (wire-on-change! input1 (action input1 input2 output logical-nor))
  (wire-on-change! input2 (action input1 input2 output logical-nor)))

(define (gate-xor output input1 input2)
  (set-wire-val! output (logical-xor (wire-val input1) (wire-val input2)))
  (wire-on-change! input1 (action input1 input2 output logical-xor))
  (wire-on-change! input2 (action input1 input2 output logical-xor)))

(define (wire-not input)
  (define output (make-wire (wire-sim input)))
  (gate-not output input)
  output)

(define (wire-and input1 input2)
  (define output (make-wire (wire-sim input1)))
  (gate-and output input1 input2)
  output)

(define (wire-nand input1 input2)
  (define output (make-wire (wire-sim input1)))
  (gate-nand output input1 input2)
  output)

(define (wire-or input1 input2)
  (define output (make-wire (wire-sim input1)))
  (gate-or output input1 input2)
  output)

(define (wire-nor input1 input2)
  (define output (make-wire (wire-sim input1)))
  (gate-nor output input1 input2)
  output)

(define (wire-xor input1 input2)
  (define output (make-wire (wire-sim input1)))
  (gate-xor output input1 input2)
  output)

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
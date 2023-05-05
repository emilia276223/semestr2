#lang racket

(define-struct leaf () #:transparent)
(define-struct node (l elem r) #:transparent)

#;(define morse-tree
  (node 
   (node
    (node
     (node
      (node
       (node (leaf) "5" (leaf))
       "h"
       (node (leaf) "4" (leaf)))
      "s"
      (node (leaf) "v" (node (leaf) "3" (leaf))))
     "i"
     (node
      (node (leaf) "f" (leaf))
      "u"
      (node
       (node
        (node (leaf) "?" (leaf))
        "error"
        (node (leaf) "_" (leaf)))
       "error"
       (node (leaf) "2" (leaf))))))
    "e"
    (node
     (node
      (node
       (node (leaf) "error" (leaf))
       "l" (leaf))
      "r"
      (node (leaf) "v" (node (leaf) "3" (leaf))))
     "a"
     (node
      (node (leaf) "f" (leaf)
      "u"
      (node
       (node
        (node (leaf) "?" (leaf))
        "error"
        (node (leaf) "_" (leaf)))
       "error"
       (node (leaf) "2" (leaf)))))))
   "error"
   )

(define decode
  (list
   ; litery
   (cons (list->string(list #\. #\_)) "a")
   (cons (list->string(list #\_ #\. #\. #\.)) "b")
   (cons (list->string(list #\_ #\. #\_ #\. )) "c")
   (cons (list->string(list #\_ #\. #\.)) "d")
   (cons (list->string(list #\.)) "e")
   (cons (list->string(list #\. #\. #\_ #\.)) "f")
   (cons (list->string(list #\_ #\_ #\. )) "g")
   (cons (list->string(list #\. #\. #\. #\. )) "h")
   (cons (list->string(list #\. #\.)) "i")
   (cons (list->string(list #\. #\_ #\_ #\_)) "j")
   (cons (list->string(list #\_ #\. #\_)) "k")
   (cons (list->string(list #\. #\_ #\. #\.)) "l")
   (cons (list->string(list #\_ #\_)) "m")
   (cons (list->string(list #\_ #\.)) "n")
   (cons (list->string(list #\_ #\_ #\_)) "o")
   (cons (list->string(list #\. #\_ #\_ #\.)) "p")
   (cons (list->string(list #\_ #\_ #\. #\_)) "q")
   (cons (list->string(list #\. #\_ #\.)) "r")
   (cons (list->string(list #\. #\. #\.)) "s")
   (cons (list->string(list #\_)) "t")
   (cons (list->string(list #\. #\. #\_)) "u")
   (cons (list->string(list #\. #\_ #\_)) "w")
   (cons (list->string(list #\. #\. #\. #\_)) "v")
   (cons (list->string(list #\_ #\. #\. #\_)) "x")
   (cons (list->string(list #\_ #\. #\_ #\_)) "y")
   (cons (list->string(list #\_ #\_ #\. #\.)) "z")
        
   ;cyfry
   (cons (list->string(list #\. #\_ #\_ #\_ #\_)) "1")
   (cons (list->string(list #\. #\. #\_ #\_ #\_)) "2")
   (cons (list->string(list #\. #\. #\. #\_ #\_)) "3")
   (cons (list->string(list #\. #\. #\. #\. #\_)) "4")
   (cons (list->string(list #\. #\. #\. #\. #\.)) "5")
   (cons (list->string(list #\_ #\. #\. #\. #\.)) "6")
   (cons (list->string(list #\_ #\_ #\. #\. #\.)) "7")
   (cons (list->string(list #\_ #\_ #\_ #\. #\.)) "8")
   (cons (list->string(list #\_ #\_ #\_ #\_ #\.)) "9")
   (cons (list->string(list #\_ #\_ #\_ #\_ #\_)) "0")

   ; wybrane znaki interpunkcyjne
   (cons (list->string(list #\. #\_ #\. #\_ #\. #\_)) ".")
   (cons (list->string(list #\_ #\_ #\. #\. #\_ #\_)) ",")
   (cons (list->string(list #\_ #\. #\_ #\. #\_ #\.)) ";")
   (cons " " " ")))


;                   lista  string
(define (to-letters morse acc)
  (cond [(null? morse) (if (equal? acc "") null (list acc))]
        [(equal? #\space (first morse))
         ;(display "spacja, gdy: ")
         ;(displayln acc)
         (if (equal? acc "")
             (cons " " (to-letters (rest morse) ""))
             (cons acc (to-letters (rest morse) "")))]
        [else (to-letters (rest morse) (string-append (list->string (list (first morse))) acc))]))

(define (decoding letters)
  (if (null? letters) ""
      (string-append (dict-ref decode (first letters)) (decoding (rest letters)))))

(define (morse-decode morse)
  (define letters (to-letters (string->list morse) ""))
  ;(display (string->list morse))
  (decoding letters))
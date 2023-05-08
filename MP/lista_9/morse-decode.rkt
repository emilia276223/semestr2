#lang racket

(define decode
  (list
   ; litery
   (cons "._" "a")
   (cons "_..." "b")
   (cons "_._." "c")
   (cons "_.." "d")
   (cons "." "e")
   (cons ".._." "f")
   (cons "__." "g")
   (cons "...." "h")
   (cons ".." "i")
   (cons ".___" "j")
   (cons "_._" "k")
   (cons "._.." "l")
   (cons "__" "m")
   (cons "_." "n")
   (cons "___" "o")
   (cons ".__." "p")
   (cons "__._" "q")
   (cons "._." "r")
   (cons "..." "s")
   (cons "_" "t")
   (cons ".._" "u")
   (cons ".__" "w")
   (cons "..._" "v")
   (cons "_.._" "x")
   (cons "_.__" "y")
   (cons "__.." "z")
        
   ;cyfry
   (cons ".____" "1")
   (cons "..___" "2")
   (cons "...__" "3")
   (cons "...._" "4")
   (cons "....." "5")
   (cons "_...." "6")
   (cons "__..." "7")
   (cons "___.." "8")
   (cons "____." "9")
   (cons "_____" "0")

   ; wybrane znaki interpunkcyjne
   (cons "._._._" ".")
   (cons "__..__" ",")
   (cons "_._._." ";")
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
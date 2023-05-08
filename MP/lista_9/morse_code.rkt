#lang racket

(define code
  (list
   ; litery
   (cons "a" "._")
   (cons "b" "_...")
   (cons "c" "_._.")
   (cons "d" "_..")
   (cons "e" ".")
   (cons "f" ".._.")
   (cons "g" "__.")
   (cons "h" "....")
   (cons "i" "..")
   (cons "j" ".___")
   (cons "k" "_._")
   (cons "l" "._..")
   (cons "m" "__")
   (cons "n" "_.")
   (cons "o" "___")
   (cons "p" ".__.")
   (cons "q" "__._")
   (cons "r" "._.")
   (cons "s" "...")
   (cons "t"  "_" )
   (cons "u" ".._")
   (cons "w" ".__")
   (cons "v" "..._")
   (cons "x" "_.._")
   (cons "y" "_.__")
   (cons "z" "__..")
        
   ;cyfry
   (cons "1" ".____")
   (cons "2" "..___")
   (cons "3" "...__")
   (cons "4"  "...._")
   (cons "5" ".....")
   (cons "6" "_....")
   (cons "7" "__...")
   (cons "8" "___..")
   (cons "9" "____.")
   (cons "0" "_____")

   ; wybrane znaki interpunkcyjne
   (cons "." "._._._")
   (cons "," "__..__")
   (cons ";" "_._._.")))

;(dict? code) #t

(define (remove-whitespaces xs)
  (if (null? xs) null
      (if (char-whitespace? (first xs))
          (remove-whitespaces (rest xs)) xs)))

(define (morse-code-list litery)
  ;(display "teraz robimy literę ")
  ;(displayln (char-downcase (first litery)))
  ;(displayln (char? (char-downcase (first litery))))
  (cond [(null? litery) ""]
        [(char-whitespace? (first litery))
         (cond [(null? (rest litery)) (list " ")]
               [else (string-append "  " (morse-code-list (remove-whitespaces (rest litery))))])]
        [else (string-append (string-append (dict-ref code (list->string (list (char-downcase (first litery))))) " "
                    (morse-code-list (rest litery))))]))

(define (morse-code nazwa)
  (morse-code-list (string->list nazwa)))

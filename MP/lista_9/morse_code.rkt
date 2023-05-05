#lang racket

(define code
  (list
   ; litery
   (cons "a" (list->string(list #\. #\_)))
   (cons "b" (list->string(list #\_ #\. #\. #\.)))
   (cons "c" (list->string(list #\_ #\. #\_ #\. )))
   (cons "d" (list->string(list #\_ #\. #\.)))
   (cons "e" (list->string(list #\.)))
   (cons "f" (list->string(list #\. #\. #\_ #\.)))
   (cons "g" (list->string(list #\_ #\_ #\. )))
   (cons "h" (list->string(list #\. #\. #\. #\. )))
   (cons "i" (list->string(list #\. #\.)))
   (cons "j" (list->string(list #\. #\_ #\_ #\_)))
   (cons "k" (list->string(list #\_ #\. #\_)))
   (cons "l" (list->string(list #\. #\_ #\. #\.)))
   (cons "m" (list->string(list #\_ #\_)))
   (cons "n" (list->string(list #\_ #\.)))
   (cons "o" (list->string(list #\_ #\_ #\_)))
   (cons "p" (list->string(list #\. #\_ #\_ #\.)))
   (cons "q" (list->string(list #\_ #\_ #\. #\_)))
   (cons "r" (list->string(list #\. #\_ #\.)))
   (cons "s" (list->string(list #\. #\. #\.)))
   (cons "t" (list->string(list #\_)))
   (cons "u" (list->string(list #\. #\. #\_)))
   (cons "w" (list->string(list #\. #\_ #\_)))
   (cons "v" (list->string(list #\. #\. #\. #\_)))
   (cons "x" (list->string(list #\_ #\. #\. #\_)))
   (cons "y" (list->string(list #\_ #\. #\_ #\_)))
   (cons "z" (list->string(list #\_ #\_ #\. #\.)))
        
   ;cyfry
   (cons "1" (list->string(list #\. #\_ #\_ #\_ #\_)))
   (cons "2" (list->string(list #\. #\. #\_ #\_ #\_)))
   (cons "3" (list->string(list #\. #\. #\. #\_ #\_)))
   (cons "4" (list->string(list #\. #\. #\. #\. #\_)))
   (cons "5" (list->string(list #\. #\. #\. #\. #\.)))
   (cons "6" (list->string(list #\_ #\. #\. #\. #\.)))
   (cons "7" (list->string(list #\_ #\_ #\. #\. #\.)))
   (cons "8" (list->string(list #\_ #\_ #\_ #\. #\.)))
   (cons "9" (list->string(list #\_ #\_ #\_ #\_ #\.)))
   (cons "0" (list->string(list #\_ #\_ #\_ #\_ #\_)))

   ; wybrane znaki interpunkcyjne
   (cons "." (list->string(list #\. #\_ #\. #\_ #\. #\_)))
   (cons "," (list->string(list #\_ #\_ #\. #\. #\_ #\_)))
   (cons ";" (list->string(list #\_ #\. #\_ #\. #\_ #\.)))))

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

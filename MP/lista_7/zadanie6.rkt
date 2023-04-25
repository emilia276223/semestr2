#lang racket

;Funkcji fold-right możemy nadać następujący kontrakt parametryczny:
;( parametric- >/ c [ a b ] (- > (- > a b b ) b ( listof a ) b ) )
;W języku Plait ta funkcja otrzymuje następujący, analogiczny do powyższego
;kontraktu typ parametryczny:
;(('a 'b - > 'b ) 'b ( Listof 'a ) - > 'b )
;Możemy rozważyć zmienione wersje kontraktu i typu powyżej, gdzie zamiast
;dwóch parametrów a i b użyjemy tylko jednego, a, który zastąpi wszystkie
;wystąpienia a i b. Odpowiedz na pytania:


;Jaka błędna implementacja procedury fold-right będzie spełniać zmienioną wersję
;kontraktu i mieć zmienioną wersję typu, a zostanie odrzucona przez wersje oryginalne?

;Uwaga: z powodu nietypowego zachowania interpretera Plaita, aby sprawdzić, czy procedura
;fold-right ma powyższy typ, należy napisać w REPLu:
;(has-type foldr-right : (('a 'b -> 'b) 'b (Listof 'a) -> 'b))
;a następnie zwrócić uwagę, czy typ wypisany przez REPLa jest tym, którego żądaliśmy.


;• Czy zmieniona wersja kontraktu ogranicza sposób użytkowania procedury?
;tak mi sie wydaje ale zobaczymy

;A zmieniona wersja typu?
;oczywiscie (musimy zwracac tego samego typu a normalnie nie)

(define (f1 a b) b)

(define (my-good-foldr f acc xs)
  (if (null? xs)
      acc
      (my-good-foldr f (f (first xs) acc) (rest xs))))

(my-good-foldr + 0 (list 1 2 3 4 5))

(foldr f1 0 (list 1 2 3 4 5))
(foldr f1 1234 (list 1 2 3 4))

(my-good-foldr f1 0 (list 1 2 3 4 5))
(my-good-foldr f1 1234 (list 1 2 3 4))

(define/contract (my-bad-foldr f acc xs)
  (parametric->/c [a] (-> (-> a a a) a (listof a) a)) ;z drugim by nie dzialalo
  (if (null? xs)
      acc
      (my-bad-foldr f (f acc (first xs)) (rest xs))))

(my-bad-foldr f1 0 (list 1 2 3 4 5)) ;inne wyniki niz good-foldr
(my-bad-foldr f1 0 (list 1 2 3 4)) ;bo w innej kolejnosci argumenty

(define (f2 x acc)
  (number->string x))

(define/contract (snd-good-foldr f acc xs)
  (parametric->/c [a] (-> (-> a a a) a (listof a) a)) ;tutaj a nie ogranicza nas
  (if (null? xs)
      acc
      (snd-good-foldr f (f (first xs) acc) (rest xs))))

(snd-good-foldr f2 0 (list 1 2 3 4 5))
(my-good-foldr f2 0 (list 1 2 3 4 5))
;zminiony typ oczywiscie ograniczy (num->str nie przejdzie)





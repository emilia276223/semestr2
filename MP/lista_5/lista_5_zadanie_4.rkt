#lang plait

;dodanie x do wszystkich list w liście
(define (add-to-all x new-list);bierze: element, lista list
  (cond [(empty? new-list) (list)]
        [(empty? (rest new-list)) (list (cons x (first new-list)))]
        [else (append (list (cons x (first new-list)))
                 (add-to-all x (rest new-list)))]));zwraca: lista list

;dodanie x do wszystkich z obu list
(define (fpom1 x xl ys);bierze: element, lista, lista
  (let ([new-list (perms (append xl ys))])
    (add-to-all x new-list)));zwraca: lista list

;wszystkie permutacje z pierwszym x lub z drugiej listy
(define (perms2 ll x lr);bierze: lista, element, lista
  (cond [(empty? lr) (fpom1 x ll lr)]
  [else (append (fpom1 x lr ll)
          (perms2 (cons x ll) (first lr) (rest lr)))]));zwraca: lista list

;wszystkie permutacje listy
(define (perms l);bierze: lista
  (cond [(empty? l) (list (list))]
        [(empty? (rest l)) (list l)]
        [else (perms2 (list) (first l) (rest l))]));zwraca: lista list 

;testy
(first (perms (list 1 2 3 4 5 6 7 8 9)))
(second (perms (list 1 2 3 4 5 6 7 8 9)))

(second (perms (list 1 2 1 4 1 6 7 8 9)))

(perms (list 1 2 1 4 ))

(define (silnia n)
  (cond [(= n 0) 1]
        [(= n 1) 1]
        [else (* (silnia (- n 1)) n)]))



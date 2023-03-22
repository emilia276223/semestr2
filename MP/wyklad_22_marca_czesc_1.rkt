#lang racket

;typy

;Just in Time - technika, żeby w beztypowych językach nadal mieć wydajność
;(interpretuje program w trakcie dzialania i wiedząc niektóre rzeczy może wygenerować sobie kod z konkretnymi typami danych)
;jesli dane rzeczy (fukcje) są używane z różnymi typami danych to generuje sobie wszystkie wersje => strasznie dużo pamięci zabiera

;Ahead Of Time - w językach typowanych, kompilator od razu "wszystko" wie

;korzyści typów:
    ;łatwość refactoringu kodu
    ;jakies inne, tak gada ze sie nie da sluchac
    ;"automatyczna" dokumentacja???

;niektóre systemy typów wyrażają mniej (np w c sie nic nie da zrobic, wiec robi sie jakies rzutowania i cos => ucieka sie od niego
;=> z powrotem sie wszystko psuje), a niektóre mogą więcej

;BEZPIECZENSTWO
;typy zabezpieczaja przed tym, że użytwownik coś pomiesza i popsuje wszystko tym (jakieś niedozwolone rzeczy są
; uniemożliwione przez system typów)

;w niektórych językach masz "tajne dane", których użytkownik nie może zobaczyć

;w ruscie kontroluje sie zarzadzanie pamiecią (np nie da sie podwojnie zwolnic pamieci czy zrobic wycieku
;chroni sie tam też przed wspolbieżnością (w sensie że kilka wątków i by sobie mieszały dane)

;przykład jezyka typowanego na którym będziemy się uczyć: PLAIT
;(bo typowany racket ma system typów, który nie jest naturalny ani nic wiec nie ma to sensu)



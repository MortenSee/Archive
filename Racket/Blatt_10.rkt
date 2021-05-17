#lang racket

#|

|#
(define spielfeld   #(0 0 0 0 0 9 0 7 0
                      0 0 0 0 8 2 0 5 0
                      3 2 7 0 0 0 0 4 0
                      0 1 6 0 4 0 0 0 0
                      0 5 0 0 0 0 3 0 0
                      0 0 0 0 9 0 7 0 0
                      0 0 0 6 0 0 0 0 5
                      8 0 2 0 0 0 0 0 0
                      0 0 4 2 0 0 0 0 8))
(define *spielfeld* (vector-copy spielfeld))

(define test        #(1 2 3 1 2 3 1 2 3
                      4 5 6 4 5 6 4 5 6
                      7 8 9 7 8 9 7 8 9
                      1 2 3 1 2 3 1 2 3
                      4 5 6 4 5 6 4 5 6
                      7 8 9 7 8 9 7 8 9
                      1 2 3 1 2 3 1 2 3
                      4 5 6 4 5 6 4 5 6
                      7 8 9 7 8 9 7 8 9))
(define *test* (vector-copy test))

;------------------------------1.1.1

;Eine Umgekehrte Version des modulo
;Alle 9 einträge fängt eine neue Spalte an.
(define (xy->id x y)
  (+ x (* y 9)))

;------------------------------1.1.2

;Die Indizes der Zeile sind die 0-8 + 9 * die Zeilenzahl
(define (row->id y)
  (build-list 9 (lambda (x) (+ x (* y 9)))))

;Die Spalten-indizes sind die Indizes der ersten spalte + 1 * die Spaltenzahl.
(define (col->id x)
  (map + '(0 9 18 27 36 45 54 63 72) (make-list 9 (* x 1))))

;Eine hilfsliste für die berechnung der indizes der quadranten
(define helper '(0 3 6 27 30 33 54 57 60))

;Die koordinaten des 0-ten quadranten werden als basis genommen. Zu ihnen addieren wir den nötigen offset, welcher in helper steht.
(define (quad->id q)
  (map + '(0 1 2 9 10 11 18 19 20) (make-list 9 (list-ref helper q))))

;------------------------------1.1.3

(define (get-id-val game xs)
  (if (null? xs) '()
      (cons (vector-ref game (first xs)) (get-id-val game (cdr xs)))))

;---------------------------------1.1.4

(define funcs  '(row->id col->id quad->id))
(define 0bis8 (range 9))

;Entfernt jede 0 aus einer Liste.
(define (remove-0s xs)
  (filter-not zero? xs))

;Überpüft ob die Reihe/Zeile/Quadrant konsistent ist
;game    -- Ein Spielfeld-Vector
;id-func -- Eine der Indize Funktionen zu Reihe/Zeile/Quader
;id      -- Die Reihe/Zeile/Quader der Überpfüft werden soll
(define (konsistent? game id-func id)
  (if (boolean? (check-duplicates (remove-0s (get-id-val game ((eval id-func) id))))) #t
      #f))

;Überprüft ob alle möglichkeiten der Reihe/Zeile/Quader konsistent sind
;game    -- Spielfeld-Vector
;id-func -- Eine der Indize-Funktionen zu Reihe/Zeile/Quader
(define (ID-consistency game id-func)
  (map (curry (curry konsistent? game) id-func) 0bis8))

;Überprüft ob alle möglichen Reihen, Zeilen und Quader konsistent sind.
;game -- Ein Spielfeld-Vector
(define (all-ID-consistency game)
  (map (curry ID-consistency game) funcs))

;Ein Spielzustand ist konsistent wenn alle Reihen UND alle Zeilen UND alle Quader konsistent sind
;Das heißt das in (all-ID-consistency spiel) nur #t steht.
(define (spiel-konsistent? spiel)
  (foldl (lambda (x result)(and x result)) #t (flatten (all-ID-consistency spiel))))

;Ein Spiel ist gelößt  <=>  (kein Feld ist 0) UND (spiel-konsistenz? spiel) => #t
(define (spiel-geloest? game)
  (if (and (= (vector-count zero? game) 0)
           (spiel-konsistent? game))       #t
                                           #f))


;---------------------------------1.2.1


; floor(x/9) => reihe
(define (getRow x)
  (floor (/ x 9) ))
;(x mod 9) => Spalte
(define (getCol x)
  (modulo x 9))
;Quader => berechenbar aus (reihe mod 3) und (zeile mod 3)
; 0,0 1,0 2,0
; 0,1 1,1 2,1
; 0,2 1,2 2,2
;Box = index_1 + 3* index_2 für (index_1, index_2)
(define (getQuad x)
  (+ (modulo (floor (/ (getCol x) 3)) 3) (* 3 (modulo (floor (/ (getRow x) 3)) 3))))

;Wenn in der Reihe/Zeile/Quadrant von index irgendwo n steht, darf es nicht mehr in index geschrieben werden -> muss 'X werden
(define (compute-if-X game index n)
  (if (or (row-contains-n? game index n) (col-contains-n? game index n) (quad-contains-n? game index n)) 'X
      0))

;Hilfspredikate die abfragem ob in der Reihe/Zeile/Quadrant von Index die Zahl n vorkommt
(define (row-contains-n? game index n)
  (if (boolean? (member n (get-id-val game (row->id (getRow index))))) #f
       #t))

(define (col-contains-n? game index n)
  (if (boolean? (member n (get-id-val game (col->id (getCol index))))) #f
       #t))

(define (quad-contains-n? game index n)
  (if (boolean? (member n (get-id-val game (quad->id (getQuad index))))) #f
       #t))



;Annotieren des Spielfelds für eine gegebene Zahl n
; Für  jede Zelle des Vectors  : Wenn Die Zelle 0 ist : Wenn Reihe, Zeile oder der Quader n enthählt -> Zelle wird 'X
(define (annotiere-spielfeld
         game                ;Das Spielfeld
         copy                ;Eine Kopie des Spielfelds zum auslesen der Werte | Das Spielfeld wird in jedem Schritt verändert, die Kopie bleibt gleich 
         start               ;Ein Startwert : Immer 0 wenn man das ganze Feld durchlaufen möchte
         n)                  ;Der gesuchte Wert für welchen annotiert werden soll
  
  (let ([cell-value (vector-ref copy start)]) ;Der Wert der Zelle mit index = start
    (if (= start 80)  (if (= cell-value 0) (my-vector-set! game start (compute-if-X copy start n)) ;Der letze annotierungs-durchlauf
                                           (my-vector-set! game start cell-value))
 
        (if (and (number? cell-value) (= cell-value 0)) (annotiere-spielfeld                                    ;Andernfalls überprüfen wir ob unsere derzeitige Zelle wert 0 hat, denn nur diese wollen wir verändern.
                              (my-vector-set! game start (compute-if-X copy start n))   ;Wenn ja, übergeben wir als Spielfeld für den nächsten schritt die annotierte variante des jetztigen
                              copy                                                   ;Die Kopie bleibt die selbe
                              (+ start 1)                                            ;Wir gehen einen index weiter
                              n)                                                     ;Aber suchen nach der selben Zahl wie vorher
           
             (annotiere-spielfeld
              game
              copy
              (+ start 1)                                   ;Wenn wir keine 0 sind gehen wir einfach einen Schritt weiter
              n)))))                 

;Hilffunktion für die annotiere-.. funktion. Das racket/base set-vector! returned keinen vector.
;my-vector-set! returned the veränderten vector.
(define (my-vector-set! v id val)
  (let* ([vec (vector-set! v id val)]
        [return (vector-map (lambda (x) x) v)])
    return))



;------------------------1.2.2

;Die Wrapper funktion bei der ein spielfeld und die gesuchte Zahl angegeben wird.
;zurückgegeben werden alle eindeutigen positonen
(define (eindeutige-positionen game n)
  (filter-not null? (finde-eindeutige-pos (annotiere-spielfeld (vector-copy game) (vector-copy game) 0 n) 0))) 






;Die Funktion die zum heraussuchen der eindeutigen positionen verwendet wird.
;game     :ein Spielfeld
;n        :die Zahl für welche die eindeutigen positionen bestimmt werden sollen.
;index    :laufindex für rekursion
(define (finde-eindeutige-pos game index)
  (if (= index 80) '()
      (cons (possible-position (vector-copy game) index)
            (finde-eindeutige-pos (vector-copy game) (+ index 1)))))


;Hilfsfunktion für die suche nach den eindeutigen positionen.
;gibt den index zurück, wenn eines der drei predikate true ist.
(define (possible-position game index)
  (if (or (only-0-in-row? game index) (only-0-in-col? game index) (only-0-in-quad? game index)) index
      '()))

;Hilfspredikate , #t wenn index die einzige 0 in der Reihe/Zeile/Quadrant ist.
(define (only-0-in-row? game index)
  (if (and (number? (vector-ref game index)) (= (vector-ref game index) 0)) (if (= 1 (count zero? (filter number? (get-id-val game (row->id (getRow index)))))) #t
                                        #f)
      #f))

(define (only-0-in-col? game index)
  (if (and (number? (vector-ref game index)) (= (vector-ref game index) 0)) (if (= 1 (count zero? (filter number? (get-id-val game (col->id (getCol index)))))) #t
                                         #f)
      #f))

(define (only-0-in-quad? game index)
  (if (and (number? (vector-ref game index)) (= (vector-ref game index) 0)) (if (= 1 (count zero? (filter number? (get-id-val game (quad->id (getQuad index)))))) #t
                                         #f)
      #f))

;-------------------------- 1.2.3

;Die Funktion die ein Sudoku spiel löst.
(define (loese-spiel game)
  (let ([moeglichePosAllerZahlen (solve-positions *spielfeld*)])
    (if (null? (filter-not null? moeglichePosAllerZahlen)) '() ;Wenn die liste aller moegliche Positionen für alle Zahlen leer ist, ist es ohne Backtracking nicht lösbar
        (loese-spiel (update-game *spielfeld*)))))             ;Ansonsten können wir Zahlen eintragen (update-game...) und versuchen dafür eine lösung zu finden.


;Die moeglichen Werte eines Feldes in Sudoku.
(define moeglicheWerte (range 1 10))


;Die Funktion die für alle möglichen Werte alle möglichen positionen heraussucht.
(define (solve-positions game)
  (map (curry eindeutige-positionen (vector-copy game)) moeglicheWerte))

(define (update-game game)
  (for-each (curry update-for-n game) moeglicheWerte))


(define (update-for-n game n)
  (for-each (curryr (curry vector-set! game) n) (list-ref (solve-positions game) (- n 1))))



;------------------------------------ 1.3.1
 (require 2htdp/image)

(define (draw-game game)
  (apply above (map (curryr draw-row game) 0bis8)))


;Die Funktion die eine Reihe unseres Spielfeldes malt
(define (draw-row row game)
  (apply beside (map (lambda (x) (if (zero? x) (square 15 "outline" "black")
                                     (overlay (text (number->string x) 12 "black") (square 15 "outline" "black")))) (get-id-val *spielfeld* (row->id row)))))



(draw-game *spielfeld*)
(loese-spiel *spielfeld*)
(draw-game *spielfeld*)











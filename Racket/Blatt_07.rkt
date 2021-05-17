#lang racket
(require racket/trace 2htdp/image 2htdp/universe)
#|Zählen
Definieren Sie eine Funktion zaehlen, die einen Wert x sowie eine Liste
von Werten xs als Argumente annimmt und ermittelt, wie oft der Wert in
der Liste vorkommt.

Programmieren sie diese als
-Allgemeine rekursive funktion
-endrekurisve funktion
-mittels geeigneter funktion höherer Ordnung
|#
;Allgemeine reukrsion
(define (reCount x xs)
  (if (= 0 (length xs)) 0
       (+ (if (= x (car xs)) 1 0) (reCount x (cdr xs)))))
;(trace reCount)

;Endrekursive Funktion -- Wrapper
(define (endCount x xs)
  (count x xs 0))

;Die aufgerufene Endrekursive Funktion
(define (count x xs akk)
  (if (= (length xs) 0) akk
      (count x (cdr xs) (+ (if (= x (car xs)) 1 0) akk))))
;(trace count)

;Mit Funktion Höherer Ordnung
;Mittels filter und dem gleichheitsprädikat auf liste des gesuchten elements reduziert, dessen länge dann gezählt.
(define (hoCount x xs)
  (length (filter (lambda (a) (= x a)) xs)))
;(trace hoCount)


;Bsp:
(reCount 2 '(1 2 2 3 5 2 1 7 19 21))
;>3
(reCount 6 '(1 2 2 3 5 2 1 7 19 21))
;>0

(endCount 2 '(2 1 4 5 15 17 62 1 2 3 4 2))
;>3
(endCount 15 '(2 1 4 5 15 17 51 1 5 62 1 2 3 4 2))
;>1

(hoCount 2 '(2 1 4 5 6 7 12 14 19 2))
;>2
(hoCount 1 '(2 1 4 5 6 7 12 14 19 1 1 1 11 2))
;>4

#| Game of Life
Regeln:
Eine Zelle ist entweder:
-Am Leben -> Schwarz ausgefüllt
-Tot -> Weiß ausgefüllt mit schwrzem Rand

Im nächsten schritt sind all jene Zellen am Leben die:
-Am leben sind UND (= 2 lebende-nachbarn) haben
-Tot sind UND (= 3 lebende-nachbarn) haben
Alle restlichen Zellen sind demnach tot.

--Notizen: Nachbarn
x x x                                                           {(i-1,j-1),(i,j-1),(i+1,j-1)}
x A x  Alle x sind Nachbar von A als indize also (A = (i,j)) M= {(i-1,j)  ,-------,(i+1,j)  }
x x x                                                           {(i-1,j+1),(i,j+1),(i+1,j+1)}

--Vorgehen:
Wir starten mit random besetzung des arrays/2dVektor von 0-en und 1en
wir füllen eine neue matrix mit den werten für den n+1en schritt und stellen diesen dar.
wir füllen die ursprüngliche matrix mit den werten für den n+2en schritt und stellen diese dar usw...


--Datenstruktur des Spielfelds: Liste von Vectors (Liste von Reihen)

Das Spielfeld besteht aus N reihen, jede Reihe besteht aus N Einträgen von entweder 0 oder 1.
eine Reihe ist ein Vector von N vielen 0en oder 1en
ein  Spielfeld ist eine Liste von N vielen Reihen

Eine Reihe ist hierbei eine Vector und keine Liste da Vectors in racket mutable sind, Listen jedoch nicht
Dies ist von vorteil da wir den Spielstand immer wieder aktualisieren wollen ohne ein ganz neues Spielfeld zu erzeugen.
|#

;für variable Spielfeldgröße hier als globale Variable
(define *spielfeld-dim* 30)

(define *spielfeld* (list '()))
(define *nextSpielfeld* (list '()))

;Die funktion die eine Spielfeld-reihe baut. Eine Spielfeld-reihe ist ein Vector mit n Einträgen bestehend aus 0 oder 1.
(define (baue-reihe n)
      (build-vector n (lambda (x) (random 2))))

;Ein Leerer n langer vektor.
(define (leereReihe n) (make-vector n 0))

;Das bauen eines Spielfelds
;Durch itteration wird ein Spielfeld mit Reihen befüllt.
(define (newSpielfeld ID)
  (for ([i (in-range 30)])
    (set! ID (cons (baue-reihe 30) ID)))
  (remove '() ID))

(define (build-leeres-spielfeld ID)
  (for ([i (in-range 30)])
    (set! ID (cons (leereReihe 30) ID)))
  (remove '() ID))

;Wir setzen unsere globalen variablen neu als gefüllte version eines Spielfeldes
(set! *spielfeld* (newSpielfeld *spielfeld*))
(set! *nextSpielfeld* (build-leeres-spielfeld *nextSpielfeld*))


;Zusammenbauen des F-Pentomino state von Wikipedia
;Als Leeres Feld initialisieren
(define *f-Pentomino* (list '()))
(set! *f-Pentomino*  (build-leeres-spielfeld *f-Pentomino*))

;Ein 5x5 feld in der mitte korrekt befüllen
(vector-set! (list-ref *f-Pentomino* 15) 14 1)
(vector-set! (list-ref *f-Pentomino* 14) 15 1)
(vector-set! (list-ref *f-Pentomino* 15) 15 1)
(vector-set! (list-ref *f-Pentomino* 16) 15 1)
(vector-set! (list-ref *f-Pentomino* 14) 16 1)


;Zwischen returned die subliste von index a bis b-1 des Vectors xs
;sofern a<b kann man für alle nicht Eck-zellen die korrekten Nachbarn erhalten.
;die anderen beiden Fälle werden verwendet um die korrekten nachbarn der Eck-zellen herauszusuchen.
(define (zwischen a b xs)
  (let ([xs-lis (vector->list xs)])
    (cond
      [(< a b) (list-tail (take xs-lis (+ 1 b)) a)]                           ;Der Fall für alle nicht-Ecken
      [(= a 29) (flatten `(,(take xs-lis 2) ,(take (reverse xs-lis)1)))]   ;Der Falle für die linken zwei Ecken 
      [(= a 28) (flatten `(,(take (reverse xs-lis) 2) ,(take xs-lis 1)))]))) ;Der Falle für die linken zwei Ecken


;Die Liste der 9 Felder um (inkl.) Zelle A herum. Das spielfeld greift hierbei um Kanten herum sodass der rechte Nachbar von index n-1 wieder index 0 ist usw. 
;N N N
;N A N  Für A als (x,y) gibt neighbors die Liste aus allen N und A zurück.
;N N N 
(define (neighbors x y grid grid-dim)
  (flatten (list
            (zwischen (modulo (+ x -1 grid-dim) grid-dim) ;x startwert ;ein platz links von x
                      (modulo (+ x 1 grid-dim) grid-dim)  ;x endwert ; ein platz rechts von x , hier +2 und nicht +1, da "zwischen" bis inkl. index b-1 geht.
                      (list-ref grid (modulo (+ y -1 grid-dim) grid-dim))) ;Die Reihe über y
            (zwischen (modulo (+ x -1 grid-dim) grid-dim)
                      (modulo (+ x 1 grid-dim) grid-dim)
                      (list-ref grid (modulo (+ y 0 grid-dim) grid-dim))) ;Die Reihe y
            (zwischen (modulo (+ x -1 grid-dim) grid-dim)
                      (modulo (+ x 1 grid-dim) grid-dim)
                      (list-ref grid (modulo (+ y 1 grid-dim) grid-dim)))))) ;Die Reihe unter y


;Gibt den Wert der Zelle (x,y) zurück
(define (getValue x y)
  (vector-ref (list-ref *spielfeld* y) x))


;Zählt die 1en in der Liste der Nachbarn von (neighbor ..), nimmt sich selbst mittels remove wieder heraus
(define (countAliveNeighbors x y)
  (hoCount 1 (remove (getValue x y) (neighbors x y *spielfeld* *spielfeld-dim*))))


;Berechnet den nächsten Zustand einer Zelle anhand dessen lebendigen Nachbarn sowie dem eigenen Wert.
;Als aliveNeighbors übergibt man einen aufruf von (countAliveNeighbors ..) als cell-Value den aufruf (getValue ..)
(define (computeNextState NumAliveNeighbors cell-Value)
  (cond
    [(= cell-Value 1) (if (or (= NumAliveNeighbors 2) (= NumAliveNeighbors 3)) 1 0)] ;Lebende Zellen lebt in nächsten Schritt <=> 2 oder 3 Lebende Nachbarn
    [(= cell-Value 0) (if (= NumAliveNeighbors 3) 1 0)])) ;Tote Zellen lebt in nächsten Schritt <=> 3 Lebende Nachbarn


;Die Funktion die die nächste Generation anhand *spielfeld* errechnet und in *nextSpielfeld* einträgt, danach dann *nextSpielfeld* auf *spielfeld* kopiert.
(define (updateSpielfeld)
  (for* ([i (in-range 30)]
            [j (in-range 30)])
    (vector-set! (list-ref *nextSpielfeld* i) j (computeNextState (countAliveNeighbors j i) (getValue j i))))
  (set! *spielfeld* *nextSpielfeld*)
  (set! *nextSpielfeld* (build-leeres-spielfeld *nextSpielfeld*)))


;Die Funktion die eine Reihe unseres Spielfeldes malt
(define (draw-row row)
  (apply beside (map (lambda (x) (if (= x 0) (square 10 "outline" "black") (square 10 "solid" "black"))) (vector->list row))))


;Mal itterativ alle dim - vielen reihen des Spielbrettes untereinander
(define (draw-gameboard board dim step)
  (if (= step (- dim 2)) (above (draw-row (list-ref *spielfeld* step)) (draw-row (list-ref *spielfeld* 29) ))
      (above (draw-row (list-ref *spielfeld* step)) (draw-gameboard board dim (+ 1 step))) ))


;Ein Weißer Background für unser Spielfeld
(define background (empty-scene 300 300 "white"))


;Ein Gamestate ist der aktuelle zustand über dem Background angezeigt.
(define (gamestate a) (place-image (draw-gameboard *spielfeld* *spielfeld-dim* 0) 150 150 background))


;Alternative Draw-schleifen für F-Pentomino
;--------------------------------------------------------------------------
(define (getPentoValue x y)
  (vector-ref (list-ref *f-Pentomino* y) x))

(define (countAlivePento x y)
  (hoCount 1 (remove (getPentoValue x y) (neighbors x y *f-Pentomino* *spielfeld-dim*))))

(define (draw-Pento dim step)
  (if (= step (- dim 2)) (above (draw-row (list-ref *f-Pentomino* step)) (draw-row (list-ref *f-Pentomino* 29) ))
      (above (draw-row (list-ref *f-Pentomino* step)) (draw-Pento dim (+ 1 step))) ))

(define (updatePento)
  (for* ([i (in-range 30)]
            [j (in-range 30)])
    (vector-set! (list-ref *nextSpielfeld* i) j (computeNextState (countAlivePento j i) (getPentoValue j i))))
  (set! *f-Pentomino* *nextSpielfeld*)
  (set! *nextSpielfeld* (build-leeres-spielfeld *nextSpielfeld*)))

(define (pentoGame a) (place-image (draw-Pento *spielfeld-dim* 0) 150 150 background))
;--------------------------------------


;Die Animations-aufrufe
;---------------------------------------------------------------------------
(define (pento-game-of-life t)
  (begin (updatePento) (pentoGame 0)))
;---------------------------------------------------------------------------
(define (random-game-of-life t)
  (begin (updateSpielfeld) (gamestate 0)))
;----------------------------------------------------------------------------
(animate random-game-of-life)